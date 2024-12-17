package auth

import (
	"go/auth/pkg/req"
	"go/auth/pkg/res"
	"net/http"
	"time"
)

type AuthHadlerDeps struct {
	AuthService *AuthService
}

type AuthHadler struct {
	AuthService *AuthService
}

func NewAuthHandler(router *http.ServeMux, deps AuthHadlerDeps){
	handler := &AuthHadler{
		AuthService: deps.AuthService,
	}

	router.HandleFunc("POST /login", handler.Login())
	router.HandleFunc("POST /registration", handler.Registration())
	router.HandleFunc("POST /auth", handler.Auth())
}

func (handler *AuthHadler) Login() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CheckUserRequest](r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		
		acToken, err := handler.AuthService.Login(*body)
		if err != nil{
			if err.Error() == ErrNonValidData{
				http.Error(w, err.Error(), http.StatusBadRequest)
			}else {
				http.Error(w, err.Error(), http.StatusInternalServerError)
			}
			return 
		}

		cookie := &http.Cookie{
					Name: "access_token",
					Value: acToken,
					Path: "/",
					Expires: time.Now().Add(1*time.Hour),
				}
		http.SetCookie(w, cookie)
		res.JSON(w, Token{AccessToken: acToken}, 200)
	}
}

func (handler *AuthHadler) Registration() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[RegistrationRequest](r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		acToken, err := handler.AuthService.Registration(*body)
		if err != nil{
			if err.Error() == ErrNonValidData{
				http.Error(w, err.Error(), http.StatusBadRequest)
			}else {
				http.Error(w, err.Error(), http.StatusInternalServerError)
			}
			return 
		}

		cookie := &http.Cookie{
					Name: "access_token",
					Value: acToken,
					Path: "/",
					Expires: time.Now().Add(1*time.Hour),
					Domain: "localhost",
				}
		http.SetCookie(w, cookie)
		res.JSON(w, Token{AccessToken: acToken}, 201)
	}
}

func (handler *AuthHadler) Auth() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[Token](r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		isVAlid, token, email := handler.AuthService.Auth(*body)

		if isVAlid{
			if body.AccessToken == token{
				res.JSON(w, EmailResponse{Email: email}, 200)
			}else{
				newACToken, err := handler.AuthService.createToken(email, handler.AuthService.Secret)
				if err != nil{
					http.Error(w, "token non valid", http.StatusBadRequest)
				}

				cookie := &http.Cookie{
					Name: "access_token",
					Value: newACToken,
					Expires: time.Now().Add(1*time.Hour),
					SameSite: http.SameSiteNoneMode,
				}

				http.SetCookie(w, cookie)
				res.JSON(w, EmailResponse{Email: email}, 200)
			}
		} else{
			http.Error(w, "token non valid", http.StatusForbidden)
		}
	}
}
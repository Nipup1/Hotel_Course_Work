package user

import (
	"go/user/pkg/middleware"
	"go/user/pkg/req"
	"go/user/pkg/res"
	"net/http"
	"strconv"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserHandlerDeps struct {
	UserRepository *UserRepository
}

type UserHandler struct {
	UserRepository *UserRepository
}

func NewUserHandler(router *http.ServeMux, deps UserHandlerDeps){
	hadler := &UserHandler{
		UserRepository: deps.UserRepository,
	}

	router.HandleFunc("POST /user", hadler.Create())
	router.Handle("PATCH /user/{id}", middleware.Auth(hadler.Update()))
	router.HandleFunc("PATCH /user", hadler.UpdateToken())
	router.HandleFunc("GET /user/{email}", hadler.GetByEmail())
	router.Handle("GET /user", middleware.Auth(hadler.Get()))
	router.HandleFunc("DELETE /user/{id}", hadler.Delete())
	router.HandleFunc("POST /user/check", hadler.CheckUser())
	router.HandleFunc("POST /user/token", hadler.GetRefreshToken())
}

func (handler *UserHandler) Create() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CreateRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		existedUser, _ := handler.UserRepository.GetByEmail(body.Email)
		if existedUser != nil{
			http.Error(w, "user alredy existed", http.StatusBadRequest)
			return
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(body.Password), bcrypt.DefaultCost)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		user := &User{
			Email: body.Email,
			Password: string(hashedPassword),
			Name: body.Name,
		}

		handler.UserRepository.Create(user)

		res.JSON(w, user, 201)
	}
}

func (handler *UserHandler) Update() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[UpdateRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		idString := r.PathValue("id")
		id, err := strconv.ParseUint(idString, 10, 32)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		hashedPassword := []byte{}
		if body.Password != ""{
			hashedPassword, err = bcrypt.GenerateFromPassword([]byte(body.Password), bcrypt.DefaultCost)
			if err != nil{
				http.Error(w, "", http.StatusInternalServerError)
				return
			}
		}

		user, err := handler.UserRepository.Update(&User{
			Model: gorm.Model{
				ID: uint(id),
			},
			Name: body.Name,
			Password: string(hashedPassword),
		})
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		resp := &UserResponse{
			Id: user.ID,
			Email: user.Email,
			Name: user.Name,
		}

		res.JSON(w, resp, 200)
	}
}

func (handler *UserHandler) UpdateToken() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[UpdateTokenRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		user, err := handler.UserRepository.GetByEmail(body.Email)
		if err != nil{
			http.Error(w, "user not found", http.StatusBadRequest)
			return
		}
		user.Token = body.Token

		user, err = handler.UserRepository.Update(user)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		res.JSON(w, user, 200)
	}
}

func (handler *UserHandler) GetByEmail() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		email := r.PathValue("email")
		user, err := handler.UserRepository.GetByEmail(email)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		resp := &GetUserResponse{
			Id: user.ID,
			Email: user.Email,
			Name: user.Name,
		}

		res.JSON(w, resp, 200)
	}
}

func (handler *UserHandler) Get() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		userId, ok := r.Context().Value(middleware.ContextEmailKey).(uint)
		if !ok {
			http.Error(w, "попа", http.StatusInternalServerError)
			return
		}

		user, err := handler.UserRepository.Get(userId)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
		}

		res.JSON(w, user, http.StatusOK)
	}
}

func (handler *UserHandler) Delete() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		
	}
}

func (handler *UserHandler) CheckUser() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CheckUserRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		user, err := handler.UserRepository.GetByEmail(body.Email)
		if err != nil{
			http.Error(w, "user not found", http.StatusBadRequest)
			return
		}

		err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(body.Password))
		if err != nil{
			http.Error(w, "bad password", http.StatusBadRequest)
			return
		}

		res.JSON(w, user, 200)
	}
}

func (handler *UserHandler) GetRefreshToken() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[GetRefreshTokenRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}
		
		user, err := handler.UserRepository.GetByEmail(body.Email)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
	
		resp := &GetRefreshTokenResponse{
			Token: user.Token,
		}

		res.JSON(w, resp, 200)
	}
}
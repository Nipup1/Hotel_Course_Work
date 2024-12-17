package middleware

import (
	"context"
	"encoding/json"
	"go/user/pkg/req"
	"net/http"
	"strings"
)

type TokenRequest struct {
	Token string `json:"access_token"`
}

type EmailResponse struct {
	Email string `json:"email"`
}

type EmailIdResponse struct {
	Id    uint   `json:"id"`
	Email string `json:"email"`
}

type key string

const (
	ContextEmailKey key = "UserIdKey"
)

func writeUnauthed(w http.ResponseWriter) {
	w.WriteHeader(http.StatusForbidden)
	w.Write([]byte(http.StatusText(http.StatusForbidden)))
}

func Auth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authedHeader := r.Header.Get("Authorization")
		if !strings.HasPrefix(authedHeader, "Bearer ") {
			writeUnauthed(w)
			return
		}

		token := strings.TrimPrefix(authedHeader, "Bearer ")
		bodyR, err := req.BodyForRequest(&TokenRequest{Token: token})
		if err != nil {
			writeUnauthed(w)
			return
		}

		reqToAuth, err := http.Post("http://localhost:8082/auth", "application/json", bodyR)
		if err != nil {
			writeUnauthed(w)
			return
		}
		if reqToAuth.StatusCode != 200 {
			writeUnauthed(w)
			return
		}

		for _, value := range reqToAuth.Cookies() {
			http.SetCookie(w, value)
		}

		var emailResp EmailResponse
		json.NewDecoder(reqToAuth.Body).Decode(&emailResp)

		reqToUser, err := http.Get("http://localhost:8083/user/" + emailResp.Email)
		if err != nil {
			writeUnauthed(w)
			return
		}
		if reqToAuth.StatusCode != 200 {
			writeUnauthed(w)
			return
		}
		var emailIdResp EmailIdResponse
		json.NewDecoder(reqToUser.Body).Decode(&emailIdResp)

		ctx := context.WithValue(r.Context(), ContextEmailKey, emailIdResp.Id)
		req := r.WithContext(ctx)

		next.ServeHTTP(w, req)
	})
}

package main

import (
	"fmt"
	"go/auth/configs"
	"go/auth/internal/Auth"
	"go/auth/pkg/middleware"
	"net/http"
)

func main() {
	conf := configs.NewConfig()
	router := http.NewServeMux()

	//Service
	auhtService := auth.NewAuthService(conf)

	//Handler
	auth.NewAuthHandler(router, auth.AuthHadlerDeps{
		AuthService: auhtService,
	})

	server := http.Server{
		Addr: ":8082",
		Handler: middleware.CORS(router),
	}

	fmt.Println("Server is starting on port 8082")
	server.ListenAndServe()
}
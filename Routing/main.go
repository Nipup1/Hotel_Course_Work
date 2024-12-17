package main

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
)

func main() {
	router := http.NewServeMux

	server := &http.Server{
		Addr: ":8081",
		Handler: CORS(Redirect(router())),
	}

	fmt.Println("Server is starting on port 8081")
	server.ListenAndServe()
}

func Redirect(next http.Handler) http.Handler{
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		urlForRedirect := r.URL
		path := urlForRedirect.Path
		
		if strings.Contains(path, "user") || strings.Contains(path, "booking"){
			CreateNewUrl(urlForRedirect, "8083")
			http.Redirect(w, r, urlForRedirect.String(), http.StatusPermanentRedirect)
			return
		} else if strings.Contains(path, "hotel") || strings.Contains(path, "room"){
			CreateNewUrl(urlForRedirect, "8084")
			http.Redirect(w, r, urlForRedirect.String(), http.StatusPermanentRedirect)
			return
		} else if strings.Contains(path, "registration") || strings.Contains(path, "login"){
			CreateNewUrl(urlForRedirect, "8082")
			http.Redirect(w, r, urlForRedirect.String(), http.StatusPermanentRedirect)
			return
		} else {
			http.Error(w, "not found", http.StatusNotFound)
			return
		}
	})
}

func CreateNewUrl(url *url.URL, port string){
	url.Host = "localhost" + ":" + port
}

func CORS(next http.Handler) http.Handler { 
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {  
        origin := r.Header.Get("Origin")  
          
        // Установите CORS заголовки для всех запросов с установленным Origin  
        if origin != "" {  
            w.Header().Set("Access-Control-Allow-Origin", "*")  
            w.Header().Set("Access-Control-Allow-Credentials", "true")  
            w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE, PATCH")  
            w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")  
        }  
  
        // Обработка preflight-запроса  
        if r.Method == http.MethodOptions {  
            w.Header().Set("Access-Control-Max-Age", "86400") // Кэширование preflight запроса на 24 часа  
            w.WriteHeader(http.StatusOK)  
            return  
        }  
  
        // Вызов следующего обработчика  
        next.ServeHTTP(w, r)  
    })  
}  
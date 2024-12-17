package middleware

import (
	"net/http"
)

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

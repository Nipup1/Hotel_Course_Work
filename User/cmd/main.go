package main

import (
	"fmt"
	"go/user/configs"
	booking "go/user/internal/Booking"
	"go/user/internal/user"
	"go/user/pkg/db"
	"go/user/pkg/middleware"
	"net/http"
)

func main() {
	conf := configs.NewConfig()
	db := db.NewDb(conf)
	router := http.NewServeMux()

	//Repository
	userRepository := user.NewUserRepository(db)
	bookingRepository := booking.NewBookingRepository(db)

	//Handler
	user.NewUserHandler(router, user.UserHandlerDeps{
		UserRepository: userRepository,
	})
	booking.NewBookingHandler(router, booking.BookingHandlerDeps{
		BookingRepository: bookingRepository,
	})

	server := http.Server{
		Addr: ":8083",
		Handler: middleware.CORS(router),
	}

	fmt.Println("Server is listening on port 8083")
	server.ListenAndServe()
}
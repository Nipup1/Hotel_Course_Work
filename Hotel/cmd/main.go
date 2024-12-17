package main

import (
	"fmt"
	"go/hotel/configs"
	hotel "go/hotel/internal/Hotel"
	photo "go/hotel/internal/Photo"
	room "go/hotel/internal/Room"
	"go/hotel/pkg/db"
	"go/hotel/pkg/middleware"
	"net/http"
)

func main() {
	conf := configs.NewConfig()
	db := db.NewDb(conf)
	router := http.NewServeMux()

	//Repository
	photoRepository := photo.NewPhotoRepository(db)
	hotelRepository := hotel.NewHotelRepository(db)
	roomRepository := room.NewRoomRepository(db)

	//Services
	photoService := photo.NewPhotoService(*photoRepository)

	//Handler
	photo.NewAuthHandler(router, photo.PhotoHandlerDeps{
		PhotoService: photoService,
	})
	hotel.NewHotelHandler(router, hotel.HotelHandlerDeps{
		PhotoService: photoService,
		HotelRepository: hotelRepository,
	})
	room.NewRoomHandler(router, room.RoomHandlerDeps{
		PhotoService: photoService,
		RoomRepository: roomRepository,
	})

	server := http.Server{
		Addr: ":8084",
		Handler: middleware.CORS(router),
	}

	fmt.Println("Server is starting on port 8084")
	server.ListenAndServe()
}
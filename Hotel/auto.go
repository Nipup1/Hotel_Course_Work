package main

import (
	hotel "go/hotel/internal/Hotel"
	"go/hotel/internal/Photo"
	room "go/hotel/internal/Room"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	err := godotenv.Load()
	if err != nil{
		panic(err)
	}

	db, err := gorm.Open(postgres.Open(os.Getenv("DSN")), &gorm.Config{})
	if err != nil{
		panic(err.Error())
	}
	
	db.AutoMigrate(&photo.Photo{}, &hotel.Hotel{}, &room.Room{})
}
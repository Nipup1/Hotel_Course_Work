package main

import (
	booking "go/user/internal/Booking"
	"go/user/internal/user"
	"os"

	"github.com/lpernett/godotenv"
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
	
	db.AutoMigrate(&user.User{}, &booking.Booking{})
}
package user

import (
	booking "go/user/internal/Booking"

	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Email    string `gorm:"uniqIndex"`
	Password string
	Name     string
	Token 	 string
	Bookings []booking.Booking `gorm:"foreignKey:UserId"`
}
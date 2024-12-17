package hotel

import (
	photo "go/hotel/internal/Photo"
	room "go/hotel/internal/Room"

	"gorm.io/gorm"
)

type Hotel struct {
	gorm.Model
	Name string `json:"name"`
	Address string `json:"addres"`
	City string `json:"city"`
	Country string `json:"country"`
	Rating float32 `json:"rating"`
	Phone string `json:"phone"`
	Email string `json:"email"`
	Rooms []room.Room `json:"-" gorm:"foreignKey:HotelID"`
	Photo photo.Photo `json:"photo" gorm:"foreignKey:HotelID"`
	MinPrice uint `json:"min_price"`
}
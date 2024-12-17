package room

import (
	photo "go/hotel/internal/Photo"

	"gorm.io/gorm"
)

var roomTypes = []string{"Standard", "Double", "Family", "Suite", "Economy"}

type Room struct {
	gorm.Model
	RoomNumber    uint
	RoomType      string
	Capacity      uint
	PricePerNight uint
	Description   string
	Photos        []photo.Photo `gorm:"foreignKey:RoomID"`
	HotelID      uint
}

func ChekRoomType(roomType string) bool{
	isValid := false
	for _, rType := range roomTypes{
		if rType == roomType{
			isValid = true
			return isValid
		}
	}
	return isValid
}
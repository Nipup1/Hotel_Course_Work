package photo

import "gorm.io/gorm"

type Photo struct {
	gorm.Model
	PathToPhoto string
	RoomID      *uint
	HotelID      *uint
}
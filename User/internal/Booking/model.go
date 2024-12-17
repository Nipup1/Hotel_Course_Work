package booking

import "time"

type Booking struct {
	ID     uint `gorm:"primarykey"`
	CheckIn  time.Time
	CheckOut    time.Time
	HotelRoom string 
	UserId uint
}

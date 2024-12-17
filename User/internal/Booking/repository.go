package booking

import (
	"go/user/pkg/db"
	"time"
)

type BookingRepository struct {
	DB *db.Db
}

func NewBookingRepository(database *db.Db) *BookingRepository{
	return &BookingRepository{
		DB: database,
	}
}

func (repo *BookingRepository) Create(booking *Booking) (*Booking, error){
	result := repo.DB.Create(booking)
	if result.Error != nil{
		return nil, result.Error
	}

	return booking, nil
}

func (repo *BookingRepository) GetByHotelRoom(hotelRoom string, currTime time.Time) ([]Booking, error){
	var bookings []Booking
	result := repo.DB.Table("bookings").
		Where("hotel_room = ? AND check_out > ?", hotelRoom, currTime).
		Scan(&bookings)
	if result.Error != nil{
		return nil, result.Error
	}

	return bookings, nil
}

func (repo *BookingRepository) GetByUserId(userId uint) ([]Booking, error){
	var bookings []Booking
	result := repo.DB.Table("bookings").
		Where("user_id = ?", userId).
		Scan(&bookings)
	if result.Error != nil{
		return nil, result.Error
	}

	return bookings, nil
}
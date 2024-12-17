package booking

type GetBy struct{
	Bookings []Booking `json:"bookings"`
}

type CreateBookingRequest struct{
	Start  string `json:"check_in"`
	End    string `json:"check_out"`
	HotelRoom string `json:"hotel_room"`
}
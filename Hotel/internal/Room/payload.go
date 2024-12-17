package room

type CreateRoomRequest struct {
	RoomNumber    uint     `json:"room_number"`
	RoomType      string   `json:"room_type"`
	Capacity      uint     `json:"capacity"`
	PricePerNight uint     `json:"price_per_night"`
	Description   string   `json:"description"`
	Photos        []string `json:"paths"`
	HotelID       uint     `json:"hotel_id"`
}

type GetByTypeResponse struct{
	Rooms []Room `json:"rooms"`
}
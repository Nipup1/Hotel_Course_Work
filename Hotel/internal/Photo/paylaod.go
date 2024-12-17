package photo

type CreatePhotoRequest struct{
	PathToPhoto string `json:"path" validate:"filepath"`
	HotelID *uint `json:"hotel_id"`
	RoomID *uint `json:"room_id"`
}

type UpdateRequest struct{
	PathToPhoto string `json:"path"`
}
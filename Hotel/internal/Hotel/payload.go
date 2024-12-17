package hotel

import (
	room "go/hotel/internal/Room"
)

type CreateHotelRequest struct {
	Name        string  `json:"name"`
	Address     string  `json:"address"`
	City        string  `json:"city"`
	Country     string  `json:"country"`
	Rating      float32 `json:"rating"`
	Phone       string  `json:"phone"`
	Email       string  `json:"email"`
	PathToPhoto string  `json:"path"`
}

type GetByIdResponse struct {
	Id          uint        `id:"name"`
	Name        string      `json:"name"`
	Address     string      `json:"addres"`
	City        string      `json:"city"`
	Country     string      `json:"country"`
	Rating      float32     `json:"rating"`
	Phone       string      `json:"phone"`
	Email       string      `json:"email"`
	Rooms       []room.Room `json:"rooms"`
	PathToPhoto string      `json:"photo"`
	MinPrice    uint        `json:"min_price"`
}

type GetAllResponse struct {
	Hotels []Hotel `json:"hotels"`
	Count  int64   `json:"count"`
}

type GetCitiesResponse struct{
	Cities []string `json:"cities"`
}
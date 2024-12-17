package room

import (
	photo "go/hotel/internal/Photo"
	"go/hotel/pkg/req"
	"go/hotel/pkg/res"
	"net/http"
	"strconv"
)

type PhotoService interface {
	Create(photo.CreatePhotoRequest) (*photo.Photo, error)
}

type RoomHandlerDeps struct{
	PhotoService PhotoService
	RoomRepository *RoomRepository
}

type RoomHandler struct{
	PhotoService PhotoService
	RoomRepository *RoomRepository
}

func NewRoomHandler(router *http.ServeMux, deps RoomHandlerDeps){
	handler := &RoomHandler{
		PhotoService: deps.PhotoService,
		RoomRepository: deps.RoomRepository,
	}

	router.HandleFunc("POST /room", handler.Create())
	router.HandleFunc("GET /room/{hotel_id}/{type}", handler.GetByType())
}

func (handler *RoomHandler) Create() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CreateRoomRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		room := &Room{
			RoomNumber: body.RoomNumber,
			RoomType: body.RoomType,
			Capacity: body.Capacity,
			PricePerNight: body.PricePerNight,
			Description: body.Description,
			HotelID: body.HotelID,
		}

		room, err = handler.RoomRepository.Create(room)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return 
		}

		for _, value := range body.Photos{
			handler.PhotoService.Create(photo.CreatePhotoRequest{
				PathToPhoto: value, 
				HotelID: nil,
				RoomID: &room.ID,
			})
		}
		
		res.JSON(w, room, http.StatusOK)
	}
}

func (handler *RoomHandler) GetByType() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		idSting := r.PathValue("hotel_id")
		id, err := strconv.ParseUint(idSting, 10, 32)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		roomType := r.PathValue("type")
		
		rooms, err := handler.RoomRepository.GetByType(uint(id), roomType)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return 
		}

		resp := &GetByTypeResponse{
			Rooms: rooms,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}

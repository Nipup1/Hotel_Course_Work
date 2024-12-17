package hotel

import (
	photo "go/hotel/internal/Photo"
	"go/hotel/pkg/req"
	"go/hotel/pkg/res"
	"net/http"
	"strconv"
)

type PhotoService interface{
	Create(photo.CreatePhotoRequest) (*photo.Photo, error)
}

type HotelHandlerDeps struct {
	HotelRepository *HotelRepository
	PhotoService PhotoService
}

type HotelHandler struct {
	HotelRepository *HotelRepository
	PhotoService PhotoService
}

func NewHotelHandler(router *http.ServeMux, deps HotelHandlerDeps){
	handler := &HotelHandler{
		HotelRepository: deps.HotelRepository,
		PhotoService: deps.PhotoService,
	}

	router.HandleFunc("POST /hotel", handler.Create())
	router.HandleFunc("GET /hotel/{id}", handler.GetById())
	router.HandleFunc("GET /hotel", handler.GetAll())
	router.HandleFunc("GET /hotel/cities", handler.GetCities())
}

func (handler *HotelHandler) Create() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CreateHotelRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		hotel := &Hotel{
			Name: body.Name,
			Address: body.Address,
			City: body.City,
			Country: body.Country,
			Rating: body.Rating,
			Phone: body.Phone,
			Email: body.Email,
		}

		hotel, err = handler.HotelRepository.Create(hotel)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = handler.PhotoService.Create(photo.CreatePhotoRequest{
			PathToPhoto: body.PathToPhoto, 
			HotelID: &hotel.ID,
			RoomID: nil,
		})
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		res.JSON(w, hotel, http.StatusOK)
	}
}

func (handler *HotelHandler) GetAll() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		offset, err := strconv.Atoi(r.URL.Query().Get("offset"))
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		limit, err := strconv.Atoi(r.URL.Query().Get("limit"))
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		rating, _ := strconv.ParseFloat((r.URL.Query().Get("rating")), 64)

		priceFrom, _ := strconv.Atoi(r.URL.Query().Get("priceFrom"))

		name := r.URL.Query().Get("name")

		city := r.URL.Query().Get("city")

		hotels, count, err := handler.HotelRepository.GetAll(offset, limit, priceFrom, rating, city, name)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		resp := &GetAllResponse{
			Hotels: hotels,
			Count: count,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}

func (handler *HotelHandler) GetById() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		idString := r.PathValue("id")
		id, err := strconv.ParseUint(idString, 10, 32)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		hotel, err := handler.HotelRepository.GetById(uint(id))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		resp := &GetByIdResponse{
			Id: hotel.ID,
			Name: hotel.Name,
			Address: hotel.Address,
			City: hotel.City,
			Country: hotel.Country,
			Rating: hotel.Rating,
			Phone: hotel.Phone,
			Email: hotel.Email,
			Rooms: hotel.Rooms,
			PathToPhoto: hotel.Photo.PathToPhoto,
			MinPrice: hotel.MinPrice,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}

func (handler *HotelHandler) GetCities() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		cities := handler.HotelRepository.GetCities()

		resp := &GetCitiesResponse{
			Cities: cities,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}
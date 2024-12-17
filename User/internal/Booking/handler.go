package booking

import (
	"go/user/pkg/middleware"
	"go/user/pkg/req"
	"go/user/pkg/res"
	"net/http"
	"time"
)

type BookingHandlerDeps struct {
	BookingRepository *BookingRepository
}

type BookingHandler struct {
	BookingRepository *BookingRepository
}

func NewBookingHandler(router *http.ServeMux, deps BookingHandlerDeps){
	handler := &BookingHandler{
		BookingRepository: deps.BookingRepository,
	}

	router.Handle("POST /booking", middleware.Auth(handler.Create()))
	router.Handle("GET /booking", middleware.Auth(handler.GetByUserId()))
	router.HandleFunc("GET /booking/{hotel_room}", handler.GetByHotelRoom())
}

func (handler *BookingHandler) Create() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CreateBookingRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		checkIn, err := time.Parse(time.DateOnly, body.Start)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		checkOut, err := time.Parse(time.DateOnly, body.End)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		booking := &Booking{
			CheckIn: checkIn.Add(12 * time.Hour),
			CheckOut: checkOut.Add(9 * time.Hour),
			HotelRoom: body.HotelRoom,
			UserId: r.Context().Value(middleware.ContextEmailKey).(uint),
		}

		booking, err = handler.BookingRepository.Create(booking)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		res.JSON(w, booking, http.StatusOK)
	}
}

func (handler *BookingHandler) GetByHotelRoom() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		hotelRoom := r.PathValue("hotel_room")
		currTime, err := time.Parse(time.DateOnly ,r.URL.Query().Get("date"))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		bookings, err := handler.BookingRepository.GetByHotelRoom(hotelRoom, currTime.Add(10*time.Hour).UTC())
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		resp := &GetBy{
			Bookings: bookings,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}

func (handler *BookingHandler) GetByUserId() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		userId, ok := r.Context().Value(middleware.ContextEmailKey).(uint)
		if !ok {
			http.Error(w, "попа", http.StatusInternalServerError)
			return
		}

		bookings, err := handler.BookingRepository.GetByUserId(userId)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		resp := &GetBy{
			Bookings: bookings,
		}

		res.JSON(w, resp, http.StatusOK)
	}
}
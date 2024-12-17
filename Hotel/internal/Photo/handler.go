package photo

import (
	"go/hotel/pkg/req"
	"go/hotel/pkg/res"
	"net/http"
	"strconv"

	"gorm.io/gorm"
)

type PhotoHandlerDeps struct {
	PhotoService *PhotoService
}

type PhotoHandler struct {
	PhotoService *PhotoService
}

func NewAuthHandler(router *http.ServeMux, deps PhotoHandlerDeps) {
	handler := &PhotoHandler{
		PhotoService: deps.PhotoService,
	}


	router.HandleFunc("POST /photo", handler.Create())
	router.HandleFunc("GET /photo/{id}", handler.GetById())
	router.HandleFunc("PATCH /photo/{id}", handler.Update())
}

func (handler *PhotoHandler) Create() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := req.ParseBody[CreatePhotoRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return 
		}

		photo, err := handler.PhotoService.Create(*body)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return 
		}

		res.JSON(w, photo, http.StatusOK)
	}
}

func (handler *PhotoHandler) GetById() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		idString := r.PathValue("id")
		id, err := strconv.ParseUint(idString, 10, 32)
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return 
		}

		photo, err := handler.PhotoService.GetById(uint(id))
		if err != nil{
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return 
		}

		res.JSON(w, photo, http.StatusOK)
	}
}

func (handler *PhotoHandler) Update() http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request) {
		idString := r.PathValue("id")
		id, err := strconv.ParseUint(idString, 10, 32)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		body, err := req.ParseBody[UpdateRequest](w, r)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		photo := &Photo{
			Model: gorm.Model{
				ID: uint(id),
			},
			PathToPhoto: body.PathToPhoto,
		}

		photo, err = handler.PhotoService.Update(photo)
		if err != nil{
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		res.JSON(w, photo, http.StatusOK)
	}
}
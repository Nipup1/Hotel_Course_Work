package photo

type PhotoService struct {
	PhotoRepository *PhotRepository
}

func NewPhotoService(photoRepository PhotRepository) *PhotoService{
	return &PhotoService{
		PhotoRepository: &photoRepository,
	}
}

func (service *PhotoService) Create(body CreatePhotoRequest) (*Photo, error){
	photo := &Photo{
			PathToPhoto: body.PathToPhoto,
			HotelID: body.HotelID,
			RoomID: body.RoomID,
		}

	photo, err :=service.PhotoRepository.Create(photo)
	if err != nil{
		return nil , err
	}

	return photo, nil
}

func (service *PhotoService) Update(photo *Photo) (*Photo, error){
	photo, err := service.PhotoRepository.Update(photo)
	if err != nil{
		return nil, err
	}

	return photo, nil
}

func (service *PhotoService) GetById(id uint) (*Photo, error){
	photo, err := service.PhotoRepository.GetById(id)
	if err != nil{
		return nil, err
	}

	return photo, nil
}


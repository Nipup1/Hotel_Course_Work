package photo

import (
	"go/hotel/pkg/db"

	"gorm.io/gorm/clause"
)

type PhotRepository struct {
	DB *db.Db
}

func NewPhotoRepository(db *db.Db) *PhotRepository{
	return &PhotRepository{
		DB: db,
	}
}

func (repo *PhotRepository) Create(photo *Photo) (*Photo, error){
	result := repo.DB.Create(photo)
	if result.Error != nil{
		return nil, result.Error
	} 
	return photo, nil
}

func (repo *PhotRepository) Update(photo *Photo) (*Photo, error){
	result := repo.DB.Clauses(clause.Returning{}).Updates(photo)
	if result.Error != nil{
		return nil, result.Error
	} 
	return photo, nil
}

func (repo *PhotRepository) GetById(id uint) (*Photo, error){
	var photo Photo
	result := repo.DB.First(&photo, id)
	if result.Error != nil{
		return nil, result.Error
	} 
	return &photo, nil
}
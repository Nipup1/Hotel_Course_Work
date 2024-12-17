package hotel

import (
	"go/hotel/pkg/db"
)

type HotelRepository struct {
	DB *db.Db
}

func NewHotelRepository(database *db.Db) *HotelRepository{
	return &HotelRepository{
		DB: database,
	}
}

func (repo *HotelRepository) Create(hotel *Hotel) (*Hotel, error){
	result := repo.DB.Create(hotel)
	if result.Error != nil {
		return nil, result.Error
	}
	return hotel, nil
}

func (repo *HotelRepository) GetById(id uint) (*Hotel, error){
	var hotel Hotel
	result := repo.DB.Preload("Rooms").Preload("Photo").Preload("Rooms.Photos").First(&hotel, id)
	if result.Error != nil {
		return nil, result.Error
	}
	return &hotel, nil
}

func (repo *HotelRepository) GetMinPrice(id uint) (uint, error){
	var minPrice uint
	result := repo.DB.Table("rooms").
		Select("MIN(price)").
		Where("hotel_id = ?",  id).
		Scan(&minPrice)
	if result.Error != nil{
		return 0, result.Error
	}
	return minPrice, nil
}

func (repo *HotelRepository) GetAll(offset, limit, priceFrom int, rating float64, city, name string ) ([]Hotel, int64, error){
	var hotels []Hotel
	var count int64
	query := repo.DB.Table("hotels") 
  
    if city != "" {  
        query = query.Where("city = ?", city)  
    }  
    if name != "" {  
        query = query.Where("name LIKE ?", "%"+name+"%")  
    }  
    if rating > 0 {  
        query = query.Where("rating >= ?", rating)  
    }  
    if priceFrom > 0 {  
        query = query.Where("min_price < ?", priceFrom)  
    }  
  
    if err := query.Count(&count).Error; err != nil {  
        return nil, 0, err  
    }  
  
    if err := query.Preload("Photo").Limit(limit).Offset(offset).Find(&hotels).Error; err != nil {  
        return nil, 0, err  
    }  
  
    return hotels, count, nil
}

func (repo *HotelRepository) Count() int64{
	var count int64

	repo.DB.Table("hotels").
		Where("deleted_at is null").
		Count(&count)
		
	return count
}

func (repo *HotelRepository) GetCities() []string{
	var cities []string

	repo.DB.Table("hotels").
		Distinct("city").
		Where("city != ''").
		Order("city").
		Scan(&cities)
		
	return cities
}

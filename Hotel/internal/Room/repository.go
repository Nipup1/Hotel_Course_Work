package room

import "go/hotel/pkg/db"

type RoomRepository struct {
	DB *db.Db
}

func NewRoomRepository(database *db.Db) *RoomRepository{
	return &RoomRepository{
		DB: database,
	}
}

func (repo *RoomRepository) Create(room *Room)(*Room, error){
	result := repo.DB.Create(room)
	if result.Error != nil{
		return nil, result.Error
	}
	return room, result.Error
}

func (repo *RoomRepository) GetByType(hotel_id uint, roomType string) ([]Room, error){
	var rooms []Room
	result := repo.DB.Table("rooms").
		Where("hotel_id = ? AND room_type = ?", hotel_id, roomType).
		Scan(&rooms)

	if result.Error != nil{
		return nil, result.Error
	}
	return rooms, result.Error
}
package user

import (
	"go/user/pkg/db"

	"gorm.io/gorm/clause"
)

type UserRepository struct {
	*db.Db
}

func NewUserRepository(db *db.Db) *UserRepository{
	return &UserRepository{
		Db: db,
	}
}

func (repo *UserRepository) Create(user *User)(*User, error){
	result := repo.DB.Create(user)
	if result.Error != nil{
		return nil, result.Error
	}
	return user, nil
}

func (repo *UserRepository) GetByEmail(email string) (*User, error){
	var user User
	result := repo.DB.First(&user, "email = ?", email)
	if result.Error != nil{
		return nil, result.Error
	}
	return &user, nil
}

func (repo *UserRepository) Get(id uint) (*User, error){
	var user User
	result := repo.DB.Table("users").Where("id = ?", id).First(&user)
	if result.Error != nil{
		return nil, result.Error
	}
	return &user, nil
}

func (repo *UserRepository) Update(user *User)(*User, error){
	result := repo.DB.Clauses(clause.Returning{}).Updates(user)
	if result.Error != nil{
		return nil, result.Error
	}
	return user, nil
}

func (repo *UserRepository) Delete(id uint) error{
	result := repo.DB.Delete(&User{}, id)
	if result.Error != nil{
		return result.Error
	}
	return nil
}
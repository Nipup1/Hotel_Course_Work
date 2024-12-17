package db

import (
	"go/hotel/configs"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Db struct {
	*gorm.DB
}

func NewDb(conf *configs.Config) *Db{
	db, err := gorm.Open(postgres.Open(conf.DSN), &gorm.Config{})
	if err != nil{
		panic("No connect to db")
	}

	return &Db{
		DB: db,
	}
}
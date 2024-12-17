package configs

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	DSN   string
}

func NewConfig() *Config {
	err := godotenv.Load()
	if err != nil {
		log.Println("Error loading .env file, using default config")
	}

	return &Config{
		DSN: os.Getenv("DSN"),
	}
}
package configs

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	DSN string
}

func NewConfig() *Config {
	err := godotenv.Load()
	if err != nil{
		log.Println("Error loading .env file, using default config")
	}

	fmt.Println(os.Getenv("DSN"))

	return &Config{
		DSN: os.Getenv("DSN"),
	}
}
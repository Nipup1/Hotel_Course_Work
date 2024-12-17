package req

import (
	"encoding/json"
	"io"
	"net/http"

	"github.com/go-playground/validator/v10"
)

func ParseBody[T any](w http.ResponseWriter, r *http.Request) (*T, error){
	body, err := decodeBody[T](r.Body)
	if err != nil{
		return nil, err
	}

	err = validate(body)
	if err != nil{
		return nil, err
	}

	return &body, nil
}

func decodeBody[T any](body io.ReadCloser) (T, error){
	var payload T
	err := json.NewDecoder(body).Decode(&payload)
	if err != nil{
		return payload, err
	}
	return payload, nil
}

func validate[T any](body T) error{
	validator := validator.New()
	err := validator.Struct(body)
	return err
}
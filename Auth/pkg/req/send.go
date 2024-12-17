package req

import (
	"bytes"
	"encoding/json"
)

func BodyForRequest[T any](payload *T) (*bytes.Buffer, error) {
	body, err := json.Marshal(payload)
	if err != nil{
		return nil, err
	}
	return bytes.NewBuffer(body), nil
}
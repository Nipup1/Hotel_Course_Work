package jwt

import (
	"errors"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

const(
	ErrTimeIsUp = "Token_Time_Is_Up"
)

type JWTClaims struct{
	Email string
	Crated time.Time
	Expires time.Time
}

type JWTData struct {
	Email string
}

func Create(data JWTData, secret string, isHour bool) (string, error) {
	var t *jwt.Token
	currTime := time.Now()

	if isHour{
		t = jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"email": data.Email,
		"created": currTime,
		"expires": currTime.Add(1*time.Hour),
		})
	} else {
		t = jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"email": "",
		"created": currTime,
		"expires": currTime.Add(720*time.Hour),
		})
	}

	token, err := t.SignedString([]byte(secret))
	if err != nil{
		return "", nil
	}

	return token, nil
}

func IsValidT(token, secret string) (bool, *JWTData){
	var data *JWTData
	tClaims, err := checkToken(token, secret)

	if tClaims.Email != ""{
		data = &JWTData{
		Email: tClaims.Email,
		}
	} else{
		data = &JWTData{}
	}

	if err != nil {
		if err.Error() == ErrTimeIsUp{
			return false, data
		}
		return false, nil
	}

	return true, &JWTData{
		Email: tClaims.Email,
	}
}

func checkToken(token, secret string) (*JWTClaims, error){
	t, err := jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		return []byte(secret), nil
	})
	if err != nil{
		return nil, err
	}

	tClaims:= getClaims(t.Claims.(jwt.MapClaims))

	if time.Now().Compare(tClaims.Expires) > 0 {
		return tClaims, errors.New(ErrTimeIsUp)
	}

	return tClaims, err
} 

func getClaims(mapClains jwt.MapClaims) *JWTClaims{
	var data JWTClaims
	for key, value := range mapClains{
		switch key{
		case "email": 
			data.Email = value.(string)
		case "created":
			data.Crated, _ = time.Parse("2006-01-02T15:04:05.999999999Z07:00", value.(string))
		case "expires":
			data.Expires, _ = time.Parse("2006-01-02T15:04:05.999999999Z07:00", value.(string))
		}
	}

	return &data
}
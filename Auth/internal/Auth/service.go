package auth

import (
	"encoding/json"
	"errors"
	"go/auth/configs"
	"go/auth/pkg/jwt"
	"go/auth/pkg/req"
	"net/http"
)

type AuthService struct{
	*configs.Config
}

const(
	ErrServerIsNotResponding = "ServerIsNotResponding"
	ErrNonValidData = "ErrNonValidData"
)

func NewAuthService(conf *configs.Config) *AuthService {
	return &AuthService{
		Config: conf,
	}
}

func (service *AuthService) Login(body CheckUserRequest) (string, error){
	bodyR, err := req.BodyForRequest(&CheckUserRequest{
		Email:    body.Email,
		Password: body.Password,
	})
	if err != nil{
		return "", errors.New(ErrNonValidData)
	}

	resCreate, err := http.Post("http://localhost:8083/user/check", "application/json", bodyR)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}
	if resCreate.StatusCode != 200 {
		return "", errors.New(ErrNonValidData)
	}

	accessToken, err := jwt.Create(jwt.JWTData{Email: body.Email}, service.Secret, true)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}

	refreshToken, err := jwt.Create(jwt.JWTData{Email: body.Email}, service.Secret, false)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}

	err = service.sendToken(body.Email, refreshToken)
	if err != nil {
		return "", err
	}

	return accessToken, nil
}

func (service *AuthService) Registration(body RegistrationRequest) (string, error){
	bodyR, err := req.BodyForRequest(&RegistrationRequest{
		Email: body.Email,
		Password: body.Password,
		Name: body.Name,
	})
	if err != nil{
		return "", errors.New(ErrNonValidData)
	}

	reqToUser, err := http.Post("http://localhost:8083/user", "application/json", bodyR)
	if err != nil{
		return "", errors.New(ErrServerIsNotResponding)
	}
	if reqToUser.StatusCode != 201{
		return "", errors.New(ErrNonValidData)
	}

	accessToken, err := jwt.Create(jwt.JWTData{Email: body.Email}, service.Secret, true)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}

	refreshToken, err := jwt.Create(jwt.JWTData{Email: body.Email}, service.Secret, false)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}

	err = service.sendToken(body.Email, refreshToken)
	if err != nil {
		return "", err
	}

	return accessToken, nil
}

func (service *AuthService) Auth(body Token) (bool, string, string){
	isValidAT, JWTData := jwt.IsValidT(body.AccessToken, service.Secret)
	if isValidAT {
		return true, body.AccessToken, JWTData.Email
	} else {
		if JWTData != nil{
			token, err := service.getToken(JWTData.Email)
			if err != nil{
				return false, "", ""
			}
			isValidRT, _ := jwt.IsValidT(token, service.Secret)
			if isValidRT {
				return true, token, JWTData.Email
			}

			return false, "", ""
		}
		return false, "", ""
	}
}

func (service *AuthService) createToken(email, secret string)(string, error){
	token, err := jwt.Create(jwt.JWTData{Email: email}, secret, true)
	if err != nil{
		return "", err
	}
	return token, nil
}

func (service *AuthService) sendToken(email, token string) error{
	bodyR, err := req.BodyForRequest(&SendToken{
		Email:        email,
		RefreshToken: token,
	})
	if err != nil{
		return errors.New(ErrNonValidData)
	}

	client := &http.Client{}
	req, err := http.NewRequest("PATCH", "http://localhost:8083/user", bodyR)
	if err != nil {
		return errors.New(ErrServerIsNotResponding)
	}

	resUpdate, err := client.Do(req)
	if err != nil {
		return errors.New(ErrServerIsNotResponding)
	}
	if resUpdate.StatusCode != 200 {
		return errors.New(ErrNonValidData)
	}

	return nil
}

func (service *AuthService)getToken(email string) (string, error){
	bodyR, err := req.BodyForRequest(&GetRefreshTokenRequest{
		Email: email,
	})
	if err != nil{
		return "", errors.New(ErrNonValidData)
	}

	respToken, err := http.Post("http://localhost:8083/user/token", "application/json", bodyR)
	if err != nil {
		return "", errors.New(ErrServerIsNotResponding)
	}
	if respToken.StatusCode != 200 {
		return "", errors.New(ErrNonValidData)
	}

	var body GetRefreshTokenResponse
	json.NewDecoder(respToken.Body).Decode(&body)

	return body.RefreshToken, nil
}
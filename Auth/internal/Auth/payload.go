package auth

type CheckUserRequest struct{
	Email string `json:"email"`
	Password string `json:"password"`
}

type RegistrationRequest struct{
	Email string `json:"email"`
	Password string `json:"password"`
	Name string `json:"name"`
}

type SendToken struct{
	Email string `json:"email"`
	RefreshToken string `json:"refresh_token"`
}

type Token struct{
	AccessToken string `json:"access_token"`
}

type GetRefreshTokenRequest struct{
	Email string `json:"email"`
}

type GetRefreshTokenResponse struct{
	RefreshToken string `json:"refresh_token"`
}

type EmailResponse struct{
	Email string `json:"email"`
}
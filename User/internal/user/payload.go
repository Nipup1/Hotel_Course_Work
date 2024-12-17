package user

type CreateRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
	Name     string `json:"name" validate:"required"`
}

type CheckUserRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

type UpdateRequest struct {
	Password string `json:"password"`
	Name     string `json:"name"`
}

type UpdateTokenRequest struct {
	Email string `json:"email" validate:"required,email"`
	Token string `json:"refresh_token" validate:"required"`
}

type GetUserResponse struct {
	Id    uint   `json:"id"`
	Email string `json:"email"`
	Name  string `json:"name"`
}

type GetRefreshTokenRequest struct {
	Email string `json:"email"`
}

type GetRefreshTokenResponse struct {
	Token string `json:"refresh_token"`
}

type UserResponse struct {
	Id    uint   `json:"id"`
	Email string `json:"email"`
	Name  string `json:"name"`
}

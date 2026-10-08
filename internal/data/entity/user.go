package entity

import (
	"time"
	"uuid"

	"gorm.io/gorm"
)

type Role string

const (
	RoleUser  Role = "USER"
	RoleAdmin Role = "ADMIN"
)

type User struct {
	ID           uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primarykey"`
	UserName     string    `gorm:"type:varchar(50);uniqueIndex;not null"`
	Email        string    `gorm:"type:varchar(255);uniqueIndex;not null"`
	PasswordHash string    `gorm:"type:text;not null"`

	DisplayName string  `gorm:"type:varchar(100);not null"`
	AvatarURL   *string `gorm:"type:text"`
	Bio         *string `gorm:"type:text"`

	Role Role `gorm:"type:varchar(20);not null;default:'USER'"`

	CreatedAt time.Time      `gorm:"not null"`
	UpdatedAt time.Time      `gorm:"not null"`
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

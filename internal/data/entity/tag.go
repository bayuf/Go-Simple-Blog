package entity

import (
	"time"
	"uuid"
)

type Tag struct {
	ID   uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Name string    `gorm:"type:varchar(50);uniqueIndex;not null"`
	Slug string    `gorm:"type:varchar(70);uniqueIndex;not null"`

	CreatedAt time.Time
	UpdatedAt time.Time
}

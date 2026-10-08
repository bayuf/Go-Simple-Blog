package entity

import (
	"time"
	"uuid"
)

type PostLike struct {
	PostID uuid.UUID `gorm:"type:uuid;primaryKey"`
	UserID uuid.UUID `gorm:"type:uuid;primaryKey"`

	CreatedAt time.Time `gorm:"not null"`
}

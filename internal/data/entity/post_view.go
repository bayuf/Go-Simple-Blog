package entity

import (
	"time"
	"uuid"
)

type PostView struct {
	PostID    uuid.UUID `gorm:"type:uuid;primaryKey"`
	ViewCount int64     `gorm:"not null;default:0"`
	UpdatedAt time.Time `gorm:"not null"`
}

package entity

import (
	"time"
	"uuid"
)

type PostRevision struct {
	ID       uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	PostID   uuid.UUID `gorm:"type:uuid;not null"`
	EditorID uuid.UUID `gorm:"type:uuid;not null"`

	Post   Post `gorm:"foreignKey:PostID"`
	Editor User `gorm:"foreignKey:EditorID"`

	Version int `gorm:"not null"`

	Title   string `gorm:"type:varchar(200);not null"`
	Excerpt string `gorm:"type:text;not null"`
	Content string `gorm:"type:text;not null"`

	CreatedAt time.Time `gorm:"not null"`
}

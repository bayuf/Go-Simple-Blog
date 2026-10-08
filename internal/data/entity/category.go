package entity

import (
	"time"
	"uuid"
)

type Category struct {
	ID          uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primarykey"`
	Name        string    `gorm:"type:varchar(100);uniqueIndex;not null"`
	Slug        string    `gorm:"type:varchar(120);uniqueIndex;not null"`
	Description *string   `gorm:"type:text"`

	CreatedAt time.Time
	UpdatedAt time.Time
}

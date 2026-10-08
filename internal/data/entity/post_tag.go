package entity

import "uuid"

type PostTag struct {
	PostID uuid.UUID `gorm:"type:uuid;primaryKey"`
	TagID  uuid.UUID `gorm:"type:uuid;primaryKey"`
}

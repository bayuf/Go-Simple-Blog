package entity

import "uuid"

type NotificationPreference struct {
	UserID uuid.UUID `gorm:"type:uuid;primaryKey"`

	NewPostEnabled bool `gorm:"not null;default:true"`
}

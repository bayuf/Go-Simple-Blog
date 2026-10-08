package entity

import (
	"time"
	"uuid"

	"gorm.io/gorm"
)

type CommentStatus string

const (
	CommentStatusPending  CommentStatus = "PENDING"
	CommentStatusApproved CommentStatus = "APPROVED"
	CommentStatusRejected CommentStatus = "REJECTED"
)

type Comment struct {
	ID uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`

	PostID uuid.UUID `gorm:"type:uuid;not null"`
	UserID uuid.UUID `gorm:"type:uuid;not null"`

	Post Post `gorm:"foreignKey:PostID"`
	User User `gorm:"foreignKey:UserID"`

	ParentID *uuid.UUID `gorm:"type:uuid"`
	Parent   *Comment   `gorm:"foreignKey:ParentID"`
	Replies  []Comment  `gorm:"foreignKey:ParentID"`

	Content string        `gorm:"type:text;not null"`
	Status  CommentStatus `gorm:"type:varchar(20);not null;default:'PENDING'"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

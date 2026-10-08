package entity

import (
	"time"
	"uuid"

	"gorm.io/gorm"
)

type PostStatus string

const (
	ostStatusDraft     PostStatus = "DRAFT"
	ostStatusPublished PostStatus = "PUBLISHED"
	PostStatusArchived PostStatus = "ARCHIVED"
)

type Post struct {
	ID         uuid.UUID  `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	AuthorID   uuid.UUID  `gorm:"type:uuid;not null"`
	CategoryID *uuid.UUID `gorm:"type:uuid"`

	Author   User      `gorm:"foreignKey:AuthorID"`
	Category *Category `gorm:"foreignKey:CategoryID"`

	Title         string  `gorm:"type:varchar(200);not null"`
	Slug          string  `gorm:"type:varchar(220);uniqueIndex;not null"`
	Excerpt       string  `gorm:"type:text;not null"`
	Content       string  `gorm:"type:text;not null"`
	CoverImageURL *string `gorm:"type:text"`

	Status      PostStatus `gorm:"type:varchar(20);not null;default:'DRAFT'"`
	PublishedAt *time.Time

	Tags []Tag `gorm:"many2many:post_tags;"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

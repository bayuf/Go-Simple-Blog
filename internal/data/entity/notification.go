package entity

import (
	"time"
	"uuid"
)

type NotificationType string

const (
	NotificationCommentReply    NotificationType = "COMMENT_REPLY"
	NotificationCommentApproved NotificationType = "COMMENT_APPROVED"
	NotificationCommentRejected NotificationType = "COMMENT_REJECTED"
	NotificationNewComment      NotificationType = "NEW_COMMENT"
	NotificationNewPost         NotificationType = "NEW_POST"
)

type Notification struct {
	ID     uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	UserID uuid.UUID `gorm:"type:uuid;not null"`

	User User `gorm:"foreignKey:UserID"`

	Type        NotificationType `gorm:"type:varchar(30);not null"`
	Title       string           `gorm:"type:varchar(200);not null"`
	Message     string           `gorm:"type:text;not null"`
	ReferenceID *uuid.UUID       `gorm:"type:uuid"`

	IsRead    bool      `gorm:"not null;default:false"`
	CreatedAt time.Time `gorm:"not null"`
}

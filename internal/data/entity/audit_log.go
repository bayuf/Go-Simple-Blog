package entity

import (
	"time"
	"uuid"

	"gorm.io/datatypes"
)

type AuditAction string

const (
	AuditCreate    AuditAction = "CREATE"
	AuditUpdate    AuditAction = "UPDATE"
	AuditDelete    AuditAction = "DELETE"
	AuditPublish   AuditAction = "PUBLISH"
	AuditUnpublish AuditAction = "UNPUBLISH"
	AuditApprove   AuditAction = "APPROVE"
	AuditReject    AuditAction = "REJECT"
	AuditLogin     AuditAction = "LOGIN"
	AuditLogout    AuditAction = "LOGOUT"
)

type AuditEntityType string

const (
	AuditEntityPost     AuditEntityType = "POST"
	AuditEntityComment  AuditEntityType = "COMMENT"
	AuditEntityCategory AuditEntityType = "CATEGORY"
	AuditEntityTag      AuditEntityType = "TAG"
	AuditEntityUser     AuditEntityType = "USER"
)

type AuditLog struct {
	ID uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`

	UserID *uuid.UUID `gorm:"type:uuid"`
	User   *User      `gorm:"foreignKey:UserID"`

	Action     AuditAction     `gorm:"type:varchar(30);not null"`
	EntityType AuditEntityType `gorm:"type:varchar(30);not null"`
	EntityID   *uuid.UUID      `gorm:"type:uuid"`

	Metadata datatypes.JSON `gorm:"type:jsonb"`

	CreatedAt time.Time `gorm:"not null"`
}

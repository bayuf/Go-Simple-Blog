CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =========================================================
-- 001_init_schema.sql
-- Blog System
-- PostgreSQL
-- =========================================================


-- =========================================================
-- 1. USERS
-- =========================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash TEXT NOT NULL,

    display_name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    bio TEXT,

    role VARCHAR(20) NOT NULL DEFAULT 'USER',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_email UNIQUE (email),

    CONSTRAINT chk_users_role
        CHECK (role IN ('USER', 'ADMIN'))
);

CREATE INDEX idx_users_deleted_at
    ON users(deleted_at);


-- =========================================================
-- 2. CATEGORIES
-- =========================================================

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_categories_name UNIQUE (name),
    CONSTRAINT uq_categories_slug UNIQUE (slug)
);


-- =========================================================
-- 3. TAGS
-- =========================================================

CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(50) NOT NULL,
    slug VARCHAR(70) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_tags_name UNIQUE (name),
    CONSTRAINT uq_tags_slug UNIQUE (slug)
);


-- =========================================================
-- 4. POSTS
-- =========================================================

CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    author_id UUID NOT NULL,
    category_id UUID,

    title VARCHAR(200) NOT NULL,
    slug VARCHAR(220) NOT NULL,
    excerpt TEXT NOT NULL,
    content TEXT NOT NULL,
    cover_image_url TEXT,

    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    published_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_posts_slug
        UNIQUE (slug),

    CONSTRAINT chk_posts_status
        CHECK (status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),

    CONSTRAINT fk_posts_author
        FOREIGN KEY (author_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_posts_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE SET NULL
);

CREATE INDEX idx_posts_author_id
    ON posts(author_id);

CREATE INDEX idx_posts_category_id
    ON posts(category_id);

CREATE INDEX idx_posts_status
    ON posts(status);

CREATE INDEX idx_posts_published_at
    ON posts(published_at);

CREATE INDEX idx_posts_created_at
    ON posts(created_at);

CREATE INDEX idx_posts_deleted_at
    ON posts(deleted_at);


-- =========================================================
-- 5. POST TAGS
-- =========================================================

CREATE TABLE post_tags (
    post_id UUID NOT NULL,
    tag_id UUID NOT NULL,

    PRIMARY KEY (post_id, tag_id),

    CONSTRAINT fk_post_tags_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_post_tags_tag
        FOREIGN KEY (tag_id)
        REFERENCES tags(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_post_tags_tag_id
    ON post_tags(tag_id);


-- =========================================================
-- 6. COMMENTS
-- =========================================================

CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    post_id UUID NOT NULL,
    user_id UUID NOT NULL,
    parent_id UUID,

    content TEXT NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT chk_comments_status
        CHECK (
            status IN (
                'PENDING',
                'APPROVED',
                'REJECTED'
            )
        ),

    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_comments_parent
        FOREIGN KEY (parent_id)
        REFERENCES comments(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_comments_post_id
    ON comments(post_id);

CREATE INDEX idx_comments_user_id
    ON comments(user_id);

CREATE INDEX idx_comments_parent_id
    ON comments(parent_id);

CREATE INDEX idx_comments_status
    ON comments(status);

CREATE INDEX idx_comments_deleted_at
    ON comments(deleted_at);


-- =========================================================
-- 7. POST LIKES
-- =========================================================

CREATE TABLE post_likes (
    post_id UUID NOT NULL,
    user_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (post_id, user_id),

    CONSTRAINT fk_post_likes_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_post_likes_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- 8. BOOKMARKS
-- =========================================================

CREATE TABLE bookmarks (
    post_id UUID NOT NULL,
    user_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (post_id, user_id),

    CONSTRAINT fk_bookmarks_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_bookmarks_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- 9. POST VIEWS
-- =========================================================

CREATE TABLE post_views (
    post_id UUID PRIMARY KEY,

    view_count BIGINT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_post_views_count
        CHECK (view_count >= 0),

    CONSTRAINT fk_post_views_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE
);


-- =========================================================
-- 10. POST REVISIONS
-- =========================================================

CREATE TABLE post_revisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    post_id UUID NOT NULL,
    editor_id UUID NOT NULL,

    version INTEGER NOT NULL,

    title VARCHAR(200) NOT NULL,
    excerpt TEXT NOT NULL,
    content TEXT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_post_revisions_version
        UNIQUE (post_id, version),

    CONSTRAINT chk_post_revisions_version
        CHECK (version > 0),

    CONSTRAINT fk_post_revisions_post
        FOREIGN KEY (post_id)
        REFERENCES posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_post_revisions_editor
        FOREIGN KEY (editor_id)
        REFERENCES users(id)
        ON DELETE RESTRICT
);

CREATE INDEX idx_post_revisions_post_id
    ON post_revisions(post_id);

CREATE INDEX idx_post_revisions_editor_id
    ON post_revisions(editor_id);

CREATE INDEX idx_post_revisions_created_at
    ON post_revisions(created_at);


-- =========================================================
-- 11. NOTIFICATIONS
-- =========================================================

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    type VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,

    reference_id UUID,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_notifications_type
        CHECK (
            type IN (
                'COMMENT_REPLY',
                'COMMENT_APPROVED',
                'COMMENT_REJECTED',
                'NEW_COMMENT',
                'NEW_POST'
            )
        ),

    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_notifications_user_is_read
    ON notifications(user_id, is_read);

CREATE INDEX idx_notifications_user_created_at
    ON notifications(user_id, created_at DESC);


-- =========================================================
-- 12. NOTIFICATION PREFERENCES
-- =========================================================

CREATE TABLE notification_preferences (
    user_id UUID PRIMARY KEY,

    new_post_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_notification_preferences_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =========================================================
-- 13. AUDIT LOGS
-- =========================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID,

    action VARCHAR(30) NOT NULL,
    entity_type VARCHAR(30) NOT NULL,
    entity_id UUID,

    metadata JSONB,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_audit_logs_action
        CHECK (
            action IN (
                'CREATE',
                'UPDATE',
                'DELETE',
                'PUBLISH',
                'UNPUBLISH',
                'APPROVE',
                'REJECT',
                'LOGIN',
                'LOGOUT'
            )
        ),

    CONSTRAINT chk_audit_logs_entity_type
        CHECK (
            entity_type IN (
                'POST',
                'COMMENT',
                'CATEGORY',
                'TAG',
                'USER'
            )
        ),

    CONSTRAINT fk_audit_logs_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user_id
    ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_entity
    ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_audit_logs_created_at
    ON audit_logs(created_at DESC);

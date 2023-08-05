CREATE TABLE feedback (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    data JSONB NOT NULL
);

CREATE TABLE attachments (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    feedback_id UUID,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    FOREIGN KEY (feedback_id) REFERENCES feedback (id)
);

CREATE TABLE promoter_scores (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    data JSONB NOT NULL
);

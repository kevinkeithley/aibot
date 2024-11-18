-- schema.sql: PostgreSQL Schema for AI Bot Conversation History

-- Conversations Table
CREATE TABLE conversations(
    id SERIAL PRIMARY KEY,
    user_id TEXT,
    parent_conversation_id INTEGER REFERENCES conversations(id) ON DELETE SET NULL,
    session_id UUID DEFAULT gen_random_uuid(),
    system_prompt TEXT,
    tags JSONB DEFAULT '{}'::JSONB,
    conv_status TEXT CHECK (conv_status IN ('active', 'archived', 'completed')) DEFAULT 'active',
    depth INTEGER DEFAULT 0,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Messages Table
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
    role TEXT CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT,
    token_count INTEGER DEFAULT 0,
    content_tsvector TSVECTOR GENERATED ALWAYS AS (to_tsvector('english', content)) STORED,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
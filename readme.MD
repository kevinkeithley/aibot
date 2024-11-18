# Database Structure for AI Bot Conversation History

This section of the README provides an overview of the PostgreSQL database schema designed to support a flexible, persistent history of AI bot conversations. The schema includes tables for managing conversation metadata, storing individual messages, and supporting advanced features like conversation branching, session management, and replaying prompts with modified system contexts.

---

## Database Schema Overview

The database consists of two main tables:

### 1. Conversations Table

The `conversations` table stores metadata for each conversation session, including information about the user, session context, and support for branching.

#### Table: `conversations`

| Column                   | Type        | Description                                                                                                      |
| ------------------------ | ----------- | ---------------------------------------------------------------------------------------------------------------- |
| `id`                     | `SERIAL`    | Primary key, unique identifier for each conversation.                                                            |
| `user_id`                | `TEXT`      | Identifier for the user who initiated the conversation.                                                          |
| `parent_conversation_id` | `INTEGER`   | References the parent conversation ID for branching. Allows creating a new branch from an existing conversation. |
| `session_id`             | `UUID`      | Unique identifier for the user session. Used to group conversations belonging to the same session.               |
| `system_prompt`          | `TEXT`      | The system prompt that defines the assistant's behavior for this conversation.                                   |
| `tags`                   | `JSONB`     | Optional metadata tags for categorizing or labeling the conversation (e.g., topic, project).                     |
| `conv_status`            | `TEXT`      | Status of the conversation (`active`, `archived`, `completed`).                                                  |
| `depth`                  | `INTEGER`   | Indicates the depth level of the conversation for branching (e.g., 0 for root, 1 for first-level branch).        |
| `rating`                 | `INTEGER`   | User-provided rating for the conversation (1 to 5).                                                              |
| `created_at`             | `TIMESTAMP` | Timestamp of when the conversation was created.                                                                  |

**Key Features:**
- **Branching Support**: The `parent_conversation_id` column allows conversations to be forked, creating new branches while preserving the original context.
- **Session Management**: The `session_id` groups related conversations, providing a cohesive experience across multiple interactions.
- **Customizable Behavior**: The `system_prompt` column lets you modify the assistant’s behavior on a per-conversation basis.

### 2. Messages Table

The `messages` table stores the content of each message in the conversation, including user queries, assistant responses, and system prompts.

#### Table: `messages`

| Column             | Type        | Description                                                                                      |
| ------------------ | ----------- | ------------------------------------------------------------------------------------------------ |
| `id`               | `SERIAL`    | Primary key, unique identifier for each message.                                                 |
| `conversation_id`  | `INTEGER`   | Foreign key referencing the `conversations` table. Links the message to its parent conversation. |
| `role`             | `TEXT`      | Role of the message sender (`user`, `assistant`, `system`).                                      |
| `content`          | `TEXT`      | The text content of the message.                                                                 |
| `token_count`      | `INTEGER`   | Number of tokens in the message (useful for tracking API costs).                                 |
| `content_tsvector` | `TSVECTOR`  | Full-text search vector for efficient searching of message content.                              |
| `timestamp`        | `TIMESTAMP` | Timestamp of when the message was created.                                                       |

**Key Features:**
- **Full-Text Search**: The `content_tsvector` column allows efficient searching of message content using PostgreSQL’s full-text search capabilities.
- **Token Tracking**: The `token_count` column tracks the number of tokens in each message, helping monitor API usage and costs.

---

## Planned Functionality

The database schema supports several advanced features that are planned for the AI bot application:

### 1. Replay with Modified System Prompts
- Users can replay a series of prompts from an existing conversation but with a modified system prompt. This allows exploring different assistant behaviors without losing the original conversation context.
- The new replayed conversation is stored as a branch with a reference to the original conversation (`parent_conversation_id`).

### 2. Branching Conversations
- Users can create branches from any point in a conversation, enabling them to explore alternate paths or different responses while preserving the original conversation history.
- The `depth` column tracks the level of each branch, allowing for easy visualization and navigation of the conversation tree.

### 3. Session Management
- The `session_id` groups related conversations together, providing a seamless experience across multiple interactions within the same session.
- Users can manually start a new session or continue using the existing session, depending on the context of the application.

### 4. Tagging and Metadata
- The `tags` column allows for categorizing conversations with additional metadata (e.g., topic, user preferences), making it easier to search, filter, and analyze conversations.

---

## Setup Instructions

To set up the database schema, execute the following command in your terminal:

```bash
psql -U <username> -d <database_name> -f schema.sql

CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE CHECK (length(username) > 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE levels (
    level_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    placement INTEGER NOT NULL CHECK (placement > 0),
    moderation BOOLEAN NOT NULL DEFAULT FALSE,
    public BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE votes (
    user_id INTEGER NOT NULL,
    level_id INTEGER NOT NULL,
    is_agree BOOLEAN NOT NULL,
    voted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, level_id),

    CONSTRAINT fk_vote_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_vote_level
        FOREIGN KEY (level_id)
        REFERENCES levels(level_id)
        ON DELETE CASCADE
);

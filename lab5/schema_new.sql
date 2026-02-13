-- Спочатку видаляємо таблицю, яка посилається на користувачів
DROP TABLE IF EXISTS votes;

-- Тепер можна спокійно видаляти користувачів та рівні
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS levels;



-- =============================================
-- 1. СТВОРЕННЯ ТАБЛИЦЬ (DDL) - ОНОВЛЕНО
-- =============================================

-- 1.1. Таблиця користувачів (Без змін)
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE CHECK (length(username) > 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 1.2. Таблиця рівнів (Без змін)
CREATE TABLE levels (
    level_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    placement INTEGER NOT NULL CHECK (placement > 0),
    moderation BOOLEAN NOT NULL DEFAULT FALSE,
    public BOOLEAN NOT NULL DEFAULT TRUE
);

-- 1.3. [НОВА] Таблиця типів голосів
-- Дозволяє масштабувати систему (Like, Dislike, Mixed тощо)
CREATE TABLE vote_types (
    vote_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- Напр: 'Like', 'Dislike'
    weight INTEGER NOT NULL DEFAULT 0 -- Напр: +1, -1
);

-- 1.4. Таблиця голосів (Оновлена)
CREATE TABLE votes (
    user_id INTEGER NOT NULL,
    level_id INTEGER NOT NULL,
    vote_type_id INTEGER NOT NULL, -- Замість is_agree
    voted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Складений первинний ключ
    PRIMARY KEY (user_id, level_id),

    -- Зовнішній ключ на users
    CONSTRAINT fk_vote_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    -- Зовнішній ключ на levels
    CONSTRAINT fk_vote_level
        FOREIGN KEY (level_id)
        REFERENCES levels(level_id)
        ON DELETE CASCADE,

    -- [НОВИЙ] Зовнішній ключ на vote_types
    CONSTRAINT fk_vote_type
        FOREIGN KEY (vote_type_id)
        REFERENCES vote_types(vote_type_id)
        ON DELETE RESTRICT
);

-- =============================================
-- 2. НАПОВНЕННЯ ДАНИМИ (DML)
-- =============================================

-- 2.1. Додаємо типи голосів (Довідник)
INSERT INTO vote_types (name, weight) VALUES 
('Like', 1),
('Dislike', -1);

-- 2.2. Додаємо користувачів
INSERT INTO users (username) VALUES 
('SuperGamer'), ('SpeedRunner_99'), ('ChillPlayer');

-- 2.3. Додаємо рівні
INSERT INTO levels (name, placement, moderation, public) VALUES 
('Green Hill', 1, TRUE, TRUE),
('Desert Storm', 2, FALSE, TRUE),
('Secret Base', 3, TRUE, FALSE);

-- 2.4. Додаємо голоси (Використовуючи ID типів голосів)
-- Припустимо: 1 = Like, 2 = Dislike

-- User 1 Likes Level 1
INSERT INTO votes (user_id, level_id, vote_type_id) VALUES (1, 1, 1);
-- User 1 Dislikes Level 2
INSERT INTO votes (user_id, level_id, vote_type_id) VALUES (1, 2, 2);
-- User 2 Likes Level 1
INSERT INTO votes (user_id, level_id, vote_type_id) VALUES (2, 1, 1);
-- User 3 Likes Level 3
INSERT INTO votes (user_id, level_id, vote_type_id) VALUES (3, 3, 1);
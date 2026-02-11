-- =============================================
-- 1. СТВОРЕННЯ ТАБЛИЦЬ (DDL)
-- =============================================

-- 1.1. Таблиця користувачів
-- Зберігає інформацію про гравців
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE CHECK (length(username) > 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 1.2. Таблиця рівнів
-- Зберігає інформацію про ігрові рівні
CREATE TABLE levels (
    level_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    placement INTEGER NOT NULL CHECK (placement > 0),
    moderation BOOLEAN NOT NULL DEFAULT FALSE,
    public BOOLEAN NOT NULL DEFAULT TRUE
);

-- 1.3. Таблиця голосів
-- Зв'язує користувачів і рівні (хто за що голосував)
CREATE TABLE votes (
    user_id INTEGER NOT NULL,
    level_id INTEGER NOT NULL,
    is_agree BOOLEAN NOT NULL,
    voted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Складений первинний ключ (один користувач не може голосувати двічі за один рівень)
    PRIMARY KEY (user_id, level_id),

    -- Зовнішній ключ на таблицю користувачів
    CONSTRAINT fk_vote_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    -- Зовнішній ключ на таблицю рівнів
    CONSTRAINT fk_vote_level
        FOREIGN KEY (level_id)
        REFERENCES levels(level_id)
        ON DELETE CASCADE
);

-- =============================================
-- 2. НАПОВНЕННЯ ДАНИМИ (DML / INSERT)
-- =============================================

-- 2.1. Додаємо користувачів
INSERT INTO users (username) VALUES 
('SuperGamer'),
('SpeedRunner_99'),
('ChillPlayer');

-- 2.2. Додаємо рівні
INSERT INTO levels (name, placement, moderation, public) VALUES 
('Green Hill', 1, TRUE, TRUE),
('Desert Storm', 2, FALSE, TRUE),
('Secret Base', 3, TRUE, FALSE); -- Прихований рівень

-- 2.3. Додаємо голоси
-- Користувач 1 голосує ЗА рівень 1
INSERT INTO votes (user_id, level_id, is_agree) VALUES (1, 1, TRUE);

-- Користувач 1 голосує ПРОТИ рівня 2
INSERT INTO votes (user_id, level_id, is_agree) VALUES (1, 2, FALSE);

-- Користувач 2 голосує ЗА рівень 1
INSERT INTO votes (user_id, level_id, is_agree) VALUES (2, 1, TRUE);

-- Користувач 3 голосує ЗА рівень 3
INSERT INTO votes (user_id, level_id, is_agree) VALUES (3, 3, TRUE);
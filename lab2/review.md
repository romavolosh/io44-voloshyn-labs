# Звіт з проектування схеми бази даних (Voting System)

## 1. Огляд схеми бази даних
Розроблена база даних призначена для системи голосування користувачів за ігрові рівні. Схема складається з трьох таблиць: **users**, **levels** та **votes**.

### Опис таблиць

#### 1.1. Таблиця `users` (Користувачі)
Зберігає інформацію про зареєстрованих користувачів.

| Стовпець | Тип даних | Обмеження / Ключі | Опис |
| :--- | :--- | :--- | :--- |
| **user_id** | INTEGER | **PRIMARY KEY**, IDENTITY | Унікальний ідентифікатор користувача (генерується автоматично). |
| **username** | VARCHAR(100) | NOT NULL, **UNIQUE** | Ім'я користувача. Має обмеження `CHECK (length > 0)`, щоб ім'я не було порожнім. |
| **created_at**| TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Час створення акаунта. |

#### 1.2. Таблиця `levels` (Рівні)
Зберігає інформацію про ігрові рівні, за які можна голосувати.

| Стовпець | Тип даних | Обмеження / Ключі | Опис |
| :--- | :--- | :--- | :--- |
| **level_id** | INTEGER | **PRIMARY KEY**, IDENTITY | Унікальний ідентифікатор рівня (генерується автоматично). |
| **name** | VARCHAR(150)| NOT NULL | Назва рівня. |
| **placement**| INTEGER | NOT NULL, CHECK (>0) | Порядковий номер розміщення рівня. |
| **moderation**| BOOLEAN | DEFAULT FALSE | Статус модерації. |
| **public** | BOOLEAN | DEFAULT TRUE | Чи видимий рівень публічно. |

#### 1.3. Таблиця `votes` (Голоси)
Зв'язуюча таблиця, що фіксує факт голосування користувача за певний рівень.

| Стовпець | Тип даних | Обмеження / Ключі | Опис |
| :--- | :--- | :--- | :--- |
| **vote_id** | INTEGER | **PRIMARY KEY**, IDENTITY | Унікальний ідентифікатор голосу. |
| **user_id** | INTEGER | **FOREIGN KEY** | Посилання на `users(user_id)`. `ON DELETE CASCADE` (при видаленні юзера видаляються його голоси). |
| **level_id** | INTEGER | **FOREIGN KEY** | Посилання на `levels(level_id)`. `ON DELETE CASCADE` (при видаленні рівня видаляються голоси за нього). |
| **is_agree** | BOOLEAN | NOT NULL | Тип голосу (TRUE = лайк, FALSE = дизлайк). |
| **voted_at** | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Час голосування. |

**Важливі обмеження:**
* Додано обмеження унікальності **`UNIQUE (user_id, level_id)`**. Це гарантує, що один користувач не може проголосувати за один і той самий рівень більше одного разу, навіть якщо `vote_id` у них різний.

---

## 2. ER-діаграма
Нижче наведена структура зв'язків між сутностями:

![ER Diagram](erd-diagram.png)

---

## 3. SQL-скрипт створення та наповнення
Для реалізації схеми та наповнення тестовими даними (мінімум 3-5 записів) використано наступний скрипт:

```sql
-- 1. СТВОРЕННЯ ТАБЛИЦЬ
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
    vote_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL,
    level_id INTEGER NOT NULL,
    is_agree BOOLEAN NOT NULL,
    voted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_user_level_vote UNIQUE (user_id, level_id),
    
    CONSTRAINT fk_vote_user FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_vote_level FOREIGN KEY (level_id) 
        REFERENCES levels(level_id) ON DELETE CASCADE
);

-- 2. НАПОВНЕННЯ ДАНИМИ
INSERT INTO users (username) VALUES ('SuperGamer'), ('SpeedRunner_99'), ('ChillPlayer');

INSERT INTO levels (name, placement, moderation, public) VALUES 
('Green Hill', 1, TRUE, TRUE),
('Desert Storm', 2, FALSE, TRUE),
('Secret Base', 3, TRUE, FALSE);

INSERT INTO votes (user_id, level_id, is_agree) VALUES 
(1, 1, TRUE), (1, 2, FALSE), 
(2, 1, TRUE), (3, 3, TRUE);
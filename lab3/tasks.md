# SELECT

## 1. Показати всіх користувачів
```sql
SELECT * FROM users;
```
![All Users](./src/1.png)

---

## 2. Показати всі рівні
```sql
SELECT * FROM levels;
```
![All Levels](./src/2.png)

---

## 3. Показати всі голоси
```sql
SELECT * FROM votes;
```
![All Votes](./src/3.png)

---

## 4. Отримати тільки імена користувачів
```sql
SELECT username FROM users;
```
![Username from Users](./src/4.png)

---

## 5. Отримати назви рівнів та їх складність (placement)
```sql
SELECT name, placement FROM levels;
```
![Name and placement from levels](./src/5.png)

---

## 6. Знайти тільки ПУБЛІЧНІ рівні (ті, що не приховані)
```sql
SELECT * FROM levels 
WHERE public = TRUE;
```
![All Public Levels](./src/6.png)

---

## 7. Знайти рівні, які складніші за перший (placement > 1)
```sql
SELECT name, placement FROM levels 
WHERE placement > 1;
```
![Levels with placement > 1](./src/7.png)

---

## 8. Знайти всі ПОЗИТИВНІ голоси (лайки)
```sql
SELECT * FROM votes 
WHERE is_agree = TRUE;
```
![Positive Votes](./src/8.png)

---

## 9. Хто за що проголосував (з іменами замість цифр)
```sql
SELECT 
    users.username AS Гравець, 
    levels.name AS Рівень, 
    votes.is_agree AS Лайк
FROM votes
JOIN users ON votes.user_id = users.user_id
JOIN levels ON votes.level_id = levels.level_id;
```
![Votes by Users](./src/9.png)

---

# INSERT

## 1. Додавання нового користувача
```sql
INSERT INTO users (username) VALUES ('Pro_Gamer_2024');
SELECT * FROM users;
```
![New User](./src/10.png)

---

## 2. Додавання нового рівня
```sql
INSERT INTO levels (name, placement, moderation, public) VALUES ('Impossible Mode', 10, TRUE, TRUE);
```
![New Level](./src/11.png)

---

## 2. Додавання нового голосу
```sql
INSERT INTO votes (user_id, level_id, is_agree) VALUES (3, 6, FALSE);
SELECT * FROM votes WHERE user_id = 3;
```
![New Level](./src/12.png)

---
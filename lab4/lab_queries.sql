SELECT COUNT(*) AS total_votes 
FROM votes;

SELECT 
    AVG(placement) AS avg_difficulty,
    MAX(placement) AS max_difficulty,
    MIN(placement) AS min_difficulty
FROM levels;

SELECT level_id, COUNT(*) AS vote_count
FROM votes
GROUP BY level_id;

SELECT level_id, COUNT(*) AS vote_count
FROM votes
GROUP BY level_id
HAVING COUNT(*) > 1;

SELECT 
    u.username, 
    l.name AS level_name, 
    v.is_agree
FROM votes v
INNER JOIN users u ON v.user_id = u.user_id
INNER JOIN levels l ON v.level_id = l.level_id;

SELECT 
    l.name, 
    COUNT(v.user_id) AS total_votes
FROM levels l
LEFT JOIN votes v ON l.level_id = v.level_id
GROUP BY l.name;

SELECT 
    u.username, 
    l.name AS level_name
FROM users u
CROSS JOIN levels l;

SELECT username 
FROM users 
WHERE user_id IN (
    SELECT user_id 
    FROM votes 
    WHERE is_agree = TRUE
);

SELECT 
    name, 
    (SELECT COUNT(*) FROM votes WHERE level_id = levels.level_id AND is_agree = TRUE) AS likes_count
FROM levels;

SELECT name, placement 
FROM levels 
WHERE placement > (
    SELECT AVG(placement) FROM levels
);
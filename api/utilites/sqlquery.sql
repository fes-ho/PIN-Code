-- Script for formatting the id of a member
SELECT 
    SUBSTR(id, 1, 8) || '-' || 
    SUBSTR(id, 9, 4) || '-' || 
    SUBSTR(id, 13, 4) || '-' || 
    SUBSTR(id, 17, 4) || '-' || 
    SUBSTR(id, 21, 12) AS formatted_id,
    username,
    email
FROM member;
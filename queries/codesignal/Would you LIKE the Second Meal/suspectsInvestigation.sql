SELECT id, name, surname
FROM Suspect
WHERE height <= 170 AND LOWER(name) LIKE 'b%' AND lower(surname) LIKE 'gre_n'
ORDER BY id ASC;
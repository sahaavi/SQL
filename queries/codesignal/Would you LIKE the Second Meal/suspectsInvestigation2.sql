SELECT id, name, surname
FROM Suspect
WHERE height <= 170 OR NOT (LOWER(name) LIKE 'b%' AND LOWER(surname) LIKE 'gre_n')
ORDER BY id ASC;
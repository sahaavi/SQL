SELECT name
FROM people_hobbies
WHERE FIND_IN_SET('sports',hobbies)>0 AND FIND_IN_SET('reading',hobbies)>0
ORDER BY name;
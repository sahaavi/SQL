SELECT WEEKDAY(mischief_date) AS weekday, mischief_date, author, title
FROM mischief
ORDER BY weekday ASC, 
CASE
WHEN author = 'Huey' THEN 1
WHEN author = 'Dewey' THEN 2
ELSE 3
END,
mischief_date,
title;
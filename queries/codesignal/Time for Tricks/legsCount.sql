 SELECT 
SUM(CASE
    WHEN type = "human" THEN 2
    ELSE 4
END) as summary_legs
FROM creatures
ORDER BY id;
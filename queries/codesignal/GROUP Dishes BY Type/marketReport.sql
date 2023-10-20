SELECT 
CASE 
    WHEN r.country IS NULL THEN 'Total:' 
    ELSE r.country END AS country, 
r.competitors
FROM (
    SELECT country, sum(1) AS competitors
    FROM foreignCompetitors
    GROUP BY country WITH ROLLUP;
) AS r;
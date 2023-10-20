SELECT RES.Name, RES.ID
FROM (SELECT Name, ID,
    (0.25 * Midterm1 + 0.25 * Midterm2 + 0.5 * Final) AS Op1,
    (0.5 * Midterm1 + 0.5 * Midterm2) AS Op2,
    Final AS Op3
    FROM Grades
    ) AS RES
WHERE Op3 > Op2 AND Op3 > Op1
ORDER BY LEFT(Name,3), ID;
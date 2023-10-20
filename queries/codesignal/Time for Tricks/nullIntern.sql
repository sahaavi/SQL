SELECT COUNT(*) AS number_of_nulls
FROM departments
WHERE 
  description IS NULL
  OR TRIM(UPPER(description)) IN ('NULL', 'NIL', '-');
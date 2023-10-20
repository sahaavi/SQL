SELECT *
FROM expressions
WHERE IF(operation = '+', a+b, IF(operation = '-', a-b, IF(operation = '*', a*b, a/b))) = c
ORDER BY id;
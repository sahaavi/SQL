-- % = any # of characters, _ = one character

-- Find any client's who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- Find an employee born in october
select *
from employee
where birth_day LIKE '____-10-__';
-- where birth_day LIKE '____-10%';
-- The SQL UNION Operator​​ The UNION operator is used to combine the result-set of two or more SELECT statements.
-- you have to have same no. of columns in each select statement

-- find a list of employee and branch names
select first_name
from employee
union
select salary
from employee
union
select branch_name
from branch;
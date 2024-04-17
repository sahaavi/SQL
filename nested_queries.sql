-- nested queries are queries where we use multiple select statement

-- find names of all employees who have sold
-- over 30,000 to a single client

select first_name
from employee
where emp_id in (
	select emp_id
	from works_with
	where total_sales > 30000
);

-- find all clients who are handled by the branch that Michale Scott
-- manages. Assume you know Michale's ID

select client_name
from client
where branch_id = (
	select branch_id
	from branch
	where mgr_id = (
		select emp_id
		from employee
		where first_name = 'Michael' and last_name = 'Scott'
	)
);

-- find all branches and the name of their managers

select e.emp_id, e.first_name, b.branch_name
from employee e join branch b 
on e.emp_id = b.mgr_id;

# it will keep all the rows from the left table
select e.emp_id, e.first_name, b.branch_name
from employee e left join branch b 
on e.emp_id = b.mgr_id;

# it will keep all the rows from the right table
select e.emp_id, e.first_name, b.branch_name
from employee e right join branch b 
on e.emp_id = b.mgr_id;

# there's another type of join which is full outer join which 
# combines everything from left and right basically it;s a combinaiton of left and right join.
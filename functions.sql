-- find the number of employees
select count(emp_id)
from employee;

-- find the number of supervisors
select count(super_id)
from employee;

-- find the number of female employees born after 1970
select count(*)
from employee
where sex = 'F' and birth_day > '1970-01-01';

-- find the average salaries of all employees
select avg(salary)
from employee;

-- find the average salaries of all male employees
select avg(salary)
from employee
where sex = 'M';

-- find out how many male and females there are
select count(*) AS count, sex
from employee
group by sex;

-- find the total sales of each salesman
select emp_id, sum(total_sales)
from works_with
group by emp_id;


select * from employee;
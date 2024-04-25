select * # * means we want all columns
from student;

select student_name, major
from student
Order by student_name desc;

# this will order the values by name first and then by major
select student_name, major
from student
Order by student_name, major desc;

# limit the result
select student_name, major
from student
Order by student_name, major desc
limit 2;

# filtering
select *
from student
where major = 'Data Science';

select *
from student
where major = 'Data Science' or major = 'Accounting';

# not equal to
select *
from student
where major <> 'Data Science';

select *
from student
where student_id <=4 and major <> 'Data Science';

select * 
from employee
where year(birth_day) = 1970;

# in
select *
from student
where student_name in ('Nuhad', 'Ram');

# find all employees ordered by salary
select *
from employee
order by salary;

# find the first 5 employee of the table
select *
from employee
limit 5;

# find out all the branch
select distinct branch_name
from branch;
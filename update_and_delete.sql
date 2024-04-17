select * from student;

update student
set major = 'Bio'
where major = 'Biology';

update student
set major = 'Biochemistry'
where major = 'Bio' OR major = 'Chemistry';

update student
set student_name = 'Tom', major = 'Undecided'
where student_id  = 1;

# this will effect all the rows in the table
update student
set major = 'Undecided';

# delete row
DELETE FROM student
where student_name = 'Tom' AND major = 'Undecided';

# delete all rows
DELETE FROM student;
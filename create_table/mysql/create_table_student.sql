USE learn_sql;
# creating the table
CREATE TABLE student (
	student_id INT,
    student_name varchar(20),
    major varchar(20),
    PRIMARY KEY (student_id)
);
# describe table
DESCRIBE student;

# delete table
DROP TABLE student;

# modify table
ALTER TABLE student ADD gpa DECIMAL(3,2);

# drop a column
ALTER TABLE student DROP COLUMN gpa;

# insert data into table
INSERT INTO student VALUES (1, 'Jack', 'Biology');

# check the table
SELECT * FROM student;

# insert more data into table
INSERT INTO student VALUES (2, 'Avi', 'Data Science');
INSERT INTO student(student_id, student_name) VALUES(3, 'Ontika');

# we want to change the student_name specifications
ALTER TABLE student
MODIFY student_name VARCHAR(20) NOT NULL;

# specify a default value for major field
ALTER TABLE student
MODIFY major VARCHAR(20) DEFAULT 'Undecided';

# now check by adding a new student without a major
INSERT INTO student(student_id, student_name) VALUES(4, 'Ram');

# auto_increment can be used for primary keys to add and auto increase the number of primary without
# explicitly mentioning them 
ALTER TABLE student
MODIFY student_id INT AUTO_INCREMENT;
INSERT INTO student(student_name, major) VALUES('Nuhad', 'Accounting');


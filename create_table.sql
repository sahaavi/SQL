# create schema
CREATE SCHEMA `learn_sql` ;
# select the database to use
USE learn_sql;
# create a table called emp
CREATE TABLE emp (
eno CHAR(5),
ename VARCHAR(30) NOT NULL,
bdate DATE,
title CHAR(2),
salary DECIMAL(9,2),
supereno CHAR(5),
dno CHAR(5),
PRIMARY KEY (eno)
);

CREATE TABLE proj(
	pno CHAR(5),
	pname VARCHAR(40),
	budget DECIMAL(9,2),
	dno CHAR(5)
);

ALTER TABLE proj
ADD PRIMARY KEY (pno);

CREATE TABLE dept(
	dno CHAR(5),
	dname VARCHAR(40),
	mgreno CHAR(5)
);

ALTER TABLE dept
ADD PRIMARY KEY (dno);

# create a table with foreign keys with Referential Integrity
CREATE TABLE workson (
eno CHAR(5),
pno CHAR(5),
resp VARCHAR(20),
hours SMALLINT,
PRIMARY KEY (eno,pno),
FOREIGN KEY (eno) REFERENCES emp(eno)
	ON DELETE NO ACTION
	ON UPDATE CASCADE,
FOREIGN KEY (pno) REFERENCES proj(pno)
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);

# adding constraints to emp table
ALTER TABLE emp
ADD FOREIGN KEY (supereno) REFERENCES emp(eno)
	ON DELETE SET NULL 
    ON UPDATE CASCADE,
ADD FOREIGN KEY (dno) REFERENCES dept(dno)
	ON DELETE SET NULL 
    ON UPDATE CASCADE
create table employee(
	emp_id int primary key,
    first_name varchar(40),
    last_name varchar(40),
    birth_day date,
    sex varchar(1),
    salary int,
    super_id int, # as we haven't ceated the employee table yet so we can't mention this as a foreign key
    branch_id int # as we haven't ceated the branch table yet so we can't mention this as a foreign key
);

create table branch (
	branch_id int primary key,
    branch_name varchar(40),
    mgr_id int,
    mgr_start_date date,
    foreign key(mgr_id) references employee(emp_id) on delete set null
);

# setting branch id as foreign key in employee table
alter table employee
add foreign key(branch_id)
references branch(branch_id)
on delete set null;

# setting super_id as foreign key in employee table
alter table employee
add foreign key(super_id)
references employee(emp_id)
on delete set null;

# creating client table
create table client (
	client_id int primary key,
    client_name varchar(40),
    branch_id int,
    foreign key(branch_id) references branch(branch_id) on delete set null
);

# creating works_with table
create table works_with (
	emp_id int,
    client_id int,
    total_sales int,
    primary key(emp_id, client_id),
    foreign key(emp_id) references employee(emp_id) on delete cascade,
    foreign key(client_id) references client(client_id) on delete cascade
);

# creating branch_supplier table
create table branch_supplier (
	branch_id int,
    supplier_name varchar(40),
    supplier_type varchar(40),
    primary key(branch_id, supplier_name),
    foreign key(branch_id) references branch(branch_id) on delete cascade
);

select * from branch_supplier;

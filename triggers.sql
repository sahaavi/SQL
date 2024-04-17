/*
An SQL trigger allows you to specify SQL actions that should be executed automatically 
when a specific event occurs in the database. For example, you can use a trigger to 
automatically update a record in one table whenever a record is inserted into another table.
*/
create table trigger_test(
	status varchar(30)
);
# this is chaning the ; to $$ because we're gonna use ; inside the loop
DELIMITER $$ 
create 
	trigger my_trigger before insert
    on employee
    for each row begin
		insert into trigger_test values('added new employee');        
	end $$
# this is changing the delimiter back into ;
delimiter ; 

# now insert a new row to the table
insert into employee values(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

select * from trigger_test;

# update the trigger - this will trigger after the first  one
DELIMITER $$ 
create 
	trigger my_trigger1 before insert
    on employee
    for each row begin
        insert into trigger_test values(new.first_name);
	end $$
# this is changing the delimiter back into ;
delimiter ; 

insert into employee values(110, 'Kelvin', 'Malone', '1968-02-19', 'M', 69000, 106, 3);

select * from trigger_test;

# drop previous triggers
DROP TRIGGER my_trigger;
DROP TRIGGER my_trigger1;

# we're using condition here
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;

INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

select * from trigger_test;

# we can also use trigger when update and delete
-- just use delete or update key inplace of insert
 -- we can also use after instead of brefore


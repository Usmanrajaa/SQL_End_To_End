SHOW DATABASES;
USE dsg_11;
show tables;

select * from employees;

-- view 
create view xyz as
select * from employees
where salary>50000;

select * from xyz;

update xyz
set salary=70000
where employee_id=4;

drop view xyz;
show tables;
-- index

create index idx_second_name
on employees(last_name);

select * from employees
where last_name="Brown";

describe employees;





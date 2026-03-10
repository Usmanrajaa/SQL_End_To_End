USE DSG_11;
SHOW TABLES;
SELECT * FROM EMPLOYEES;
SELECT * FROM departments;

-- non recursive CTE

with abc as(SELECT first_name, salary
from employees
where salary>60000)

select * from abc;

-- select avg(salary)
-- from xyz;

-- select max(salary)
-- from xyz;

show tables;


with xyz as(
SELECT first_name, salary
from employees
where salary>60000)
-- 1. find out xyz table detail
-- select * from xyz;

-- 2. find out avg of xyz salary column
select avg(salary)
from xyz;

-- RECURSIVE CTE


with manager as(
select * 
from employees
where is_manager=1
),
recent_hires as(
select *
from employees
where hire_date>'2019-01-01'
)
-- select * from manager
-- select * from recent_hires

-- Q1.->recent hires in the same department as managers

;

select * from employee_data;

create table employee_data(
emp_id int,
emp_name varchar(50),
manager_id int
);

insert into employee_data
values
(1,"A",null),
(2,"B",1),
(3,"C",2),
(4,"D",1),
(5,"E",2),
(6,"f",1),
(7,"G",3),
(8,"H",1),
(9,"I",9),
(10,"J",1),
(11,"K",7),
(12,"L",100),
(13,"M",101),
(14,"N",104),
(15,"O",109);


select * from employee_data;

-- Q-> find out employees who are directly or indirectly reporting to the manager
-- direct reporters to manager

select *
from employee_data
where manager_id=1;

with recursive xyz as(
-- anchor query
select *
from employee_data
where manager_id=1

union all
-- logic

select e.*
from employee_data e
join xyz x
on x.emp_id=e.manager_id
)

select * from xyz;





with recursive xyz as(
-- anchor query
select *,0 as label
from employee_data
where manager_id=1
union all
-- logic
select e.*,x.label+1 as label
from employee_data e
join xyz x
on x.emp_id=e.manager_id
)

-- select * from xyz;
-- 1. tell the no. of direct and indirect reporters
-- select count(*) as total_reporters
-- from xyz;
-- 2. find out all employees at level 3
select * from xyz
where label=3;





with recursive xyz as(
-- Anchor query
select * ,0 as label
from employee_data
where manager_id=1
-- Recursive 
union all
select e.*,x.label+1 as label
from employee_data e
inner join xyz  x
on
e.manager_id=x.emp_id
)

-- 1.  select * from xyz
-- 2.  select count(*) as count
-- from xyz
-- 3 
-- SELECT 
-- SUM(CASE WHEN label=0 THEN 1 END) AS C1,
-- SUM(CASE WHEN label=1 THEN 1 END) AS C2
-- FROM XYZ

-- 4
;



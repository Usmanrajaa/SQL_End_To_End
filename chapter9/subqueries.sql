show databases;
use dsg_11;
show tables;


select * from employees;
select * from orders;

select department,avg(salary)
from employees
group by department;

-- 1. Single row subquery (=,>,<,!=,<> etc.)
select *
from employees
where salary>
(select avg(salary)
from employees);

-- 2. multi row subquery 

select first_name,department
from employees
where employee_id in
(select employee_id
from orders
where status="Shipped");

insert into orders
values
(11,"i",'2025-11-11',5,"shipped");

select first_name,department
from employees 
where employee_id in(
select employee_id
from orders
where order_date>date_sub(now(),interval 1 month));

-- Q1. find out total numbers of Sales department whose order status has been shipped

-- Q2. Employees with their highest salary in their departments.


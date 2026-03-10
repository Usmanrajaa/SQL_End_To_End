show databases;
use dsg12;
show tables;
select * from employees;
select * from employee_projects;
select * from employees1;
select * from projects;
select * from sales;

-- joins
-- 1 INNER JOIN

select * 
from employees e
inner join employee_projects ep
on e.employee_id=ep.employee_id;

select * 
from employees e
left join employee_projects ep
on e.employee_id=ep.employee_id;

select * 
from employees e
right join employee_projects ep
on e.employee_id=ep.employee_id;

select * 
from employees e
cross join employee_projects ep
on e.employee_id=ep.employee_id;



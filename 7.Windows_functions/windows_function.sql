-- WINDOWS FUNCTIONS
-- 1. RANKING WF
-- ROW_NUMBER()
-- RANK()
-- DENSE_RANK()
-- NTILE(N)
-- 2. AGGREGATE WF
-- SUM()
-- AVG()
-- MIN()
-- MAX()

-- 3. VALUE WF
-- LAG()
-- LEAD()
-- FIRST_VALUE()
-- LAST_VALUE()

-- 4. RUNNING TOTALS/ FRAME FUNCTIONS

-- UNBOUNDED PRECEDING and current row
-- current row and UNBOUNDED FOLLOWING
-- n PRECEDING and current row
-- current row and n FOLLOWING
-- RANGE


USE DSG_11;
SHOW TABLES;

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM projects;

select first_name,last_name,department,
row_number() over() as row_index
from employees;



select first_name,last_name,department,salary,
rank() over(order by salary desc) as salary_rank
from employees;

select first_name,last_name,department,salary,
dense_rank() over(order by salary desc) as salary_rank
from employees;

select first_name,last_name,department,salary,
NTILE(4) over(order by salary desc) as salary_rank
from employees;

-- AGGREGATE WF

SELECT *,
SUM(salary) over(partition by department) as total_salary
from employees;


-- valued wf
select *,
lag(salary,2,0) over() as lagged_salary,
lag(hire_date,2,0) over() as lag_hire_date
from employees;

select *,
lead(salary,2,0) over() as lead_salary
from employees;

select *,
first_value(salary) over(partition by department) as lead_salary
from employees;

select *,
last_value(salary) over() as lead_salary
from employees;


select *,
sum(salary) over(rows between unbounded preceding and current row) as running_total_salary
from employees;

select *,
sum(salary) over(rows between 2 preceding and current row) as running_total_salary
from employees;

select *,
sum(salary) over(rows between current row and unbounded following) as running_total_salary
from employees;

select *,
sum(salary) over(
order by salary asc
range between unbounded preceding and current row) as running_total_salary
from employees;

-- what all could be written inside over() function
-- over(
-- partition by
-- order by
-- rows between
-- range
-- )


create table transactions(
txn_id int,
user_id int,
txn_date date,
amount int,
txn_status varchar(50)
);

insert into transactions
values
(1,1,'2025-01-01',300,"success"),
(2,1,'2025-01-03',600,"success"),
(3,1,'2025-01-09',900,"failed"),
(4,1,'2025-01-15',100,"success"),
(5,2,'2025-01-23',700,"failed"),
(6,2,'2025-01-09',250,"success"),
(7,2,'2025-01-08',1200,"success"),
(8,3,'2025-01-03',1300,"failed"),
(9,3,'2025-01-07',100,"failed"),
(10,3,'2025-01-25',700,"success"),
(11,3,'2025-01-13',800,"success");

select * from transactions;

## find for each transaction
## show previous succes transaction amount 
## if not success then null

select *,
lag(amount) over(partition by user_id order by txn_date) as prev_success_amount
from transactions
where txn_status="success";

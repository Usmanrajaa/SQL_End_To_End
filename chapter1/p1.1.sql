
<<<<<<< HEAD
USE sql_pract;

-- Select all columns

SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, department FROM employees;

-- Get unique departments
SELECT DISTINCT department FROM employees;

-- Get unique combinations
SELECT DISTINCT department, is_manager FROM employees;

-- Employees in Sales department
SELECT * FROM employees 
WHERE department = 'Sales';

-- Employees hired after 2020
SELECT * FROM employees 
WHERE hire_date > '2020-01-01';

-- Sort by salary ascending (default)

SELECT * FROM employees 
ORDER BY salary;

-- Sort by salary descending

SELECT * FROM employees 
ORDER BY salary DESC;

-- Multi-column sorting
SELECT * FROM employees 
ORDER BY department ASC, salary DESC;

-- Get top 3 highest paid employees
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- Equal to
SELECT * FROM employees 
WHERE department = 'IT';

-- Less than

SELECT * FROM 
employees WHERE salary < 60000;

-- Greater than
SELECT * FROM employees 
WHERE hire_date > '2020-01-01';

-- Not equal to (<> or !=)
SELECT * FROM employees 
WHERE department <> 'Sales';

-- AND operator
SELECT * FROM employees
WHERE department = 'Sales' AND salary > 50000;

-- OR operator
SELECT * FROM employees
WHERE department = 'HR' OR department = 'Marketing';

-- NOT operator
SELECT * FROM employees
WHERE NOT is_manager;

-- Salary between 50000 and 60000
SELECT * FROM employees
WHERE salary BETWEEN 50000 AND 60000;

-- Date range
SELECT * FROM employees
WHERE hire_date BETWEEN '2019-01-01' AND '2020-12-31';

-- Employees in specific departments

SELECT * FROM employees
WHERE department IN ('Sales', 'IT', 'HR');

-- Employees not in these departments
SELECT * FROM employees
WHERE department NOT IN ('Sales', 'IT', 'HR');

-- Assuming we add some NULL values
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;

SELECT first_name, last_name, salary,
    CASE
        WHEN salary < 50000 THEN 'Low'
        WHEN salary BETWEEN 50000 AND 70000 THEN 'Medium'
        ELSE 'High'
    END AS salary_level
FROM employees;

-- Aliases(AS)
SELECT first_name AS "First Name",
       last_name AS "Last Name",
       salary AS "Annual Salary"
FROM employees;

-- Can be used with subqueries
SELECT * FROM employees
WHERE employee_id IN (SELECT employee_id FROM managers);
=======

-- 1.Numeric Datatype

CREATE TABLE product(
product_id TINYINT , -- digit capacity 3
product_no SMALLINT, -- digit capacity 5
product_serial INT,  -- digit capacity 10
product_price DOUBLE(10,2), 
product_info BIGINT, -- digit capacity 19
);
INSERT INTO product
VALUES
(13,12,46758,44456.78,8957557758596);


-- 2.string datatypes

CREATE TABLE car(
car_name CHAR(20),
car_model VARCHAR(50),
car_info  TEXT,
car_category ENUM("electric","dieseal","petrol")
);
INSERT INTO car
VALUES
('mahindra','2022','world is facing dire backlash in car production','petrol');


-- 3.DATE AND TIME

CREATE TABLE sales(
sale_date DATE,
sale_time TIME,
purchased_at DATETIME,
delivered_at TIMESTAMP
);
INSERT INTO sales
VALUES
('2022-11-12','17:12:24','2022-11-12,17:12:24',NOW());
SELECT * FROM sales;


-- 4. BOOLEAN

CREATE TABLE verify(
is_delivered bool,
is_sold boolean
);
INSERT INTO verify
VALUES
(TRUE,FALSE);
SELECT * FROM verify;
>>>>>>> 63471e231db92a0e84e6e7536a7660f014cae163

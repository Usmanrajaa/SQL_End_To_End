
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

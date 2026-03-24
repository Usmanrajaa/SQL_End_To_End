
-- 1.1 Basic SELECT statements
-- ----------------------------------------
-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, salary FROM employees;

-- Select with calculated columns
SELECT first_name, salary, salary * 1.1 AS increased_salary FROM employees;

-- 1.2 WHERE clause with comparison operators
-- ----------------------------------------
-- Equal to
SELECT * FROM employees WHERE department = 'IT';

-- Not equal to
SELECT * FROM employees WHERE department != 'Sales';
SELECT * FROM employees WHERE department <> 'Sales';

-- Greater than / Less than
SELECT * FROM employees WHERE salary > 60000;
SELECT * FROM employees WHERE salary < 55000;
SELECT * FROM employees WHERE salary >= 50000;

-- BETWEEN (inclusive range)
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 70000;

-- 1.3 Multiple conditions
-- ----------------------------------------
-- AND operator
SELECT * FROM employees 
WHERE department = 'IT' AND salary > 65000;

-- OR operator
SELECT * FROM employees 
WHERE department = 'HR' OR salary > 70000;

-- Combined AND & OR (use parentheses!)
SELECT * FROM employees 
WHERE (department = 'IT' OR department = 'HR') 
  AND salary > 60000;

-- 1.4 IN and NOT IN operators
-- ----------------------------------------
-- IN (list of values)
SELECT * FROM employees 
WHERE department IN ('IT', 'HR', 'Sales');

-- NOT IN
SELECT * FROM employees 
WHERE department NOT IN ('Sales', 'Marketing');

-- 1.5 NULL handling
-- ----------------------------------------
-- IS NULL
SELECT * FROM employees 
WHERE middle_name IS NULL;

-- IS NOT NULL
SELECT * FROM employees 
WHERE email IS NOT NULL;
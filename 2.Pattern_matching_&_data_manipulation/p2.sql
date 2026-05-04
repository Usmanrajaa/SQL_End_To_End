-- ===================================================================
-- SELECT STATEMENTS & BASIC FILTERING: QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- ===================================================================

-- ===================================================================
-- 1.1 BASIC SELECT STATEMENTS
-- ===================================================================

-- Q1: How do you select all columns from the employees table?
SELECT * FROM employees;

-- Q2: How do you select only the first_name, last_name, and salary columns from employees?
SELECT first_name, last_name, salary FROM employees;

-- Q3: How do you select first_name, salary, and a calculated column that shows salary increased by 10%?
SELECT first_name, salary, salary * 1.1 AS increased_salary FROM employees;

-- ===================================================================
-- 1.2 WHERE CLAUSE WITH COMPARISON OPERATORS
-- ===================================================================

-- Q4: How do you select all employees whose department is exactly 'IT'? (Equality)
SELECT * FROM employees WHERE department = 'IT';

-- Q5: How do you select employees whose department is NOT 'Sales'? (Two syntaxes)
SELECT * FROM employees WHERE department != 'Sales';
SELECT * FROM employees WHERE department <> 'Sales';

-- Q6: How do you select employees with salary greater than 60,000?
SELECT * FROM employees WHERE salary > 60000;

-- Q7: How do you select employees with salary less than 55,000?
SELECT * FROM employees WHERE salary < 55000;

-- Q8: How do you select employees with salary greater than or equal to 50,000?
SELECT * FROM employees WHERE salary >= 50000;

-- Q9: How do you select employees with salary between 50,000 and 70,000 inclusive? (BETWEEN)
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 70000;

-- ===================================================================
-- 1.3 MULTIPLE CONDITIONS (AND / OR)
-- ===================================================================

-- Q10: How do you select employees who work in IT AND have a salary greater than 65,000?
SELECT * FROM employees 
WHERE department = 'IT' AND salary > 65000;

-- Q11: How do you select employees who work in HR OR have a salary greater than 70,000?
SELECT * FROM employees 
WHERE department = 'HR' OR salary > 70000;

-- Q12: How do you select employees who are in either IT or HR departments, and also have a salary greater than 60,000? (Use parentheses!)
SELECT * FROM employees 
WHERE (department = 'IT' OR department = 'HR') 
  AND salary > 60000;

-- ===================================================================
-- 1.4 IN AND NOT IN OPERATORS
-- ===================================================================

-- Q13: How do you select employees whose department is 'IT', 'HR', or 'Sales' using the IN operator?
SELECT * FROM employees 
WHERE department IN ('IT', 'HR', 'Sales');

-- Q14: How do you select employees whose department is NOT 'Sales' or 'Marketing' using NOT IN?
SELECT * FROM employees 
WHERE department NOT IN ('Sales', 'Marketing');

-- ===================================================================
-- 1.5 NULL HANDLING
-- ===================================================================

-- Q15: How do you select employees whose middle_name column contains a NULL value?
SELECT * FROM employees 
WHERE middle_name IS NULL;

-- Q16: How do you select employees who have a non-NULL email address?
SELECT * FROM employees 
WHERE email IS NOT NULL;

-- ===================================================================
-- END OF SCRIPT
-- ===================================================================

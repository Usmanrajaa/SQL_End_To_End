-- ===================================================================
-- PART 1: BASIC AGGREGATE FUNCTIONS
-- ===================================================================

-- 1.1 COUNT - Count rows
-- ----------------------------------------
-- Count all employees
SELECT COUNT(*) AS total_employees 
FROM employees;

-- Count non-NULL values in a column
SELECT COUNT(email) AS employees_with_email 
FROM employees;

-- Count distinct values
SELECT COUNT(DISTINCT department) AS unique_departments 
FROM employees;

-- 1.2 SUM - Sum of values
-- ----------------------------------------
-- Total salary expense
SELECT SUM(salary) AS total_salary_expense 
FROM employees;

-- Sum with condition
SELECT SUM(salary) AS it_salary_total 
FROM employees 
WHERE department = 'IT';

-- 1.3 AVG - Average of values
-- ----------------------------------------
-- Average salary
SELECT AVG(salary) AS average_salary 
FROM employees;

-- Average with rounding
SELECT ROUND(AVG(salary), 2) AS average_salary 
FROM employees;

-- 1.4 MIN and MAX - Minimum and Maximum
-- ----------------------------------------
-- Minimum salary
SELECT MIN(salary) AS lowest_salary 
FROM employees;

-- Maximum salary
SELECT MAX(salary) AS highest_salary 
FROM employees;

-- Get both min and max
SELECT 
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    MAX(salary) - MIN(salary) AS salary_range
FROM employees;

-- 1.5 Combined aggregate functions
-- ----------------------------------------
SELECT 
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM employees;

-- ===================================================================
-- PART 2: GROUP BY - BASIC GROUPING
-- ===================================================================

-- 2.1 Single column GROUP BY
-- ----------------------------------------
-- Count employees per department
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department;

-- 2.2 Multiple aggregates with GROUP BY
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM employees
GROUP BY department;

-- 2.3 GROUP BY with ORDER BY
-- ----------------------------------------
-- Order by count descending
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- 2.4 GROUP BY with WHERE (filter before grouping)
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
WHERE hire_date >= '2020-01-01'
GROUP BY department;

-- ===================================================================
-- PART 3: GROUP BY - MULTIPLE COLUMNS
-- ===================================================================

-- 3.1 Two-column GROUP BY
-- ----------------------------------------
SELECT 
    department,
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title
ORDER BY department, job_title;

-- 3.2 Three-column GROUP BY
-- ----------------------------------------
SELECT 
    department,
    job_title,
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title, YEAR(hire_date)
ORDER BY department, job_title, hire_year;

-- 3.3 GROUP BY with expressions
-- ----------------------------------------
SELECT 
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- ===================================================================
-- PART 4: HAVING - FILTERING GROUPS
-- ===================================================================

-- 4.1 Basic HAVING clause
-- ----------------------------------------
-- Departments with more than 5 employees
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- 4.2 HAVING with aggregate conditions
-- ----------------------------------------
-- Departments with average salary > 60000
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

-- 4.3 Multiple conditions in HAVING
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 3 
   AND AVG(salary) > 55000
   AND SUM(salary) > 200000;

-- 4.4 WHERE vs HAVING (combined)
-- ----------------------------------------
-- WHERE filters rows before grouping
-- HAVING filters groups after grouping
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
WHERE hire_date >= '2020-01-01'  -- Filter individual rows
GROUP BY department
HAVING COUNT(*) >= 3               -- Filter groups
ORDER BY employee_count DESC;

-- ===================================================================
-- PART 5: ADVANCED AGGREGATE FUNCTIONS
-- ===================================================================

-- 5.1 GROUP_CONCAT (MySQL) / STRING_AGG (PostgreSQL/SQL Server)
-- ----------------------------------------
-- MySQL syntax
SELECT 
    department,
    COUNT(*) AS employee_count,
    GROUP_CONCAT(first_name ORDER BY first_name) AS employee_names
FROM employees
GROUP BY department;

-- PostgreSQL syntax (if using PostgreSQL)
-- SELECT 
--     department,
--     COUNT(*) AS employee_count,
--     STRING_AGG(first_name, ', ' ORDER BY first_name) AS employee_names
-- FROM employees
-- GROUP BY department;

-- 5.2 STDDEV and VARIANCE
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_stddev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

-- 5.3 Multiple aggregate functions together
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(DISTINCT job_title) AS unique_jobs,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    MEDIAN(salary) AS median_salary,  -- Not available in all databases
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_range,
    STDDEV(salary) AS salary_stddev
FROM employees
GROUP BY department;

-- ===================================================================
-- PART 6: AGGREGATION WITH CASE STATEMENTS
-- ===================================================================

-- 6.1 Conditional counting with CASE
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 70000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN salary BETWEEN 50000 AND 70000 THEN 1 END) AS mid_earners,
    COUNT(CASE WHEN salary < 50000 THEN 1 END) AS low_earners
FROM employees
GROUP BY department;

-- 6.2 Conditional sums
-- ----------------------------------------
SELECT 
    department,
    SUM(salary) AS total_salary,
    SUM(CASE WHEN salary > 70000 THEN salary ELSE 0 END) AS high_earner_salary,
    SUM(CASE WHEN salary <= 70000 THEN salary ELSE 0 END) AS low_earner_salary
FROM employees
GROUP BY department;

-- 6.3 Percentage calculations with CASE
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 70000 THEN 1 END) AS high_earners,
    ROUND(100.0 * COUNT(CASE WHEN salary > 70000 THEN 1 END) / COUNT(*), 2) AS pct_high_earners
FROM employees
GROUP BY department;

-- ===================================================================
-- PART 7: ROLLUP, CUBE, AND GROUPING SETS (Advanced)
-- ===================================================================

-- 7.1 WITH ROLLUP (MySQL) - Subtotals and grand total
-- ----------------------------------------
-- MySQL syntax
SELECT 
    department,
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title WITH ROLLUP;

-- 7.2 GROUPING function with ROLLUP
-- ----------------------------------------
-- MySQL syntax
SELECT 
    IF(GROUPING(department), 'All Departments', department) AS department,
    IF(GROUPING(job_title), 'All Jobs', job_title) AS job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title WITH ROLLUP;

-- 7.3 GROUPING SETS (PostgreSQL, SQL Server)
-- ----------------------------------------
-- PostgreSQL syntax
-- SELECT 
--     department,
--     job_title,
--     COUNT(*) AS employee_count,
--     AVG(salary) AS avg_salary
-- FROM employees
-- GROUP BY GROUPING SETS (
--     (department, job_title),
--     (department),
--     ()
-- );

-- ===================================================================
-- PART 8: AGGREGATION WITH JOINS
-- ===================================================================

-- 8.1 Aggregating from multiple tables
-- ----------------------------------------
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    COUNT(DISTINCT e.job_title) AS distinct_jobs
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 8.2 Aggregation with multiple joins
-- ----------------------------------------
SELECT 
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    COUNT(DISTINCT p.project_id) AS project_count,
    AVG(e.salary) AS avg_salary,
    SUM(p.budget) AS total_budget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_name;

-- ===================================================================
-- PART 9: HAVING WITH COMPLEX CONDITIONS
-- ===================================================================

-- 9.1 HAVING with multiple aggregates
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5 
   AND AVG(salary) > 60000
   AND SUM(salary) > 500000;

-- 9.2 HAVING with subqueries
-- ----------------------------------------
-- Departments with above-average salary
SELECT 
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- Departments with more employees than average
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > (SELECT AVG(emp_count) 
                   FROM (SELECT COUNT(*) AS emp_count 
                         FROM employees 
                         GROUP BY department) AS dept_counts);

-- ===================================================================
-- PART 10: WINDOW FUNCTIONS (Advanced Aggregation)
-- ===================================================================

-- 10.1 Window functions vs GROUP BY
-- ----------------------------------------
-- GROUP BY (collapsed results)
SELECT 
    department,
    AVG(salary) AS dept_avg
FROM employees
GROUP BY department;

-- Window function (preserves all rows)
SELECT 
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees;

-- 10.2 Multiple window functions
-- ----------------------------------------
SELECT 
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept,
    SUM(salary) OVER (PARTITION BY department) AS dept_total
FROM employees;

-- ===================================================================
-- PART 11: COMPREHENSIVE EXAMPLES (INTERVIEW STYLE)
-- ===================================================================

-- 11.1 Department salary analysis
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND(STDDEV(salary), 2) AS salary_stddev,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(MAX(salary) - MIN(salary), 2) AS salary_range,
    SUM(CASE WHEN salary > 70000 THEN 1 ELSE 0 END) AS high_earners,
    ROUND(100.0 * SUM(CASE WHEN salary > 70000 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_high_earners
FROM employees
WHERE hire_date >= '2018-01-01'
GROUP BY department
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC;

-- 11.2 Year-over-year hiring analysis
-- ----------------------------------------
SELECT 
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS employees_hired,
    AVG(salary) AS avg_hire_salary,
    SUM(salary) AS total_hire_salary,
    COUNT(CASE WHEN department = 'IT' THEN 1 END) AS it_hires,
    COUNT(CASE WHEN department = 'Sales' THEN 1 END) AS sales_hires
FROM employees
GROUP BY YEAR(hire_date)
HAVING COUNT(*) > 5
ORDER BY hire_year;

-- 11.3 Department performance metrics
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    COUNT(DISTINCT job_title) AS unique_roles,
    AVG(salary) AS avg_salary,
    AVG(DATEDIFF(CURDATE(), hire_date)) AS avg_tenure_days,
    SUM(CASE WHEN performance_rating >= 4 THEN 1 ELSE 0 END) AS high_performers,
    ROUND(AVG(CASE WHEN performance_rating >= 4 THEN salary END), 2) AS avg_high_performer_salary
FROM employees
GROUP BY department
HAVING employee_count >= 5
ORDER BY avg_salary DESC;

-- 11.4 Complex filtering with multiple aggregations
-- ----------------------------------------
SELECT 
    department,
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    SUM(salary) AS total_salary,
    GROUP_CONCAT(DISTINCT first_name ORDER BY first_name) AS employee_names
FROM employees
WHERE salary > 40000
GROUP BY department, job_title
HAVING COUNT(*) >= 2 
   AND AVG(salary) > 55000
ORDER BY department, avg_salary DESC;

-- 11.5 Percentage distribution analysis
-- ----------------------------------------
SELECT 
    department,
    COUNT(*) AS employee_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 2) AS pct_of_total,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND(100.0 * AVG(salary) / (SELECT AVG(salary) FROM employees), 2) AS pct_of_avg_salary
FROM employees
GROUP BY department
ORDER BY employee_count DESC;


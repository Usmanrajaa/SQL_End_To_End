-- ===================================================================
-- AGGREGATE FUNCTIONS & GROUPING: QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- ===================================================================

-- ===================================================================
-- PART 1: BASIC AGGREGATE FUNCTIONS
-- ===================================================================

-- Q1: How do you count all rows in the employees table?
SELECT COUNT(*) AS total_employees 
FROM employees;

-- Q2: How do you count only non-NULL values in the email column?
SELECT COUNT(email) AS employees_with_email 
FROM employees;

-- Q3: How do you count distinct departments in the employees table?
SELECT COUNT(DISTINCT department) AS unique_departments 
FROM employees;

-- Q4: How do you calculate the total salary expense for all employees?
SELECT SUM(salary) AS total_salary_expense 
FROM employees;

-- Q5: How do you sum salaries only for employees in the IT department?
SELECT SUM(salary) AS it_salary_total 
FROM employees 
WHERE department = 'IT';

-- Q6: How do you calculate the average salary of all employees?
SELECT AVG(salary) AS average_salary 
FROM employees;

-- Q7: How do you calculate the average salary rounded to 2 decimal places?
SELECT ROUND(AVG(salary), 2) AS average_salary 
FROM employees;

-- Q8: How do you find the minimum salary in the company?
SELECT MIN(salary) AS lowest_salary 
FROM employees;

-- Q9: How do you find the maximum salary in the company?
SELECT MAX(salary) AS highest_salary 
FROM employees;

-- Q10: How do you retrieve both min and max salaries together, and calculate the range?
SELECT 
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary,
    MAX(salary) - MIN(salary) AS salary_range
FROM employees;

-- Q11: How do you combine all basic aggregates (COUNT, SUM, AVG, MIN, MAX) in one query?
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

-- Q12: Write a query to count employees per department using GROUP BY.
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department;

-- Q13: Write a query that shows, per department, the count of employees, total salary, average salary, min and max salary.
SELECT 
    department,
    COUNT(*) AS employee_count,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM employees
GROUP BY department;

-- Q14: Write a GROUP BY query that orders the result by employee count descending.
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- Q15: Write a GROUP BY query with a WHERE clause that filters rows before grouping (only employees hired after 2020-01-01).
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

-- Q16: Write a query that groups by department and job_title, showing employee count and average salary.
SELECT 
    department,
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title
ORDER BY department, job_title;

-- Q17: Write a three-column GROUP BY that includes department, job_title, and the hire year.
SELECT 
    department,
    job_title,
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title, YEAR(hire_date)
ORDER BY department, job_title, hire_year;

-- Q18: Write a GROUP BY query that uses an expression – grouping by the year of hire_date.
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

-- Q19: Show departments that have more than 5 employees (use HAVING).
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

-- Q20: Show departments where the average salary exceeds 60000.
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

-- Q21: Write a HAVING clause with multiple conditions: employee count > 3, average salary > 55000, and total salary > 200000.
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

-- Q22: Demonstrate the difference between WHERE and HAVING: filter rows to hires after 2020, then only departments with at least 3 such employees.
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

-- Q23: Use GROUP_CONCAT (MySQL) to list employee names per department, ordered alphabetically.
-- Assumes MySQL. For PostgreSQL use STRING_AGG.
SELECT 
    department,
    COUNT(*) AS employee_count,
    GROUP_CONCAT(first_name ORDER BY first_name) AS employee_names
FROM employees
GROUP BY department;

-- Q24: Calculate standard deviation and variance of salary per department.
SELECT 
    department,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_stddev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;

-- Q25: Write a comprehensive query that combines multiple aggregates: total employees, distinct jobs, total salary, avg, median (if available), min, max, range, stddev.
-- Note: MEDIAN may not be available in all databases; this example includes it for illustration.
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(DISTINCT job_title) AS unique_jobs,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary,
    MEDIAN(salary) AS median_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_range,
    STDDEV(salary) AS salary_stddev
FROM employees
GROUP BY department;

-- ===================================================================
-- PART 6: AGGREGATION WITH CASE STATEMENTS
-- ===================================================================

-- Q26: Use conditional counting with CASE to count employees by salary band per department (high >70000, mid 50000-70000, low <50000).
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 70000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN salary BETWEEN 50000 AND 70000 THEN 1 END) AS mid_earners,
    COUNT(CASE WHEN salary < 50000 THEN 1 END) AS low_earners
FROM employees
GROUP BY department;

-- Q27: Use conditional summing to separate total salary from high earners vs others.
SELECT 
    department,
    SUM(salary) AS total_salary,
    SUM(CASE WHEN salary > 70000 THEN salary ELSE 0 END) AS high_earner_salary,
    SUM(CASE WHEN salary <= 70000 THEN salary ELSE 0 END) AS low_earner_salary
FROM employees
GROUP BY department;

-- Q28: Calculate the percentage of high earners per department using CASE inside aggregation.
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

-- Q29: Use WITH ROLLUP (MySQL) to get subtotals and grand total for department and job_title.
SELECT 
    department,
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title WITH ROLLUP;

-- Q30: Use GROUPING function with ROLLUP to label summary rows in MySQL.
SELECT 
    IF(GROUPING(department), 'All Departments', department) AS department,
    IF(GROUPING(job_title), 'All Jobs', job_title) AS job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title WITH ROLLUP;

-- Q31: (PostgreSQL style) Use GROUPING SETS to get multiple grouping levels.
-- This is kept as a comment because syntax varies; adapt for your DB.
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

-- Q32: Aggregate from departments LEFT JOIN employees: show department name, employee count, average salary, distinct job titles.
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary,
    COUNT(DISTINCT e.job_title) AS distinct_jobs
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Q33: Aggregation with multiple joins (departments, employees, projects): show department name, employee count, project count, avg salary, total budget.
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

-- Q34: Write a HAVING clause with multiple aggregate conditions: employee count > 5, average salary > 60000, total salary > 500000.
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

-- Q35: Use HAVING with a subquery to find departments with average salary above the company average.
SELECT 
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);

-- Q36: Use HAVING with a subquery to find departments that have more employees than the average number of employees across departments.
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

-- Q37: Compare GROUP BY (collapsed) with a window function (preserves rows) – show department average salary both ways.
-- GROUP BY version:
SELECT 
    department,
    AVG(salary) AS dept_avg
FROM employees
GROUP BY department;

-- Window function version (preserves all rows):
SELECT 
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees;

-- Q38: Write a query with multiple window functions: department average, rank within department, department total sum.
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

-- Q39: Department salary analysis – include count, average, stddev, min, max, range, number and percentage of high earners (>70000), filter hire_date >= 2018, only departments with >=3 employees, order by avg salary.
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

-- Q40: Year-over-year hiring analysis – group by hire year, show count, avg salary, total salary, IT hires, Sales hires, only years with >5 hires.
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

-- Q41: Department performance metrics – include employee count, unique roles, avg salary, avg tenure (days), high performer count (rating >=4), average salary of high performers. Only departments with >=5 employees.
-- Note: assumes columns performance_rating and DATEDIFF exist.
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

-- Q42: Complex filtering with multiple aggregations – group by department and job_title, filter salary > 40000 before grouping, require count >=2 and avg salary > 55000, show employee names as concatenated string.
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

-- Q43: Percentage distribution analysis – show each department's employee count, percentage of total employees, average salary, and percentage of company average salary.
SELECT 
    department,
    COUNT(*) AS employee_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 2) AS pct_of_total,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND(100.0 * AVG(salary) / (SELECT AVG(salary) FROM employees), 2) AS pct_of_avg_salary
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

-- ===================================================================
-- END OF SCRIPT
-- ===================================================================

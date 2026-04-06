-- =========================================================
-- LEVEL 1: JOINS FUNDAMENTALS
-- =========================================================

-- 1.1 What is a JOIN?
-- A JOIN combines rows from two or more tables based on a related column

-- 1.2 JOIN Syntax Structure
/*
SELECT columns
FROM table1
[JOIN_TYPE] table2 ON join_condition
[WHERE filter_condition]
[GROUP BY group_columns]
[HAVING group_filter]
[ORDER BY sort_columns];
*/

-- 1.3 JOIN Conditions (ON vs USING)
-- Using ON (most common, works for any condition)
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- Using USING (when column names are identical)
SELECT * FROM employees e
INNER JOIN departments d USING (department);  -- Only works if column names match exactly

-- 1.4 JOIN Types Overview
/*
INNER JOIN     - Returns rows that match in both tables
LEFT JOIN      - Returns all rows from left table + matches from right
RIGHT JOIN     - Returns all rows from right table + matches from left
FULL JOIN      - Returns all rows from both tables (not directly in MySQL)
CROSS JOIN     - Returns Cartesian product (every row from left × every row from right)
SELF JOIN      - Joining a table with itself
NATURAL JOIN   - Joins on columns with same name (automatic, risky)
*/

-- 1.5 NULL Handling in Joins
-- NULL values never match with anything, including other NULLs
-- Use COALESCE or IS NULL to handle NULLs in join conditions
SELECT * FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.employee_id IS NULL;  -- Finds employees with no projects


-- =========================================================
-- LEVEL 2: INNER JOIN
-- =========================================================

-- 2.1 Basic INNER JOIN
-- Returns only rows where there's a match in BOTH tables
SELECT e.first_name, e.last_name, e.salary, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 2.2 INNER JOIN with Multiple Conditions
SELECT e.first_name, e.last_name, p.project_name, p.budget
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id 
                      AND p.budget > 50000;

-- 2.3 INNER JOIN with 3+ Tables
SELECT e.first_name, e.last_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 2.4 INNER JOIN with WHERE Clause
SELECT e.first_name, e.last_name, e.salary, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > 60000 AND d.budget > 200000;

-- 2.5 INNER JOIN with Aliases
-- Use table aliases for readability
SELECT emp.first_name, emp.last_name, dept.dept_name
FROM employees AS emp
INNER JOIN departments AS dept ON emp.department = dept.dept_name;

-- 2.6 INNER JOIN vs Comma Join (Old Syntax)
-- Old syntax (avoid):
SELECT * FROM employees e, departments d WHERE e.department = d.dept_name;
-- Modern syntax (preferred):
SELECT * FROM employees e INNER JOIN departments d ON e.department = d.dept_name;

-- 2.7 Self INNER JOIN
-- Finding pairs of employees in same department
SELECT e1.first_name AS employee1, e2.first_name AS employee2, e1.department
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e1.employee_id < e2.employee_id;

-- 2.8 Non-Equi INNER JOIN
-- Joining on condition other than equality
-- Find employees whose salary is within department budget range
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary <= d.budget / 5;  -- Non-equi condition


-- =========================================================
-- LEVEL 3: LEFT JOIN (LEFT OUTER JOIN)
-- =========================================================

-- 3.1 Basic LEFT JOIN
-- Returns ALL rows from left table, matched rows from right table
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 3.2 LEFT JOIN with WHERE (Filtering Right Table)
-- Be careful: Filtering on right table in WHERE converts to INNER JOIN
-- Correct way - filter in ON clause:
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;

-- Wrong way (this becomes INNER JOIN for filtered rows):
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;  -- This removes employees with NULL projects!

-- 3.3 LEFT JOIN to Find Missing Rows
-- Find employees with NO projects
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.project_id IS NULL;

-- 3.4 LEFT JOIN with Multiple Conditions
SELECT e.first_name, e.last_name, p.project_name, p.budget
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id 
                     AND p.start_date >= '2024-01-01';

-- 3.5 LEFT JOIN with 3+ Tables
SELECT e.first_name, e.last_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 3.6 LEFT JOIN with COALESCE
-- Replace NULL values with default
SELECT e.first_name, 
       COALESCE(p.project_name, 'No Project') AS project_name,
       COALESCE(p.budget, 0) AS project_budget
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 3.7 LEFT JOIN with COUNT (Beware of NULLs)
-- COUNT(column) ignores NULLs, COUNT(*) counts all rows
SELECT e.department,
       COUNT(*) AS total_employees,
       COUNT(p.project_id) AS employees_with_projects
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY e.department;

-- 3.8 LEFT JOIN vs INNER JOIN Comparison
-- INNER JOIN: Only employees with projects
SELECT COUNT(*) FROM employees e INNER JOIN projects p ON e.employee_id = p.employee_id;
-- LEFT JOIN: All employees (with or without projects)
SELECT COUNT(*) FROM employees e LEFT JOIN projects p ON e.employee_id = p.employee_id;


-- =========================================================
-- LEVEL 4: RIGHT JOIN (RIGHT OUTER JOIN)
-- =========================================================

-- 4.1 Basic RIGHT JOIN
-- Returns ALL rows from right table, matched rows from left table
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;

-- 4.2 RIGHT JOIN Use Cases
-- Shows all projects, even unassigned ones
SELECT p.project_name, e.first_name AS assigned_to
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;

-- 4.3 RIGHT JOIN vs LEFT JOIN (Convertibility)
-- These two queries are equivalent:
-- Query 1 (RIGHT JOIN)
SELECT * FROM employees e RIGHT JOIN projects p ON e.employee_id = p.employee_id;
-- Query 2 (LEFT JOIN - tables swapped)
SELECT * FROM projects p LEFT JOIN employees e ON p.employee_id = e.employee_id;

-- 4.4 RIGHT JOIN with Multiple Tables
SELECT p.project_name, e.first_name, d.dept_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN departments d ON e.department = d.dept_name;

-- 4.5 When to Use RIGHT JOIN (Rare Cases)
-- Some people find RIGHT JOIN more readable in certain scenarios
-- Most developers prefer LEFT JOIN for consistency
-- Example: Finding unassigned projects (using RIGHT JOIN)
SELECT p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;


-- =========================================================
-- LEVEL 5: FULL OUTER JOIN
-- =========================================================

-- 5.1 FULL OUTER JOIN Syntax (MySQL Workaround)
-- MySQL doesn't support FULL OUTER JOIN directly
-- Must simulate using UNION of LEFT and RIGHT JOIN

-- 5.2 FULL OUTER JOIN using UNION
-- Returns all rows from both tables, matching where possible
SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION

SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;

-- 5.3 FULL OUTER JOIN using UNION ALL (More efficient but needs duplicate handling)
-- Use UNION ALL if you know there are no duplicates
SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION ALL

SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;  -- Exclude duplicates from LEFT JOIN

-- 5.4 FULL OUTER JOIN with WHERE Filter
SELECT COALESCE(e.first_name, 'Unassigned') AS employee,
       COALESCE(p.project_name, 'No Project') AS project
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION

SELECT COALESCE(e.first_name, 'Unassigned'),
       COALESCE(p.project_name, 'No Project')
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;

-- 5.5 FULL OUTER JOIN vs LEFT + RIGHT UNION
-- Same result, but FULL OUTER JOIN is standard SQL
-- Most databases (PostgreSQL, SQL Server) support FULL OUTER JOIN:
-- SELECT * FROM employees FULL OUTER JOIN projects ON employees.employee_id = projects.employee_id;

-- 5.6 Simulating FULL OUTER JOIN with UNION and DUMMY Column
SELECT 
    e.employee_id AS emp_id,
    e.first_name,
    p.project_id,
    p.project_name,
    CASE 
        WHEN e.employee_id IS NOT NULL AND p.project_id IS NOT NULL THEN 'Match'
        WHEN e.employee_id IS NOT NULL THEN 'Only Employee'
        ELSE 'Only Project'
    END AS join_status
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION

SELECT 
    e.employee_id,
    e.first_name,
    p.project_id,
    p.project_name,
    CASE 
        WHEN e.employee_id IS NOT NULL AND p.project_id IS NOT NULL THEN 'Match'
        WHEN e.employee_id IS NOT NULL THEN 'Only Employee'
        ELSE 'Only Project'
    END
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;  -- Avoid duplicates


-- =========================================================
-- LEVEL 6: CROSS JOIN
-- =========================================================

-- 6.1 Basic CROSS JOIN (Cartesian Product)
-- Returns every row from first table combined with every row from second table
-- If table1 has 10 rows and table2 has 5 rows, result has 50 rows
SELECT e.first_name, p.project_name
FROM employees e
CROSS JOIN projects p;

-- 6.2 CROSS JOIN with WHERE (Simulates INNER JOIN)
-- Old-style implicit join (avoid this)
SELECT e.first_name, p.project_name
FROM employees e, projects p
WHERE e.employee_id = p.employee_id;  -- This is actually an INNER JOIN

-- Modern approach: Use explicit INNER JOIN instead
SELECT e.first_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 6.3 CROSS JOIN for Generating Test Data
-- Generate all combinations of years and months
CREATE TEMPORARY TABLE years (year INT);
CREATE TEMPORARY TABLE months (month INT);
INSERT INTO years VALUES (2023), (2024);
INSERT INTO months VALUES (1,2,3,4,5,6,7,8,9,10,11,12);

SELECT y.year, m.month
FROM years y
CROSS JOIN months m
ORDER BY y.year, m.month;

-- 6.4 CROSS JOIN for Combinations
-- Generate all possible employee-department assignments
SELECT e.first_name, d.dept_name
FROM employees e
CROSS JOIN departments d;

-- 6.5 CROSS JOIN with Aggregations
-- Calculate percentage of total
SELECT e.first_name, e.salary,
       e.salary / total.total_salary * 100 AS percentage
FROM employees e
CROSS JOIN (SELECT SUM(salary) AS total_salary FROM employees) total;

-- 6.6 CROSS JOIN Performance Considerations
-- WARNING: CROSS JOIN can be very expensive
-- A table with 10,000 rows CROSS JOIN with 10,000 rows = 100 million rows
-- Always use WHERE clause to limit results if needed
-- Consider if you really need CROSS JOIN or can use a different approach


-- =========================================================
-- LEVEL 7: SELF JOIN
-- =========================================================

-- 7.1 Basic Self Join
-- Joining a table with itself using different aliases
SELECT e1.first_name AS employee, e2.first_name AS colleague, e1.department
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE e1.employee_id != e2.employee_id;

-- 7.2 Self Join for Hierarchical Data (Employee-Manager)
-- Finding manager for each employee
SELECT e1.first_name AS employee, 
       e2.first_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- 7.3 Self Join for Comparing Rows
-- Find employees with salary higher than another employee in same department
SELECT e1.first_name AS employee1, e1.salary AS salary1,
       e2.first_name AS employee2, e2.salary AS salary2
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE e1.salary > e2.salary AND e1.employee_id != e2.employee_id;

-- 7.4 Self Join for Finding Duplicates
-- Find duplicate emails (if they existed)
SELECT e1.employee_id, e1.email, e2.employee_id
FROM employees e1
INNER JOIN employees e2 ON e1.email = e2.email
WHERE e1.employee_id < e2.employee_id;

-- 7.5 Self Join with Aggregation
-- Compare each employee's salary to department average
SELECT e1.first_name, e1.salary, AVG(e2.salary) AS dept_avg
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
GROUP BY e1.employee_id, e1.first_name, e1.salary;

-- 7.6 Self Join for Date Ranges
-- Find employees hired within 30 days of each other in same department
SELECT e1.first_name, e1.hire_date,
       e2.first_name, e2.hire_date,
       DATEDIFF(e2.hire_date, e1.hire_date) AS days_diff
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE DATEDIFF(e2.hire_date, e1.hire_date) BETWEEN 1 AND 30;

-- 7.7 Self Join for Sequential Data
-- Find next hire date for each employee
SELECT e1.first_name, e1.hire_date,
       MIN(e2.hire_date) AS next_hire_date
FROM employees e1
LEFT JOIN employees e2 ON e2.hire_date > e1.hire_date
GROUP BY e1.employee_id, e1.first_name, e1.hire_date;


-- =========================================================
-- LEVEL 8: NATURAL JOIN (Use with Caution)
-- =========================================================

-- 8.1 Basic NATURAL JOIN
-- Automatically joins on columns with same name
-- DANGEROUS: Don't know which columns will be used for join
SELECT * FROM employees
NATURAL JOIN departments;  -- Joins on any columns with same name (department?)

-- 8.2 NATURAL JOIN Risks
-- If both tables have 'department' column, it joins on that
-- If they also have 'created_date' column, it will join on that too
-- Can lead to unexpected results

-- 8.3 NATURAL LEFT JOIN
SELECT * FROM employees
NATURAL LEFT JOIN departments;

-- 8.4 NATURAL RIGHT JOIN
SELECT * FROM employees
NATURAL RIGHT JOIN departments;

-- 8.5 Why Avoid NATURAL JOIN
-- 1. Unintentional join columns
-- 2. Schema changes break queries silently
-- 3. Not explicit - hard to maintain
-- 4. Most companies prohibit in coding standards
-- Better to use explicit INNER/LEFT JOIN with ON clause


-- =========================================================
-- LEVEL 9: JOIN WITH CLAUSES
-- =========================================================

-- 9.1 JOIN with WHERE
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE e.salary > 60000 AND p.budget < 50000;

-- 9.2 JOIN with AND vs WHERE (Condition Placement)
-- Condition in ON (evaluated before JOIN)
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;

-- Condition in WHERE (evaluated after JOIN - can convert OUTER to INNER)
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;  -- WARNING: Filters out NULLs, effectively becomes INNER JOIN

-- 9.3 JOIN with ORDER BY
SELECT e.first_name, e.salary, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
ORDER BY d.budget DESC, e.salary DESC;

-- 9.4 JOIN with GROUP BY
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 9.5 JOIN with HAVING
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count, AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.employee_id) > 2;

-- 9.6 JOIN with LIMIT
SELECT e.first_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
LIMIT 5;

-- 9.7 JOIN with DISTINCT
-- Remove duplicates that may appear from multiple matches
SELECT DISTINCT e.department, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;


-- =========================================================
-- LEVEL 10: COMPLEX JOIN CONDITIONS
-- =========================================================

-- 10.1 Non-Equi Joins (>, <, >=, <=, <>)
-- Find employees with salary greater than department average
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department = e.department);

-- 10.2 JOIN with BETWEEN
-- Join employees to projects that started within their hire year
SELECT e.first_name, e.hire_date, p.project_name, p.start_date
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE YEAR(p.start_date) BETWEEN YEAR(e.hire_date) AND YEAR(e.hire_date) + 2;

-- 10.3 JOIN with LIKE Pattern Matching
-- Join departments to projects with similar names
SELECT d.dept_name, p.project_name
FROM departments d
INNER JOIN projects p ON p.project_name LIKE CONCAT('%', d.dept_name, '%');

-- 10.4 JOIN with IN
-- Find employees in departments with budget > 200,000
SELECT e.first_name, e.department
FROM employees e
WHERE e.department IN (SELECT dept_name FROM departments WHERE budget > 200000);

-- 10.5 JOIN with EXISTS/NOT EXISTS
-- Find departments that have employees (using EXISTS)
SELECT d.dept_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);

-- Find departments with no employees (using NOT EXISTS)
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);

-- 10.6 JOIN with Date Ranges
-- Find projects that overlap with employee's hire anniversary
SELECT e.first_name, e.hire_date, p.project_name, p.start_date, p.end_date
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE DATE_ADD(e.hire_date, INTERVAL 1 YEAR) BETWEEN p.start_date AND p.end_date;

-- 10.7 JOIN with Multiple Conditions
SELECT e.first_name, p.project_name, p.budget, e.salary
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > e.salary * 0.8  -- Project budget > 80% of salary
  AND p.start_date >= '2024-01-01';

-- 10.8 JOIN with OR Conditions
-- Find employees who either manage a department OR lead a project
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
LEFT JOIN departments d ON e.employee_id = d.manager_id
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE d.manager_id IS NOT NULL OR p.employee_id IS NOT NULL;


-- =========================================================
-- LEVEL 11: JOINS WITH MULTIPLE TABLES
-- =========================================================

-- 11.1 3-Table Join Patterns
-- Employees → Departments → Projects
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 11.2 4+ Table Joins
-- Adding more dimension tables
SELECT e.first_name, d.dept_name, p.project_name, m.first_name AS manager_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN employees m ON d.manager_id = m.employee_id;

-- 11.3 Star Schema Joins (Fact + Dimensions)
-- Fact table: projects (measures)
-- Dimension tables: employees, departments
SELECT 
    f.project_name,
    f.budget AS fact_budget,
    d.dept_name,
    d.budget AS dept_budget,
    e.first_name,
    e.salary
FROM projects f  -- Fact table
INNER JOIN employees e ON f.employee_id = e.employee_id  -- Employee dimension
INNER JOIN departments d ON e.department = d.dept_name;  -- Department dimension

-- 11.4 Snowflake Schema Joins
-- Department → Location (additional dimension)
-- First add location table
CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50)
);
ALTER TABLE departments ADD COLUMN location_id INT;

-- Snowflake join
SELECT e.first_name, d.dept_name, l.city, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- 11.5 Many-to-Many Join Handling
-- Bridge table required for many-to-many relationships
CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY (employee_id, project_id)
);

-- Join through bridge table
SELECT e.first_name, p.project_name, ep.role
FROM employees e
INNER JOIN employee_projects ep ON e.employee_id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.project_id;

-- 11.6 Circular Joins (Avoid)
-- Don't create circular references in joins
-- This can create infinite loops or incorrect results
-- BAD EXAMPLE:
SELECT * FROM table1 t1
JOIN table2 t2 ON t1.id = t2.t1_id
JOIN table3 t3 ON t2.id = t3.t2_id
JOIN table1 t1_2 ON t3.id = t1_2.t3_id;  -- Circular!

-- 11.7 Chaining LEFT JOINs (Order Matters)
-- Order of LEFT JOINs affects results
-- Example: First LEFT JOIN, then INNER JOIN
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
-- This INNER JOIN will filter out employees with no projects
-- To avoid, put LEFT JOIN at the end
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN departments d ON e.department = d.dept_name;


-- =========================================================
-- LEVEL 12: JOINS WITH AGGREGATIONS
-- =========================================================

-- 12.1 JOIN with COUNT
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 12.2 JOIN with SUM
SELECT d.dept_name, SUM(e.salary) AS total_salary_expense
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 12.3 JOIN with AVG
SELECT d.dept_name, AVG(e.salary) AS average_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 12.4 JOIN with MIN/MAX
SELECT d.dept_name, 
       MIN(e.salary) AS min_salary,
       MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 12.5 JOIN with GROUP BY
-- Multiple aggregations with GROUP BY
SELECT 
    d.dept_name,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    COUNT(p.project_id) AS project_count,
    SUM(e.salary) AS total_salary,
    AVG(p.budget) AS avg_project_budget
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;

-- 12.6 JOIN with HAVING
-- Find departments with total salary > 150,000
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name
HAVING SUM(e.salary) > 150000;

-- 12.7 Avoiding Double Counting in Aggregations
-- BAD: This double counts employees if they have multiple projects
SELECT d.dept_name, 
       COUNT(e.employee_id) AS employee_count,  -- WRONG: Counts employees per project
       COUNT(p.project_id) AS project_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;

-- GOOD: Aggregate before joining or use DISTINCT
SELECT d.dept_name, 
       COUNT(DISTINCT e.employee_id) AS employee_count,  -- Correct
       COUNT(p.project_id) AS project_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;

-- BEST: Aggregate in subqueries first
SELECT 
    d.dept_name,
    emp.employee_count,
    proj.project_count
FROM departments d
LEFT JOIN (SELECT department, COUNT(*) AS employee_count 
           FROM employees GROUP BY department) emp 
    ON d.dept_name = emp.department
LEFT JOIN (SELECT e.department, COUNT(*) AS project_count
           FROM projects p
           INNER JOIN employees e ON p.employee_id = e.employee_id
           GROUP BY e.department) proj 
    ON d.dept_name = proj.department;

-- 12.8 Aggregating Before vs After JOIN
-- Aggregate BEFORE JOIN (usually more efficient)
SELECT d.dept_name, emp_stats.avg_salary
FROM departments d
INNER JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) emp_stats ON d.dept_name = emp_stats.department;

-- Aggregate AFTER JOIN (can be less efficient with large datasets)
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;

-- 12.9 JOIN with ROLLUP/CUBE
-- Adding subtotals and grand totals
SELECT 
    COALESCE(d.dept_name, 'All Departments') AS department,
    COALESCE(e.is_manager, 'All Types') AS is_manager,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_name, e.is_manager WITH ROLLUP;


-- =========================================================
-- LEVEL 13: JOINS WITH SUBQUERIES
-- =========================================================

-- 13.1 Subquery in JOIN (Derived Table)
-- Join with a subquery as a derived table
SELECT e.first_name, dept_stats.avg_salary
FROM employees e
INNER JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) dept_stats ON e.department = dept_stats.department;

-- 13.2 JOIN with Derived Tables (Multiple)
SELECT 
    e.first_name,
    e.salary,
    dept_stats.avg_salary,
    dept_stats.total_salary,
    proj_stats.project_count
FROM employees e
INNER JOIN (
    SELECT department, 
           AVG(salary) AS avg_salary,
           SUM(salary) AS total_salary
    FROM employees
    GROUP BY department
) dept_stats ON e.department = dept_stats.department
LEFT JOIN (
    SELECT e.department, COUNT(*) AS project_count
    FROM projects p
    INNER JOIN employees e ON p.employee_id = e.employee_id
    GROUP BY e.department
) proj_stats ON e.department = proj_stats.department;

-- 13.3 JOIN with CTE (Common Table Expression)
-- More readable than derived tables
WITH dept_stats AS (
    SELECT department, 
           AVG(salary) AS avg_salary,
           COUNT(*) AS emp_count
    FROM employees
    GROUP BY department
),
proj_stats AS (
    SELECT e.department, COUNT(*) AS project_count
    FROM projects p
    INNER JOIN employees e ON p.employee_id = e.employee_id
    GROUP BY e.department
)
SELECT d.dept_name, 
       ds.emp_count,
       ds.avg_salary,
       COALESCE(ps.project_count, 0) AS project_count
FROM departments d
LEFT JOIN dept_stats ds ON d.dept_name = ds.department
LEFT JOIN proj_stats ps ON d.dept_name = ps.department;

-- 13.4 JOIN with Scalar Subquery
-- Subquery in SELECT clause (correlated)
SELECT e.first_name, 
       e.salary,
       (SELECT AVG(salary) FROM employees WHERE department = e.department) AS dept_avg
FROM employees e;

-- 13.5 EXISTS vs JOIN
-- EXISTS (often more efficient for existence checks)
SELECT d.dept_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);

-- Equivalent INNER JOIN
SELECT DISTINCT d.dept_name
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department;

-- 13.6 NOT EXISTS vs LEFT JOIN WHERE NULL
-- NOT EXISTS (usually more efficient)
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);

-- LEFT JOIN with NULL check
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
WHERE e.employee_id IS NULL;

-- 13.7 IN vs JOIN Performance
-- IN (good for small lists)
SELECT * FROM employees 
WHERE department IN ('Sales', 'Marketing', 'IT');

-- JOIN (better for large datasets)
SELECT e.*
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE d.dept_name IN ('Sales', 'Marketing', 'IT');


-- =========================================================
-- LEVEL 14: SPECIALIZED JOINS
-- =========================================================

-- 14.1 ANTI JOIN (Finding Non-Matches)
-- Find employees who never managed a project
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.project_id IS NULL;

-- Using NOT EXISTS (same result)
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (SELECT 1 FROM projects p WHERE p.employee_id = e.employee_id);

-- 14.2 SEMI JOIN (Finding Matches Without Duplicates)
-- Find employees who have at least one project (without duplicates)
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- Using EXISTS (often more efficient, no DISTINCT needed)
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (SELECT 1 FROM projects p WHERE p.employee_id = e.employee_id);

-- 14.3 Theta Join
-- Join on condition other than equality
-- Example: Find employees with salary greater than department average
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department = e.department);

-- 14.4 Equi Join vs Theta Join
-- Equi Join (equality condition)
SELECT * FROM employees e INNER JOIN departments d ON e.department = d.dept_name;

-- Theta Join (non-equality condition)
SELECT * FROM employees e INNER JOIN departments d ON e.salary < d.budget;

-- 14.5 Recursive Joins (Hierarchy Queries)
-- MySQL 8.0+ with recursive CTE
WITH RECURSIVE employee_hierarchy AS (
    -- Anchor member: top-level employees (managers)
    SELECT employee_id, first_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: employees reporting to others
    SELECT e.employee_id, e.first_name, e.manager_id, h.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM employee_hierarchy ORDER BY level, employee_id;

-- 14.6 Temporal Joins (Effective Date Ranges)
-- Employee salary history table
CREATE TABLE salary_history (
    employee_id INT,
    salary DECIMAL(10,2),
    effective_date DATE,
    end_date DATE
);

-- Join to get salary at project start date
SELECT e.first_name, p.project_name, p.start_date, sh.salary
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
INNER JOIN salary_history sh ON e.employee_id = sh.employee_id
    AND p.start_date BETWEEN sh.effective_date AND sh.end_date;

-- 14.7 Fuzzy Joins (Similarity Matching)
-- Using LIKE for fuzzy matching
SELECT e.first_name, d.dept_name
FROM employees e
CROSS JOIN departments d
WHERE e.department LIKE CONCAT('%', SUBSTRING(d.dept_name, 1, 3), '%');


-- =========================================================
-- LEVEL 15: PERFORMANCE OPTIMIZATION
-- =========================================================

-- 15.1 Indexing for Joins
-- Create indexes on join columns
CREATE INDEX idx_emp_department ON employees(department);
CREATE INDEX idx_dept_name ON departments(dept_name);
CREATE INDEX idx_proj_employee ON projects(employee_id);

-- 15.2 Join Order (Smallest Table First)
-- MySQL's optimizer usually determines best order
-- But you can influence with STRAIGHT_JOIN
SELECT STRAIGHT_JOIN e.first_name, d.dept_name
FROM departments d  -- Smaller table first
INNER JOIN employees e ON d.dept_name = e.department;

-- 15.3 Join Algorithms
/*
Nested Loop Join: Default for most joins
Hash Join: Used for large, unsorted data (MySQL 8.0+)
Merge Join: Used for sorted data
*/

-- Force hash join (MySQL 8.0+)
SELECT /*+ HASH_JOIN(e, d) */ e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 15.4 EXPLAIN ANALYZE for Joins
-- Analyze query execution plan
EXPLAIN FORMAT=JSON
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 15.5 Avoiding Cartesian Products
-- Always specify JOIN conditions
-- BAD: Missing ON clause
SELECT * FROM employees e, departments d;  -- Cartesian product

-- GOOD: Always use ON
SELECT * FROM employees e 
INNER JOIN departments d ON e.department = d.dept_name;

-- 15.6 Join Cardinality Estimation
-- Help optimizer with accurate statistics
ANALYZE TABLE employees;
ANALYZE TABLE departments;

-- 15.7 Materialized Views for Complex Joins
-- Create summary table for frequently used joins
CREATE TABLE emp_dept_summary AS
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- Refresh periodically
TRUNCATE TABLE emp_dept_summary;
INSERT INTO emp_dept_summary
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 15.8 Denormalization vs Joins
-- Denormalized table (pre-joined for performance)
CREATE TABLE emp_dept_denormalized AS
SELECT e.*, d.budget AS dept_budget, d.location
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name;

-- Trade-off: Faster reads, slower writes, more storage

-- 15.9 Batch Joining for Large Datasets
-- Process in chunks
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.employee_id BETWEEN 1 AND 1000;

-- 15.10 Partitioned Table Joins
-- Use partition pruning for better performance
-- Assumes tables are partitioned by date
SELECT e.first_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE p.start_date BETWEEN '2024-01-01' AND '2024-12-31';


-- =========================================================
-- LEVEL 16: JOIN PITFALLS & COMMON ERRORS
-- =========================================================

-- 16.1 Cartesian Product (Missing JOIN Condition)
-- BAD: Missing join condition
SELECT e.first_name, d.dept_name
FROM employees e, departments d;  -- Returns 10 × 5 = 50 rows

-- GOOD: Proper join condition
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 16.2 Double Counting in One-to-Many Joins
-- BAD: Counts employees multiple times if they have multiple projects
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;  -- Wrong count!

-- GOOD: Use DISTINCT or aggregate before joining
SELECT d.dept_name, COUNT(DISTINCT e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;  -- Correct count

-- 16.3 NULL Handling in JOIN Conditions
-- BAD: NULLs never match
SELECT * FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name AND d.budget IS NOT NULL;
-- Employees with NULL department won't match

-- GOOD: Handle NULLs explicitly
SELECT * FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
WHERE e.department IS NOT NULL;

-- 16.4 Incorrect JOIN Type Selection
-- Using INNER JOIN when you need LEFT JOIN
-- BAD: Excludes employees without projects
SELECT e.first_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- GOOD: Includes all employees
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 16.5 Ambiguous Column Names
-- BAD: Column name exists in multiple tables
SELECT employee_id, first_name, department
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;  -- department is ambiguous

-- GOOD: Use table aliases
SELECT e.employee_id, e.first_name, e.department
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 16.6 JOIN Condition Data Type Mismatch
-- BAD: Comparing different data types (INT vs VARCHAR)
SELECT * FROM employees e
INNER JOIN departments d ON e.department = CAST(d.dept_id AS CHAR);

-- GOOD: Ensure same data types
-- Convert to consistent type
SELECT * FROM employees e
INNER JOIN departments d ON e.department = CAST(d.dept_id AS CHAR);

-- 16.7 Performance Issues with OR in JOIN
-- BAD: OR condition can prevent index usage
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name OR e.employee_id = d.manager_id;

-- GOOD: Use UNION instead
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
UNION
SELECT * FROM employees e
INNER JOIN departments d ON e.employee_id = d.manager_id;

-- 16.8 Functions in JOIN Conditions
-- BAD: Function on column prevents index usage
SELECT * FROM employees e
INNER JOIN departments d ON UPPER(e.department) = UPPER(d.dept_name);

-- GOOD: Store data consistently or use generated columns
-- Create a normalized column
ALTER TABLE employees ADD COLUMN department_upper VARCHAR(50) 
GENERATED ALWAYS AS (UPPER(department)) STORED;
CREATE INDEX idx_department_upper ON employees(department_upper);

-- 16.9 Implicit JOIN vs Explicit JOIN
-- OLD STYLE (avoid): Hard to read, easy to miss conditions
SELECT e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.department = d.dept_name;

-- MODERN STYLE (preferred): Clear, maintainable
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 16.10 Chained LEFT JOIN Misunderstandings
-- BAD: This INNER JOIN will filter out NULLs from previous LEFT JOIN
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
-- Employees without projects are excluded!

-- GOOD: Keep consistent join types
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
LEFT JOIN projects p ON e.employee_id = p.employee_id;

-- 16.11 WHERE Clause Nullifying OUTER JOIN
-- BAD: WHERE filter on right table converts LEFT JOIN to INNER JOIN
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;  -- Removes employees with NULL projects

-- GOOD: Put filter in ON clause
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;

-- 16.12 Duplicate Rows from Multiple Joins
-- Problem: Multiple matches in joined tables create duplicates
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
-- If an employee has 3 projects, they appear 3 times

-- Solution: Use DISTINCT or aggregate
SELECT DISTINCT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;


-- =========================================================
-- LEVEL 17: DATABASE-SPECIFIC JOINS
-- =========================================================

-- 17.1 MySQL Joins (Default)
-- Standard SQL joins work in MySQL
SELECT * FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id;

-- MySQL also supports STRAIGHT_JOIN (force join order)
SELECT STRAIGHT_JOIN * FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id;

-- 17.2 PostgreSQL Joins (USING, NATURAL)
-- PostgreSQL supports standard joins plus:
-- USING clause (when column names match)
SELECT * FROM employees e
INNER JOIN departments d USING (department);  -- Column name must match

-- NATURAL JOIN (use with caution)
SELECT * FROM employees NATURAL JOIN departments;

-- 17.3 SQL Server Joins (HASH, MERGE hints)
-- SQL Server supports join hints
SELECT * FROM employees e
INNER HASH JOIN departments d ON e.department = d.dept_name;

-- 17.4 Oracle Joins (+ syntax, ANSI)
-- Oracle old syntax (still works, but avoid)
SELECT e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.department = d.dept_name(+);  -- (+) indicates outer join

-- Oracle ANSI syntax (preferred)
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name;

-- 17.5 Cross-Database Joins
-- MySQL: Join tables from different databases
SELECT * FROM company_db.employees e
INNER JOIN sql_pract.departments d ON e.department = d.dept_name;

-- 17.6 Federated Table Joins
-- Join local table with remote table (MySQL Federated Engine)
-- Create federated table first
CREATE TABLE remote_employees (
    employee_id INT,
    first_name VARCHAR(50)
) ENGINE=FEDERATED
CONNECTION='mysql://user:pass@remote_host:3306/remote_db/employees';

-- Then join normally
SELECT * FROM local_table l
INNER JOIN remote_employees r ON l.id = r.employee_id;


-- =========================================================
-- LEVEL 18: PRACTICAL BUSINESS SCENARIOS
-- =========================================================

-- 18.1 E-commerce: Customers-Orders-Products
/*
SELECT c.customer_name, COUNT(o.order_id) AS order_count, SUM(od.quantity) AS total_items
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;
*/

-- 18.2 HR: Employees-Departments-Salaries
-- Department budget utilization
SELECT d.dept_name, d.budget, 
       SUM(e.salary) AS total_salary_expense,
       (SUM(e.salary) / d.budget) * 100 AS budget_utilization_pct
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name, d.budget;

-- 18.3 Education: Students-Courses-Enrollments
/*
SELECT s.student_name, COUNT(DISTINCT c.course_id) AS courses_taken, AVG(e.grade) AS avg_grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.student_name;
*/

-- 18.4 Healthcare: Doctors-Appointments-Patients
/*
SELECT d.doctor_name, COUNT(a.appointment_id) AS total_appointments, 
       COUNT(DISTINCT p.patient_id) AS unique_patients
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date >= '2024-01-01'
GROUP BY d.doctor_id, d.doctor_name;
*/

-- 18.5 Inventory: Products-Categories-Suppliers
-- Find slow-moving products
SELECT p.product_name, c.category_name, s.supplier_name,
       COALESCE(SUM(si.quantity), 0) AS total_sold
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN sales_items si ON p.product_id = si.product_id
LEFT JOIN sales sa ON si.sale_id = sa.sale_id AND sa.sale_date >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY p.product_id, p.product_name, c.category_name, s.supplier_name
HAVING total_sold = 0;

-- 18.6 Analytics: Users-Logs-Sessions
/*
SELECT u.user_id, COUNT(DISTINCT DATE(l.log_time)) AS active_days,
       COUNT(l.log_id) AS total_actions
FROM users u
LEFT JOIN logs l ON u.user_id = l.user_id
WHERE l.log_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY u.user_id;
*/

-- 18.7 Banking: Accounts-Transactions
-- Find accounts with unusual activity
SELECT a.account_number, 
       COUNT(t.transaction_id) AS transaction_count,
       SUM(t.amount) AS total_amount,
       AVG(t.amount) AS avg_transaction
FROM accounts a
INNER JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY a.account_id, a.account_number
HAVING transaction_count > 100 OR total_amount > 100000;

-- 18.8 Social Media: Posts-Comments-Likes
/*
SELECT p.post_id, p.content, 
       COUNT(DISTINCT c.comment_id) AS comment_count,
       COUNT(DISTINCT l.like_id) AS like_count
FROM posts p
LEFT JOIN comments c ON p.post_id = c.post_id
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content;
*/

-- 18.9 Logistics: Orders-Payments-Shipping
-- Find delayed shipments
SELECT o.order_id, o.order_date, 
       p.payment_date, s.shipping_date,
       DATEDIFF(s.shipping_date, o.order_date) AS days_to_ship
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipping s ON o.order_id = s.order_id
WHERE s.shipping_date > DATE_ADD(o.order_date, INTERVAL 5 DAY);

-- 18.10 Project Management: Projects-Tasks-Assignees
-- Project completion status
SELECT p.project_name, 
       COUNT(t.task_id) AS total_tasks,
       SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks,
       ROUND(SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) / COUNT(t.task_id) * 100, 2) AS completion_pct
FROM projects p
LEFT JOIN tasks t ON p.project_id = t.project_id
GROUP BY p.project_id, p.project_name;


-- =========================================================
-- LEVEL 19: INTERVIEW-STYLE JOIN PROBLEMS
-- =========================================================

-- 19.1 Find employees without managers
SELECT e1.first_name AS employee
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IS NULL;

-- 19.2 Find customers who never ordered
/*
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
*/

-- 19.3 Find products never purchased
/*
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
*/

-- 19.4 Find second highest salary per department
SELECT e1.department, e1.first_name, e1.salary
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e1.salary <= e2.salary
GROUP BY e1.employee_id, e1.department, e1.first_name, e1.salary
HAVING COUNT(DISTINCT e2.salary) = 2;

-- 19.5 Find overlapping date ranges
-- Find projects that overlap in time
SELECT p1.project_name AS project1, p2.project_name AS project2,
       p1.start_date, p1.end_date, p2.start_date, p2.end_date
FROM projects p1
INNER JOIN projects p2 ON p1.project_id < p2.project_id
WHERE p1.start_date <= p2.end_date AND p1.end_date >= p2.start_date;

-- 19.6 Find duplicate records using self join
-- Find employees with same name (potential duplicates)
SELECT e1.employee_id, e2.employee_id, e1.first_name, e1.last_name
FROM employees e1
INNER JOIN employees e2 ON e1.first_name = e2.first_name 
                        AND e1.last_name = e2.last_name
                        AND e1.employee_id < e2.employee_id;

-- 19.7 Find cumulative sum with self join
-- Running total of salaries by department
SELECT e1.employee_id, e1.first_name, e1.salary, e1.department,
       SUM(e2.salary) AS running_total
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e2.employee_id <= e1.employee_id
GROUP BY e1.employee_id, e1.first_name, e1.salary, e1.department
ORDER BY e1.department, e1.employee_id;

-- 19.8 Find percentage of total using cross join
SELECT e.first_name, e.salary, 
       e.salary / total.total_salary * 100 AS pct_of_total
FROM employees e
CROSS JOIN (SELECT SUM(salary) AS total_salary FROM employees) total;

-- 19.9 Generate date series with cross join
-- Generate all dates in 2024
SELECT DATE('2024-01-01') + INTERVAL (a.n + b.n * 10) DAY AS date
FROM (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
CROSS JOIN (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) b
WHERE DATE('2024-01-01') + INTERVAL (a.n + b.n * 10) DAY <= '2024-12-31'
ORDER BY date;

-- 19.10 Find hierarchical path (org chart)
-- MySQL 8.0+ recursive CTE
WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, manager_id, 
           CAST(first_name AS CHAR(1000)) AS path, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.employee_id, e.first_name, e.manager_id,
           CONCAT(oc.path, ' -> ', e.first_name), oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart ORDER BY level, employee_id;


-- =========================================================
-- LEVEL 20: ADVANCED JOIN PATTERNS
-- =========================================================

-- 20.1 Joining on Multiple Columns
-- Composite key join
SELECT e.first_name, e.department, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id 
                      AND e.department = p.department;  -- If department column exists in projects

-- 20.2 Joining on Computed Columns
-- Join using derived values
SELECT e.first_name, e.salary, d.dept_name
FROM employees e
INNER JOIN departments d ON ROUND(e.salary / 1000) = ROUND(d.budget / 1000);

-- 20.3 Joining on LIKE Pattern
-- Find projects that match employee expertise
SELECT e.first_name, e.notes, p.project_name
FROM employees e
INNER JOIN projects p ON p.project_name LIKE CONCAT('%', SUBSTRING_INDEX(e.notes, ' ', 1), '%');

-- 20.4 Joining on Range (BETWEEN)
-- Assign salary grades
CREATE TABLE salary_grades (
    grade_id INT PRIMARY KEY,
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2),
    grade_name VARCHAR(50)
);

INSERT INTO salary_grades VALUES
(1, 0, 49999, 'Entry'),
(2, 50000, 64999, 'Mid'),
(3, 65000, 79999, 'Senior'),
(4, 80000, 999999, 'Executive');

-- Join employees to salary grades
SELECT e.first_name, e.salary, sg.grade_name
FROM employees e
INNER JOIN salary_grades sg ON e.salary BETWEEN sg.min_salary AND sg.max_salary;

-- 20.5 Joining on Substring
-- Join based on email domain
SELECT e.first_name, e.email, d.dept_name
FROM employees e
INNER JOIN departments d ON SUBSTRING_INDEX(e.email, '@', -1) = CONCAT(d.dept_name, '.com');

-- 20.6 Joining with Date Parts
-- Find projects starting in same month as employee hire
SELECT e.first_name, e.hire_date, p.project_name, p.start_date
FROM employees e
INNER JOIN projects p ON MONTH(e.hire_date) = MONTH(p.start_date)
WHERE YEAR(p.start_date) = 2024;

-- 20.7 Joining with CASE Expressions
-- Conditional join logic
SELECT e.first_name, e.salary, d.dept_name, d.budget,
       CASE 
           WHEN e.salary > 70000 THEN 'High'
           WHEN e.salary > 50000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_category
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;

-- 20.8 Self Join with Date Gaps
-- Find gaps in hire dates per department
SELECT e1.department, e1.first_name, e1.hire_date,
       MIN(e2.hire_date) AS next_hire_date,
       DATEDIFF(MIN(e2.hire_date), e1.hire_date) AS days_gap
FROM employees e1
LEFT JOIN employees e2 ON e1.department = e2.department AND e2.hire_date > e1.hire_date
GROUP BY e1.employee_id, e1.department, e1.first_name, e1.hire_date
HAVING days_gap > 30;

-- 20.9 Asymmetric Joins
-- Join where one side has aggregated data
SELECT e.department, 
       e.first_name, 
       e.salary,
       dept_stats.avg_salary,
       e.salary - dept_stats.avg_salary AS salary_diff
FROM employees e
INNER JOIN (SELECT department, AVG(salary) AS avg_salary 
            FROM employees 
            GROUP BY department) dept_stats 
    ON e.department = dept_stats.department;

-- 20.10 Semi-join Optimization
-- Using IN instead of JOIN for better performance with large datasets
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.department IN (SELECT dept_name FROM departments WHERE budget > 200000);

-- Equivalent JOIN (may be slower with large datasets)
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE d.budget > 200000;
-- =========================================================
-- LEVEL 1: SUBQUERY FUNDAMENTALS
-- =========================================================

-- 1.1 What is a Subquery?
-- A subquery is a query nested inside another query
-- Also called inner query or nested query
-- Can return: scalar (single value), row, or table

-- 1.2 Subquery Syntax Structure
/*
SELECT columns
FROM table
WHERE column OPERATOR (
    SELECT columns
    FROM another_table
    WHERE conditions
);
*/

-- 1.3 Subquery Types Overview
/*
1. Scalar Subquery: Returns 1 row, 1 column (single value)
2. Row Subquery: Returns 1 row, multiple columns
3. Table Subquery: Returns multiple rows, multiple columns
4. Correlated Subquery: References outer query columns
5. Non-Correlated: Independent of outer query
*/

-- 1.4 Where Subqueries Can Be Used
/*
- SELECT clause (scalar subqueries)
- FROM clause (derived tables)
- WHERE clause (filtering)
- HAVING clause (group filtering)
- ORDER BY clause
- INSERT, UPDATE, DELETE statements
- JOIN conditions
- WITH clause (CTEs)
*/

-- 1.5 Subquery Execution Order
/*
Non-correlated: Inner query executes first, then outer
Correlated: Outer query row by row, inner for each row
*/

-- Example: Execution order demonstration
-- Non-correlated (inner runs once)
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);  -- AVG calculated once

-- Correlated (inner runs for each employee)
SELECT e1.first_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id  -- References outer query
);  -- AVG calculated per department

-- =========================================================
-- LEVEL 2: SCALAR SUBQUERIES
-- =========================================================

-- 2.1 Scalar Subquery in SELECT Clause (from your code)
-- Add company average salary to each row
SELECT
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary
FROM employees;

-- Add department average salary (correlated scalar)
SELECT
    e1.first_name,
    e1.last_name,
    e1.salary,
    (SELECT AVG(e2.salary) 
     FROM employees e2 
     WHERE e2.dept_id = e1.dept_id) AS dept_avg_salary
FROM employees e1;

-- 2.2 Scalar Subquery in WHERE Clause (from your code)
-- Find employees earning above company average
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find employees earning above their department average (correlated)
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- 2.3 Scalar Subquery in HAVING Clause
-- Find departments with average salary above company average
SELECT 
    d.dept_name,
    AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

-- 2.4 Scalar Subquery in ORDER BY
-- Order employees by how far their salary is from department average
SELECT 
    first_name, 
    last_name, 
    salary,
    dept_id
FROM employees e1
ORDER BY ABS(salary - (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
)) DESC;

-- 2.5 Scalar Subquery with Aggregate Functions
-- Employee salary as percentage of company total
SELECT 
    first_name,
    salary,
    (salary / (SELECT SUM(salary) FROM employees) * 100) AS pct_of_total
FROM employees
ORDER BY pct_of_total DESC;

-- 2.6 Handling NULL in Scalar Subqueries
-- Use COALESCE to handle NULL results
SELECT 
    first_name,
    last_name,
    COALESCE((
        SELECT AVG(score)
        FROM performance_reviews pr
        WHERE pr.employee_id = e.employee_id
    ), 0) AS avg_review_score
FROM employees e;


-- =========================================================
-- LEVEL 3: ROW SUBQUERIES
-- =========================================================

-- 3.1 Row Constructor Comparison
-- Compare entire row at once
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) = (
    SELECT MAX(salary), dept_id
    FROM employees
    WHERE dept_id = 1
    GROUP BY dept_id
);

-- 3.2 Row Subquery in WHERE Clause
-- Find employee with same salary and department as employee 1
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) = (
    SELECT salary, dept_id
    FROM employees
    WHERE employee_id = 1
);

-- 3.3 Row Subquery with IN
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) IN (
    SELECT MAX(salary), dept_id
    FROM employees
    GROUP BY dept_id
);

-- 3.4 Row Subquery with EXISTS
SELECT * FROM employees e
WHERE EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
    AND (pr.score, pr.review_date) = (5, '2023-01-15')
);


-- =========================================================
-- LEVEL 4: TABLE SUBQUERIES
-- =========================================================

-- 4.1 Table Subquery in FROM Clause (Derived Table) (from your code)
-- Get department average salaries
SELECT dept_name, avg_salary
FROM (
    SELECT
        d.dept_name,
        AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
) AS dept_avg
WHERE avg_salary > 50000;

-- Multiple derived tables
SELECT 
    dept_stats.dept_name,
    dept_stats.employee_count,
    review_stats.avg_review_score
FROM (
    SELECT dept_id, COUNT(*) AS employee_count
    FROM employees
    GROUP BY dept_id
) AS dept_stats
JOIN (
    SELECT e.dept_id, AVG(pr.score) AS avg_review_score
    FROM performance_reviews pr
    JOIN employees e ON pr.employee_id = e.employee_id
    GROUP BY e.dept_id
) AS review_stats ON dept_stats.dept_id = review_stats.dept_id;

-- 4.2 Table Subquery with JOIN
-- Join employees with their latest review
SELECT e.first_name, e.last_name, latest_review.score
FROM employees e
JOIN (
    SELECT employee_id, MAX(review_date) AS latest_date
    FROM performance_reviews
    GROUP BY employee_id
) AS latest ON e.employee_id = latest.employee_id
JOIN performance_reviews latest_review 
    ON latest.employee_id = latest_review.employee_id 
    AND latest.latest_date = latest_review.review_date;

-- 4.3 Table Subquery in WITH Clause (CTE)
-- More readable version of derived tables
WITH dept_avg AS (
    SELECT
        d.dept_name,
        AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
)
SELECT dept_name, avg_salary
FROM dept_avg
WHERE avg_salary > 50000;

-- Multiple CTEs
WITH 
dept_stats AS (
    SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
),
review_stats AS (
    SELECT e.dept_id, AVG(pr.score) AS avg_score
    FROM performance_reviews pr
    JOIN employees e ON pr.employee_id = e.employee_id
    GROUP BY e.dept_id
)
SELECT 
    d.dept_name,
    ds.emp_count,
    ds.avg_salary,
    rs.avg_score
FROM departments d
LEFT JOIN dept_stats ds ON d.dept_id = ds.dept_id
LEFT JOIN review_stats rs ON d.dept_id = rs.dept_id;

-- 4.4 Table Subquery with GROUP BY
-- Find departments where employee count > 2
SELECT dept_name, emp_count
FROM (
    SELECT d.dept_name, COUNT(e.employee_id) AS emp_count
    FROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.dept_name
) AS dept_counts
WHERE emp_count > 2;

-- 4.5 Nested Table Subqueries
-- Find top performing department by average review score
SELECT dept_name, avg_score
FROM (
    SELECT d.dept_name, AVG(pr.score) AS avg_score
    FROM departments d
    JOIN employees e ON d.dept_id = e.dept_id
    JOIN performance_reviews pr ON e.employee_id = pr.employee_id
    GROUP BY d.dept_name
) AS dept_reviews
WHERE avg_score = (
    SELECT MAX(avg_score)
    FROM (
        SELECT AVG(pr.score) AS avg_score
        FROM departments d
        JOIN employees e ON d.dept_id = e.dept_id
        JOIN performance_reviews pr ON e.employee_id = pr.employee_id
        GROUP BY d.dept_name
    ) AS all_scores
);


-- =========================================================
-- LEVEL 5: CORRELATED SUBQUERIES
-- =========================================================

-- 5.1 What Makes a Subquery Correlated?
-- References columns from the outer query
-- Executes once for each row in outer query

-- 5.2 Correlated Subquery in WHERE Clause (from your code)
-- Employees who earn more than their department average
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id  -- Correlation to outer query
);

-- 5.3 Correlated Subquery in SELECT Clause
-- Add department average salary to each row
SELECT 
    e1.first_name,
    e1.last_name,
    e1.salary,
    (SELECT AVG(e2.salary)
     FROM employees e2
     WHERE e2.dept_id = e1.dept_id) AS dept_avg
FROM employees e1;

-- 5.4 Correlated Subquery with EXISTS (from your code)
-- Employees who have sales records
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM sales s
    WHERE s.employee_id = e.employee_id
);

-- Employees with at least one performance review
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);

-- 5.5 Correlated Subquery with NOT EXISTS (from your code)
-- Departments with no employees
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- Employees with no performance reviews
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);

-- 5.6 Correlated Subquery Performance
-- Can be slow on large tables
-- Each row triggers a subquery execution
-- Consider JOIN or window functions as alternatives

-- Example: Inefficient on large dataset
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- More efficient alternative with window function
SELECT first_name, last_name, salary, dept_id
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg
    FROM employees
) AS emp_with_avg
WHERE salary > dept_avg;

-- 5.7 Correlated vs Non-Correlated Comparison
-- Non-correlated: Subquery runs once
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);  -- One execution

-- Correlated: Subquery runs per row
SELECT * FROM employees e1
WHERE salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id);  -- Multiple executions


-- =========================================================
-- LEVEL 6: EXISTS & NOT EXISTS SUBQUERIES
-- =========================================================

-- 6.1 Basic EXISTS Syntax
-- Returns TRUE if subquery returns at least one row
SELECT first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1  -- Can be SELECT 1, SELECT *, SELECT NULL
    FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);

-- 6.2 EXISTS with Correlated Subquery (from your code)
-- Employees with above-average performance in their department
SELECT e.first_name, e.last_name, p.score
FROM employees e
JOIN performance_reviews p ON e.employee_id = p.employee_id
WHERE p.score > (
    SELECT AVG(p2.score)
    FROM performance_reviews p2
    JOIN employees e2 ON p2.employee_id = e2.employee_id
    WHERE e2.dept_id = e.dept_id
);

-- Find employees who have at least one review with score 5
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
    AND pr.score = 5
);

-- 6.3 NOT EXISTS for Finding Missing Rows (from your code)
-- Departments with no employees
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- Products never ordered (from your products table)
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_details od
    WHERE od.product_id = p.product_id
);

-- 6.4 EXISTS vs IN Performance
-- EXISTS better for large datasets, stops at first match
-- IN evaluates all results before comparing

-- EXISTS (usually faster for large subqueries)
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.employee_id = e.employee_id);

-- IN (can be slower for large subqueries)
SELECT * FROM employees e
WHERE e.employee_id IN (SELECT employee_id FROM orders);

-- 6.5 EXISTS vs JOIN Comparison
-- EXISTS (doesn't produce duplicates)
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.employee_id = e.employee_id);

-- JOIN (may produce duplicates, needs DISTINCT)
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id;

-- 6.6 Double NOT EXISTS (Division in SQL)
-- Find employees who have handled all product categories
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    -- Select categories that this employee hasn't handled
    SELECT DISTINCT p.category
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1
        FROM orders o
        JOIN order_details od ON o.order_id = od.order_id
        WHERE o.employee_id = e.employee_id
        AND od.product_id = p.product_id
    )
);


-- =========================================================
-- LEVEL 7: IN & NOT IN SUBQUERIES
-- =========================================================

-- 7.1 Basic IN Subquery
-- Find employees in specific departments
SELECT first_name, last_name, dept_id
FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM departments
    WHERE dept_name IN ('Sales', 'Marketing')
);

-- 7.2 NOT IN Subquery
-- Find employees not in Sales or Marketing
SELECT first_name, last_name, dept_id
FROM employees
WHERE dept_id NOT IN (
    SELECT dept_id
    FROM departments
    WHERE dept_name IN ('Sales', 'Marketing')
);

-- 7.3 IN with Multiple Columns
-- Find employees with same salary and department as top performers
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) IN (
    SELECT MAX(salary), dept_id
    FROM employees
    GROUP BY dept_id
);

-- 7.4 IN with Subquery vs VALUES List
-- Subquery (dynamic)
SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 200000);

-- VALUES list (static)
SELECT * FROM employees
WHERE dept_id IN (1, 3, 5);

-- 7.5 NULL Handling in IN/NOT IN (CRITICAL!)
-- WARNING: NOT IN with NULL returns no rows!
-- Example of the problem
CREATE TABLE test (id INT);
INSERT INTO test VALUES (1), (2), (NULL);

-- This query returns NOTHING because NULL comparison is unknown
SELECT * FROM employees
WHERE employee_id NOT IN (SELECT id FROM test);

-- Safe way: Filter out NULLs
SELECT * FROM employees
WHERE employee_id NOT IN (
    SELECT id FROM test WHERE id IS NOT NULL
);

-- Better: Use NOT EXISTS instead
SELECT * FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM test t WHERE t.id = e.employee_id
);

-- 7.6 IN vs EXISTS vs JOIN
-- IN: Good for small subquery results
SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 500000);

-- EXISTS: Good for large subquery results
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM departments d WHERE d.dept_id = e.dept_id AND d.budget > 500000);

-- JOIN: Good when you need columns from both tables
SELECT e.*, d.budget
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.budget > 500000;


-- =========================================================
-- LEVEL 8: ANY, SOME, ALL SUBQUERIES
-- =========================================================

-- 8.1 ANY / SOME Operator (identical)
-- Returns TRUE if ANY comparison is TRUE
-- Find employees earning more than ANY employee in department 1
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE dept_id = 1
);
-- Equivalent to: salary > MIN(salary of dept 1)

-- 8.2 ALL Operator
-- Returns TRUE if ALL comparisons are TRUE
-- Find employees earning more than ALL employees in department 1
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE dept_id = 1
);
-- Equivalent to: salary > MAX(salary of dept 1)

-- 8.3 Comparison with ANY/ALL
-- = ANY (equivalent to IN)
SELECT first_name, last_name
FROM employees
WHERE dept_id = ANY (SELECT dept_id FROM departments WHERE budget > 200000);
-- Same as: dept_id IN (SELECT dept_id FROM departments WHERE budget > 200000)

-- > ANY (greater than at least one)
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE dept_id = 2);

-- > ALL (greater than all)
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 2);

-- 8.4 ANY vs IN
-- These are equivalent
SELECT * FROM employees WHERE dept_id = ANY (SELECT dept_id FROM departments);
SELECT * FROM employees WHERE dept_id IN (SELECT dept_id FROM departments);

-- 8.5 ALL vs MAX/MIN
-- These are equivalent
SELECT * FROM employees WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 1);
SELECT * FROM employees WHERE salary > (SELECT MAX(salary) FROM employees WHERE dept_id = 1);

-- These are equivalent
SELECT * FROM employees WHERE salary < ANY (SELECT salary FROM employees WHERE dept_id = 1);
SELECT * FROM employees WHERE salary < (SELECT MAX(salary) FROM employees WHERE dept_id = 1);

-- 8.6 Practical ANY/ALL Examples
-- Find employees earning above department average (using ANY)
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE e1.salary > ANY (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- Find employees who have better reviews than ALL of their department
SELECT e.first_name, e.last_name, pr.score
FROM employees e
JOIN performance_reviews pr ON e.employee_id = pr.employee_id
WHERE pr.score > ALL (
    SELECT pr2.score
    FROM performance_reviews pr2
    JOIN employees e2 ON pr2.employee_id = e2.employee_id
    WHERE e2.dept_id = e.dept_id
    AND pr2.review_date = pr.review_date  -- Same review period
);

-- =========================================================
-- LEVEL 9: SUBQUERIES IN DML
-- =========================================================

-- 9.1 Subquery in INSERT
-- Insert top performers into a new table
CREATE TABLE top_performers AS
SELECT * FROM employees WHERE 1=0;  -- Create empty table

INSERT INTO top_performers (employee_id, first_name, last_name, salary)
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Insert with subquery in VALUES
INSERT INTO performance_reviews (employee_id, review_date, score, reviewer_id)
VALUES (
    (SELECT employee_id FROM employees WHERE first_name = 'John'),
    CURRENT_DATE,
    5,
    (SELECT employee_id FROM employees WHERE first_name = 'David' AND is_manager = TRUE)
);

-- 9.2 Subquery in UPDATE
-- Give bonus to employees with above-average performance
UPDATE employees
SET salary = salary * 1.1
WHERE employee_id IN (
    SELECT pr.employee_id
    FROM performance_reviews pr
    GROUP BY pr.employee_id
    HAVING AVG(pr.score) > (SELECT AVG(score) FROM performance_reviews)
);

-- Correlated update: Set manager_id based on region
UPDATE employees e
SET manager_id = (
    SELECT sr.manager_id
    FROM sales_regions sr
    WHERE sr.region_id = e.region_id
)
WHERE EXISTS (
    SELECT 1 FROM sales_regions sr WHERE sr.region_id = e.region_id
);

-- 9.3 Subquery in DELETE
-- Delete old performance reviews (keeping only latest per employee)
DELETE FROM performance_reviews
WHERE review_id NOT IN (
    SELECT MAX(review_id)
    FROM performance_reviews
    GROUP BY employee_id
);

-- Delete employees with no sales
DELETE FROM employees
WHERE NOT EXISTS (
    SELECT 1 FROM sales s WHERE s.employee_id = employees.employee_id
);

-- 9.4 Subquery with MERGE/UPSERT
-- PostgreSQL UPSERT with subquery
INSERT INTO employee_summary (employee_id, total_sales, avg_review)
SELECT 
    e.employee_id,
    COALESCE(s.total, 0),
    COALESCE(r.avg_score, 0)
FROM employees e
LEFT JOIN (
    SELECT employee_id, SUM(amount) AS total
    FROM sales
    GROUP BY employee_id
) s ON e.employee_id = s.employee_id
LEFT JOIN (
    SELECT employee_id, AVG(score) AS avg_score
    FROM performance_reviews
    GROUP BY employee_id
) r ON e.employee_id = r.employee_id
ON CONFLICT (employee_id) DO UPDATE
SET total_sales = EXCLUDED.total_sales,
    avg_review = EXCLUDED.avg_review;

-- 9.5 Correlated Updates
-- Update each employee's department average (denormalization)
ALTER TABLE employees ADD COLUMN dept_avg_salary DECIMAL(10,2);

UPDATE employees e
SET dept_avg_salary = (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e.dept_id
);


-- =========================================================
-- LEVEL 10: ADVANCED SUBQUERY PATTERNS
-- =========================================================

-- 10.1 Subquery with JOINs
-- Employees with their latest review score
SELECT e.first_name, e.last_name, latest.score
FROM employees e
JOIN (
    SELECT DISTINCT ON (employee_id) employee_id, score, review_date
    FROM performance_reviews
    ORDER BY employee_id, review_date DESC
) AS latest ON e.employee_id = latest.employee_id;

-- 10.2 Nested Subqueries (Subquery in Subquery)
-- Find employees earning more than the average salary of top-performing departments
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id IN (
        SELECT dept_id
        FROM (
            SELECT e.dept_id, AVG(pr.score) AS avg_score
            FROM employees e
            JOIN performance_reviews pr ON e.employee_id = pr.employee_id
            GROUP BY e.dept_id
            HAVING AVG(pr.score) > 4
        ) AS top_depts
    )
);

-- 10.3 Subquery with Window Functions
-- Rank employees within department using subquery
SELECT first_name, last_name, salary, dept_id,
    (
        SELECT COUNT(*) + 1
        FROM employees e2
        WHERE e2.dept_id = e1.dept_id
        AND e2.salary > e1.salary
    ) AS rank_in_dept
FROM employees e1
ORDER BY dept_id, rank_in_dept;

-- 10.4 Subquery with CASE Expressions
-- Categorize employees based on salary compared to department average
SELECT 
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id) * 1.2
            THEN 'Above Average'
        WHEN salary < (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id) * 0.8
            THEN 'Below Average'
        ELSE 'Average'
    END AS salary_category
FROM employees e1;

-- 10.5 Subquery with GROUP BY and HAVING
-- Find departments where all employees have score > 3
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    JOIN performance_reviews pr ON e.employee_id = pr.employee_id
    WHERE e.dept_id = d.dept_id
    AND pr.score <= 3
)
AND EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);

-- 10.6 Subquery with LIMIT/TOP
-- Find the second highest salary in each department
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE e1.salary = (
    SELECT DISTINCT e2.salary
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
    ORDER BY e2.salary DESC
    LIMIT 1 OFFSET 1
);

-- 10.7 Lateral Subqueries (LATERAL JOIN)
-- For each employee, get their best review
SELECT e.first_name, e.last_name, best_review.score, best_review.review_date
FROM employees e
CROSS JOIN LATERAL (
    SELECT score, review_date
    FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
    ORDER BY pr.score DESC
    LIMIT 1
) AS best_review;


-- =========================================================
-- LEVEL 11: COMMON SUBQUERY SCENARIOS
-- =========================================================

-- 11.1 Find Above Average Records (from your code)
-- Employees earning above company average
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Employees earning above department average (correlated)
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- 11.2 Find Top N Per Group
-- Top 2 highest paid employees per department
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE (
    SELECT COUNT(*)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
    AND e2.salary > e1.salary
) < 2
ORDER BY e1.dept_id, e1.salary DESC;

-- 11.3 Find Duplicate Records
-- Find duplicate emails (if email column exists)
SELECT email, COUNT(*)
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;

-- Find duplicate performance reviews (same employee, same date)
SELECT employee_id, review_date, COUNT(*)
FROM performance_reviews
GROUP BY employee_id, review_date
HAVING COUNT(*) > 1;

-- 11.4 Find Missing Records (from your code)
-- Departments with no employees
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- Employees with no performance reviews
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);

-- 11.5 Compare with Previous/Next Record
-- Find salary increase between reviews
SELECT 
    employee_id,
    review_date,
    score,
    LAG(score) OVER (PARTITION BY employee_id ORDER BY review_date) AS previous_score,
    score - LAG(score) OVER (PARTITION BY employee_id ORDER BY review_date) AS improvement
FROM performance_reviews;

-- Using subquery (alternative for older MySQL)
SELECT 
    pr1.employee_id,
    pr1.review_date,
    pr1.score,
    (
        SELECT pr2.score
        FROM performance_reviews pr2
        WHERE pr2.employee_id = pr1.employee_id
        AND pr2.review_date < pr1.review_date
        ORDER BY pr2.review_date DESC
        LIMIT 1
    ) AS previous_score
FROM performance_reviews pr1;

-- 11.6 Running Totals with Subquery
-- Running total of sales per employee
SELECT 
    s1.employee_id,
    s1.sale_date,
    s1.amount,
    (
        SELECT SUM(s2.amount)
        FROM sales s2
        WHERE s2.employee_id = s1.employee_id
        AND s2.sale_date <= s1.sale_date
    ) AS running_total
FROM sales s1
ORDER BY s1.employee_id, s1.sale_date;

-- 11.7 Hierarchical Queries with Subqueries
-- Find all subordinates of manager 5 (from your data)
SELECT employee_id, first_name, last_name, manager_id
FROM employees e
WHERE manager_id = 5
   OR manager_id IN (
       SELECT employee_id
       FROM employees
       WHERE manager_id = 5
   );


-- =========================================================
-- LEVEL 12: PERFORMANCE & OPTIMIZATION
-- =========================================================

-- 12.1 Subquery vs JOIN Performance
-- Compare these approaches

-- Subquery approach
SELECT first_name, last_name
FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 500000);

-- JOIN approach
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.budget > 500000;

-- Check execution plans
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 500000);

-- 12.2 Subquery vs CTE Performance
-- CTE may be optimized better in some databases
WITH high_budget_depts AS (
    SELECT dept_id FROM departments WHERE budget > 500000
)
SELECT first_name, last_name
FROM employees
WHERE dept_id IN (SELECT dept_id FROM high_budget_depts);

-- 12.3 Correlated Subquery Optimization
-- Instead of correlated subquery, use window function
-- SLOW (correlated)
SELECT e1.first_name, e1.salary, e1.dept_id
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- FAST (window function)
SELECT first_name, salary, dept_id
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg
    FROM employees
) AS emp_with_avg
WHERE salary > dept_avg;

-- 12.4 EXISTS vs IN Performance Guidelines
-- EXISTS: Better when subquery returns many rows
SELECT * FROM employees e
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.employee_id = e.employee_id);

-- IN: Better when subquery returns few rows
SELECT * FROM employees
WHERE dept_id IN (1, 2, 3);

-- IN with subquery that returns many rows can be slow
-- EXISTS with subquery that returns few rows may be overkill

-- 12.5 Subquery Flattening
-- Some databases automatically convert subqueries to joins
-- Check with EXPLAIN
EXPLAIN SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 500000);

-- 12.6 Materialized Subqueries
-- For repeated use, materialize subquery results
CREATE MATERIALIZED VIEW dept_stats AS
SELECT dept_id, AVG(salary) AS avg_salary, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id;

-- Then query the materialized view
SELECT e.first_name, e.salary, ds.avg_salary
FROM employees e
JOIN dept_stats ds ON e.dept_id = ds.dept_id
WHERE e.salary > ds.avg_salary;

-- 12.7 EXPLAIN for Subqueries
-- Analyze subquery performance
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);


-- =========================================================
-- LEVEL 13: PITFALLS & COMMON ERRORS
-- =========================================================

-- 13.1 Subquery Returns Multiple Rows (Scalar Error)
-- ERROR: Subquery must return only one row
-- WRONG:
SELECT first_name, last_name
FROM employees
WHERE salary = (SELECT salary FROM employees WHERE dept_id = 1);
-- Multiple employees in dept 1, so multiple salaries returned

-- CORRECT: Use IN or aggregate
SELECT first_name, last_name
FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE dept_id = 1);

-- OR use aggregate
SELECT first_name, last_name
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees WHERE dept_id = 1);

-- 13.2 NULL in NOT IN Subquery (Critical!)
-- This query returns NO rows if subquery contains NULL
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM performance_reviews WHERE score < 3
);
-- If any employee has NULL score, NOT IN returns empty set

-- SAFE: Filter out NULLs
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM performance_reviews WHERE score < 3 AND employee_id IS NOT NULL
);

-- BEST: Use NOT EXISTS
SELECT first_name, last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id AND pr.score < 3
);

-- 13.3 Correlated Subquery Without Alias
-- ERROR: Ambiguous column reference
-- WRONG:
SELECT first_name, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE dept_id = dept_id);
-- Which dept_id? Need alias!

-- CORRECT:
SELECT e1.first_name, e1.last_name
FROM employees e1
WHERE e1.salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id);

-- 13.4 Performance with Large Result Sets
-- SLOW: Subquery returns millions of rows
SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM large_table);

-- BETTER: Use EXISTS or JOIN
SELECT e.* FROM employees e
WHERE EXISTS (SELECT 1 FROM large_table lt WHERE lt.dept_id = e.dept_id);

-- 13.5 Subquery in SELECT Causing N+1 Problem
-- SLOW: Subquery executes for each row
SELECT 
    first_name,
    last_name,
    (SELECT AVG(score) FROM performance_reviews WHERE employee_id = e.employee_id) AS avg_score
FROM employees e;
-- Runs N subqueries for N employees

-- FASTER: Use JOIN with GROUP BY
SELECT e.first_name, e.last_name, AVG(pr.score) AS avg_score
FROM employees e
LEFT JOIN performance_reviews pr ON e.employee_id = pr.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;

-- 13.6 Forgetting to Alias Derived Tables
-- ERROR: Every derived table must have an alias
-- WRONG:
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
);  -- Missing alias!

-- CORRECT:
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
) AS dept_avg;  -- Added alias

-- 13.7 Ambiguous Column References
-- ERROR: Column name exists in multiple tables
-- WRONG:
SELECT employee_id, first_name, last_name, dept_name
FROM employees
JOIN departments ON employees.dept_id = departments.dept_id;
-- employee_id might be ambiguous if both tables have it

-- CORRECT: Use table aliases
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;


-- =========================================================
-- SUBQUERIES QUICK REFERENCE CARD
-- =========================================================

-- === TYPES OF SUBQUERIES ===
-- Scalar: Returns 1 value (1 row, 1 column)
SELECT (SELECT AVG(salary) FROM employees) AS company_avg;

-- Row: Returns 1 row, multiple columns
SELECT * FROM employees WHERE (salary, dept_id) = (SELECT MAX(salary), 1 FROM employees);

-- Table: Returns multiple rows, multiple columns
SELECT * FROM (SELECT * FROM employees WHERE salary > 50000) AS high_earners;

-- Correlated: References outer query
SELECT * FROM employees e1 WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id);

-- === OPERATORS ===
WHERE column IN (SELECT ...)           -- Value in set
WHERE column NOT IN (SELECT ...)       -- Value not in set (careful with NULL)
WHERE EXISTS (SELECT 1 ...)            -- At least one row exists
WHERE NOT EXISTS (SELECT 1 ...)        -- No rows exist
WHERE column > ANY (SELECT ...)        -- Greater than at least one
WHERE column > ALL (SELECT ...)        -- Greater than all
WHERE column = ANY (SELECT ...)        -- Same as IN
WHERE column = SOME (SELECT ...)       -- Same as ANY

-- === WHERE SUBQUERIES CAN GO ===
SELECT (SELECT ...) FROM ...            -- SELECT clause
SELECT * FROM (SELECT ...) AS alias    -- FROM clause (derived table)
WHERE column OPERATOR (SELECT ...)      -- WHERE clause
HAVING column OPERATOR (SELECT ...)     -- HAVING clause
ORDER BY (SELECT ...)                   -- ORDER BY clause

-- === COMMON PATTERNS ===
-- Above average
WHERE salary > (SELECT AVG(salary) FROM employees)

-- Missing records
WHERE NOT EXISTS (SELECT 1 FROM related WHERE related.id = main.id)

-- Top N per group (correlated count)
WHERE (SELECT COUNT(*) FROM table t2 WHERE t2.group_id = t1.group_id AND t2.value > t1.value) < N

-- Running total
(SELECT SUM(amount) FROM sales s2 WHERE s2.date <= s1.date AND s2.customer_id = s1.customer_id)

-- === PERFORMANCE TIPS ===
-- EXISTS > IN for large subqueries
-- JOIN > correlated subquery when possible
-- Window functions > correlated subqueries for aggregations
-- Avoid NOT IN with NULLs (use NOT EXISTS)
-- Always alias derived tables
-- Use DISTINCT in subqueries only when needed

-- === WARNING SIGNS ===
-- Subquery in SELECT on large tables (N+1 problem)
-- NOT IN subquery that might return NULL
-- Correlated subquery without proper indexing
-- Deeply nested subqueries (consider CTEs)



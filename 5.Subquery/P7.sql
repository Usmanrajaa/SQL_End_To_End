-- ===================================================================
-- SUBQUERIES: COMPLETE TUTORIAL – QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- Covers: Fundamentals, Scalar, Row, Table, Correlated, EXISTS,
-- IN, ANY/ALL, DML subqueries, Advanced Patterns, Performance.
-- ===================================================================

-- ===================================================================
-- LEVEL 1: SUBQUERY FUNDAMENTALS
-- ===================================================================

-- Q1: What is a subquery? Where can it be used?
-- A: A query nested inside another query. It can be used in SELECT, FROM, WHERE, HAVING,
--    ORDER BY, INSERT, UPDATE, DELETE, JOIN conditions, and WITH clause.

-- Q2: Write a non-correlated subquery that finds employees earning above the company average salary.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q3: Write a correlated subquery that finds employees earning above their department average.
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- ===================================================================
-- LEVEL 2: SCALAR SUBQUERIES
-- ===================================================================

-- Q4: Use a scalar subquery in SELECT to add company average salary to each row.
SELECT
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary
FROM employees;

-- Q5: Add department average salary to each row using a correlated scalar subquery.
SELECT
    e1.first_name,
    e1.last_name,
    e1.salary,
    (SELECT AVG(e2.salary) 
     FROM employees e2 
     WHERE e2.dept_id = e1.dept_id) AS dept_avg_salary
FROM employees e1;

-- Q6: Use scalar subquery in HAVING to find departments with average salary above company average.
SELECT 
    d.dept_name,
    AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

-- Q7: Use scalar subquery in ORDER BY to order employees by distance from department average.
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

-- Q8: Calculate employee salary as percentage of total company payroll.
SELECT 
    first_name,
    salary,
    (salary / (SELECT SUM(salary) FROM employees) * 100) AS pct_of_total
FROM employees
ORDER BY pct_of_total DESC;

-- Q9: Handle NULL results in scalar subquery using COALESCE.
SELECT 
    first_name,
    last_name,
    COALESCE((
        SELECT AVG(score)
        FROM performance_reviews pr
        WHERE pr.employee_id = e.employee_id
    ), 0) AS avg_review_score
FROM employees e;

-- ===================================================================
-- LEVEL 3: ROW SUBQUERIES
-- ===================================================================

-- Q10: Use row constructor comparison to find employee with same salary and department as employee 1.
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) = (
    SELECT salary, dept_id
    FROM employees
    WHERE employee_id = 1
);

-- Q11: Use row subquery with IN to find employees with max salary per department.
SELECT first_name, last_name, salary, dept_id
FROM employees
WHERE (salary, dept_id) IN (
    SELECT MAX(salary), dept_id
    FROM employees
    GROUP BY dept_id
);

-- ===================================================================
-- LEVEL 4: TABLE SUBQUERIES (DERIVED TABLES)
-- ===================================================================

-- Q12: Write a derived table in FROM clause to filter departments with average salary > 50000.
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

-- Q13: Use multiple derived tables to join department stats with review stats.
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

-- Q14: Rewrite the above using CTEs (WITH clause) for better readability.
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

-- ===================================================================
-- LEVEL 5: CORRELATED SUBQUERIES
-- ===================================================================

-- Q15: Write a correlated subquery to find employees earning more than their department average.
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

-- Q16: Use correlated subquery with EXISTS to find employees who have sales records.
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM sales s
    WHERE s.employee_id = e.employee_id
);

-- Q17: Use NOT EXISTS to find departments with no employees.
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- Q18: Compare correlated subquery with window function alternative (more efficient).
-- Correlated version:
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id);
-- Window function version (faster):
SELECT first_name, last_name, salary, dept_id
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg
    FROM employees
) AS emp_with_avg
WHERE salary > dept_avg;

-- ===================================================================
-- LEVEL 6: EXISTS & NOT EXISTS SUBQUERIES
-- ===================================================================

-- Q19: Use EXISTS to find employees with at least one performance review score of 5.
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
    AND pr.score = 5
);

-- Q20: Use NOT EXISTS to find products never ordered.
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_details od
    WHERE od.product_id = p.product_id
);

-- Q21: Use double NOT EXISTS (division) to find employees who have handled all product categories.
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

-- ===================================================================
-- LEVEL 7: IN & NOT IN SUBQUERIES
-- ===================================================================

-- Q22: Use IN to find employees in Sales or Marketing departments.
SELECT first_name, last_name, dept_id
FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM departments
    WHERE dept_name IN ('Sales', 'Marketing')
);

-- Q23: Demonstrate the NULL trap with NOT IN – this query may return no rows if subquery contains NULL.
-- SAFE: Filter out NULLs.
SELECT first_name, last_name
FROM employees
WHERE employee_id NOT IN (
    SELECT employee_id FROM performance_reviews WHERE score < 3 AND employee_id IS NOT NULL
);

-- BETTER: Use NOT EXISTS.
SELECT first_name, last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id AND pr.score < 3
);

-- ===================================================================
-- LEVEL 8: ANY, SOME, ALL SUBQUERIES
-- ===================================================================

-- Q24: Use > ANY to find employees earning more than at least one employee in department 1.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE dept_id = 1
);
-- Equivalent to salary > MIN(salary of dept 1)

-- Q25: Use > ALL to find employees earning more than all employees in department 1.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE dept_id = 1
);
-- Equivalent to salary > MAX(salary of dept 1)

-- Q26: Show that = ANY is equivalent to IN.
SELECT first_name, last_name
FROM employees
WHERE dept_id = ANY (SELECT dept_id FROM departments WHERE budget > 200000);
-- Same as: dept_id IN (SELECT dept_id FROM departments WHERE budget > 200000)

-- ===================================================================
-- LEVEL 9: SUBQUERIES IN DML (INSERT, UPDATE, DELETE)
-- ===================================================================

-- Q27: Use subquery in INSERT to populate top_performers table.
CREATE TABLE top_performers AS SELECT * FROM employees WHERE 1=0;
INSERT INTO top_performers (employee_id, first_name, last_name, salary)
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q28: Use subquery in UPDATE to give bonus to employees with above-average performance.
UPDATE employees
SET salary = salary * 1.1
WHERE employee_id IN (
    SELECT pr.employee_id
    FROM performance_reviews pr
    GROUP BY pr.employee_id
    HAVING AVG(pr.score) > (SELECT AVG(score) FROM performance_reviews)
);

-- Q29: Use subquery in DELETE to remove old performance reviews (keep latest per employee).
DELETE FROM performance_reviews
WHERE review_id NOT IN (
    SELECT MAX(review_id)
    FROM performance_reviews
    GROUP BY employee_id
);

-- ===================================================================
-- LEVEL 10: ADVANCED SUBQUERY PATTERNS
-- ===================================================================

-- Q30: Write a nested subquery to find employees earning above average salary of top-performing departments.
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

-- Q31: Use subquery to rank employees within department (without window functions).
SELECT first_name, last_name, salary, dept_id,
    (
        SELECT COUNT(*) + 1
        FROM employees e2
        WHERE e2.dept_id = e1.dept_id
        AND e2.salary > e1.salary
    ) AS rank_in_dept
FROM employees e1
ORDER BY dept_id, rank_in_dept;

-- Q32: Use subquery with CASE to categorize salaries relative to department average.
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

-- Q33: Use LIMIT in subquery to find second highest salary per department.
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE e1.salary = (
    SELECT DISTINCT e2.salary
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
    ORDER BY e2.salary DESC
    LIMIT 1 OFFSET 1
);

-- Q34: Use LATERAL join to get best review for each employee.
SELECT e.first_name, e.last_name, best_review.score, best_review.review_date
FROM employees e
CROSS JOIN LATERAL (
    SELECT score, review_date
    FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
    ORDER BY pr.score DESC
    LIMIT 1
) AS best_review;

-- ===================================================================
-- LEVEL 11: COMMON SUBQUERY SCENARIOS
-- ===================================================================

-- Q35: Find top 2 highest paid employees per department (using correlated count).
SELECT e1.first_name, e1.last_name, e1.salary, e1.dept_id
FROM employees e1
WHERE (
    SELECT COUNT(*)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
    AND e2.salary > e1.salary
) < 2
ORDER BY e1.dept_id, e1.salary DESC;

-- Q36: Find duplicate emails (if email column exists).
SELECT email, COUNT(*)
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;

-- Q37: Find employees with no performance reviews (missing records).
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM performance_reviews pr
    WHERE pr.employee_id = e.employee_id
);

-- Q38: Calculate running total of sales per employee using subquery.
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

-- ===================================================================
-- LEVEL 12: PERFORMANCE & OPTIMIZATION
-- ===================================================================

-- Q39: Compare subquery vs JOIN performance – use EXPLAIN to analyze.
EXPLAIN ANALYZE
SELECT first_name, last_name
FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE budget > 500000);

-- Q40: Use materialized view to cache subquery results for repeated use.
CREATE MATERIALIZED VIEW dept_stats AS
SELECT dept_id, AVG(salary) AS avg_salary, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id;

-- Then query efficiently:
SELECT e.first_name, e.salary, ds.avg_salary
FROM employees e
JOIN dept_stats ds ON e.dept_id = ds.dept_id
WHERE e.salary > ds.avg_salary;

-- ===================================================================
-- LEVEL 13: PITFALLS & COMMON ERRORS
-- ===================================================================

-- Q41: ERROR: Subquery returns multiple rows in scalar context – fix with IN or aggregate.
-- WRONG:
-- SELECT first_name, last_name FROM employees WHERE salary = (SELECT salary FROM employees WHERE dept_id = 1);
-- CORRECT:
SELECT first_name, last_name FROM employees WHERE salary IN (SELECT salary FROM employees WHERE dept_id = 1);

-- Q42: ERROR: Derived tables must have an alias.
-- WRONG:
-- SELECT dept_name, avg_salary FROM (SELECT d.dept_name, AVG(e.salary) AS avg_salary FROM employees e JOIN departments d ON e.dept_id = d.dept_id GROUP BY d.dept_name);
-- CORRECT:
SELECT dept_name, avg_salary
FROM (
    SELECT d.dept_name, AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
) AS dept_avg;

-- Q43: ERROR: Ambiguous column references – always alias tables.
-- WRONG:
-- SELECT employee_id, first_name, last_name, dept_name FROM employees JOIN departments ON employees.dept_id = departments.dept_id;
-- CORRECT:
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- ===================================================================
-- SUBQUERIES QUICK REFERENCE CARD (for review)
-- ===================================================================
-- Types: Scalar, Row, Table, Correlated
-- Operators: IN, NOT IN, EXISTS, NOT EXISTS, ANY, SOME, ALL
-- Placement: SELECT, FROM (derived table), WHERE, HAVING, ORDER BY, DML
-- Performance: EXISTS > IN for large subqueries; window functions > correlated
-- Warnings: NOT IN with NULL dangerous; always alias derived tables
-- ===================================================================
-- END OF SUBQUERIES SCRIPT
-- ===================================================================
-- Simple CTE example

WITH high_earners AS (
    SELECT * FROM employees
    WHERE salary > 70000
)
SELECT * FROM high_earners
ORDER BY salary DESC;

-- Multiple CTEs

WITH dept_stats AS (
    SELECT
        dept_id,
        AVG(salary) AS avg_salary,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY dept_id
),
high_avg_depts AS (
    SELECT dept_id
    FROM dept_stats
    WHERE avg_salary > 60000
)
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.dept_id IN (SELECT dept_id FROM high_avg_depts);


-- Employee hierarchy (manager -> employees)

WITH RECURSIVE emp_hierarchy AS (
-- Base case: top level managers
SELECT
        employee_id,
        first_name,
        last_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

-- Recursive case: employees reporting to managers
SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        eh.level + 1
    FROM employees e
    JOIN emp_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT
    LPAD('', (level-1)*4, ' ') || first_name || ' ' || last_name AS employee,
    level
FROM emp_hierarchy
ORDER BY level, last_name;
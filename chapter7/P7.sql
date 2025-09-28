-- Subquery in 
SELECT (scalar)SELECT
    first_name,
    last_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary
FROM employees;

-- Subquery in 
WHERE SELECT first_name, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


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


-- Employees who earn more than their department average
SELECT e1.first_name, e1.last_name, e1.salary
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id
);

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


-- Employees who have sales records
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM sales s
    WHERE s.employee_id = e.employee_id
);

-- Departments with no employees
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.dept_id = d.dept_id
);




SHOW DATABASES;
USE sql_pract;
SHOW TABLES;
SELECT * FROM departments;
SELECT * FROM projects;
SELECT * FROM employees;

SELECT d.dept_id,d.budget ,p.budget FROM projects p
INNER JOIN departments d
ON p.budget=d.budget;

SELECT p.employee_id,p.budget,e.salary,e.department
FROM employees e
LEFT JOIN projects p
ON p.employee_id=e.employee_id;

SELECT p.employee_id,p.budget,e.salary,e.department
FROM employees e
RIGHT JOIN projects p
ON p.employee_id=e.employee_id;

SELECT p.employee_id,p.budget,e.salary,e.department
FROM employees e
LEFT JOIN projects p
ON p.employee_id=e.employee_id
UNION
SELECT p.employee_id,p.budget,e.salary,e.department
FROM employees e
RIGHT JOIN projects p
ON p.employee_id=e.employee_id;

SELECT p.employee_id,p.budget,e.salary,e.department
FROM employees e
CROSS JOIN projects p
ON p.employee_id=e.employee_id;

SELECT p.employee_id,p.budget,d.salary,d.department
FROM departments d
CROSS JOIN projects p
ON p.employee_id=e.employee_id;

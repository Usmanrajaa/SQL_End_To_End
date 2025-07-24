USE sql_pract;
SELECT * FROM employees;

SELECT first_name ,department,
CASE department
WHEN department="Sales" THEN "TEAM-A"
WHEN department="Marketing" THEN "TEAM-B"
WHEN department="HR" THEN "TEAM-C"
WHEN department="IT" THEN "TEAM-D"
END AS department_label
FROM employees;

ALTER TABLE employees
ADD COLUMN new_salary INT,
ADD COLUMN department_label VARCHAR(50);
ALTER TABLE employees
ADD COLUMN new_salary INT,
ADD COLUMN department_label VARCHAR(50);

UPDATE employees
SET 
  new_salary = salary * (
    CASE
      WHEN department = 'Sales' THEN 1.15
      WHEN department = 'Marketing' THEN 1.20
      WHEN department = 'IT' THEN 1.25
      WHEN department = 'HR' THEN 1.30
    END
  ),
  department_label = (
    CASE
      WHEN department = 'Sales' THEN 'TEAM-A'
      WHEN department = 'Marketing' THEN 'TEAM-B'
      WHEN department = 'HR' THEN 'TEAM-C'
      WHEN department = 'IT' THEN 'TEAM-D'
    END
  );





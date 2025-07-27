USE sql_pract;
SHOW TABLES;
DROP TABLE managers;
SELECT * FROM employees;

-- ALTER TABLE employees
-- DROP COLUMN middle_name;
-- DROP COLUMN department_label;

-- ALTER TABLE employees
-- ADD COLUMN email VARCHAR(50);
-- ADD COLUMN notes VARCHAR(50);
-- ADD COLUMN middle_name VARCHAR(50);

-- UPDATE employees
-- SET 
-- email="abc@gmail.com",
-- notes="it's my personal email",
-- middle_name="xyz"

SELECT first_name, last_name, salary,
    CASE
        WHEN salary < 50000 THEN salary*1.15
        WHEN salary BETWEEN 50000 AND 70000 THEN salary*1.20
        ELSE 'High'
    END AS salary_level
FROM employees;

UPDATE employees
SET 
incremented_salary=CASE
WHEN salary < 50000 THEN salary*1.15
WHEN salary BETWEEN 50000 AND 70000 THEN salary*1.20
ELSE salary*1.50
END;

UPDATE employees
SET
email=CASE
WHEN employee_id=3 THEN "xyz@gmail.com"
WHEN employee_id=4 THEN "XYC@gmail.com"
END,
notes=CASE
WHEN employee_id=3 THEN "first mail "
WHEN employee_id=4 THEN "personal mail"
END ,
middle_name=CASE
WHEN employee_id=3 THEN "john"
WHEN employee_id=4 THEN "rodrigues"
END;

SET SQL_SAFE_UPDATES=0;

-- SELECT first_name,last_name,salary,department,;

ALTER TABLE employees
ADD COLUMN teams VARCHAR(50);

-- method1
UPDATE employees
SET
teams=CASE
WHEN department="Sales" THEN "TEAM-A"
WHEN department="Marketing" THEN "TEAM-B"
WHEN department="IT" THEN "TEAM-C"
WHEN department="HR" THEN "TEAM-D"
END ;

-- method2
UPDATE employees
SET
teams=CASE department
WHEN "Sales" THEN "TEAM-A"
WHEN "Marketing" THEN "TEAM-B"
WHEN "IT" THEN "TEAM-C"
WHEN "HR" THEN "TEAM-D"
END ;

ALTER TABLE employees
ADD COLUMN incremented_salary INT;

-- inplace replcacement
UPDATE employees
SET
salary=salary*(
CASE 
WHEN salary < 50000 THEN 1.15
WHEN salary BETWEEN 50000 AND 70000 THEN 1.20
ELSE 1.50
END
);
SELECT * FROM employees;

SELECT * FROM employees
ORDER BY 
CASE 
WHEN department='Sales' THEN 1
WHEN department='Marketing' THEN 2
WHEN department='HR' THEN 3
WHEN department='IT' THEN 4
ELSE 5
END;




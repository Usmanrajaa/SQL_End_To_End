SHOW DATABASES;
USE sql_pract;
SHOW TABLES;
DROP TABLE manager;
SELECT * FROM employees;
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
ALTER TABLE employees ADD COLUMN notes VARCHAR(200);
ALTER TABLE employees ADD COLUMN middle_name VARCHAR(50);

-- alternative way
-- UPDATE employees
-- SET
-- email="abc@gmail.com",
-- notes="it's my personale mail",
-- middle_name="xyz"
-- WHERE employee_id=1;


UPDATE employees 
SET
    email = CASE
        WHEN employee_id = 1 THEN 'john.smith@company.com'
        WHEN employee_id = 2 THEN 'sarah.johnson@company.com'
        WHEN employee_id = 3 THEN 'michael.williams@company.com'
        WHEN employee_id = 4 THEN NULL
        WHEN employee_id = 5 THEN 'd.jones@company.com'
        WHEN employee_id = 6 THEN 'jessica.g@company.com'
        WHEN employee_id = 7 THEN 'daniel.miller@company.com'
        WHEN employee_id = 8 THEN 'lisa.davis@company.com'
        WHEN employee_id = 9 THEN NULL
        WHEN employee_id = 10 THEN 'amanda.martinez@company.com'
    END,
    notes = CASE
        WHEN employee_id = 1 THEN 'Top performer 2022'
        WHEN employee_id = 2 THEN 'Team leader, joined from competitor'
        WHEN employee_id = 3 THEN 'Needs additional training'
        WHEN employee_id = 4 THEN NULL
        WHEN employee_id = 5 THEN 'System architect'
        WHEN employee_id = 6 THEN 'Promoted last year'
        WHEN employee_id = 7 THEN 'Certified in AWS and Azure'
        WHEN employee_id = 8 THEN 'On maternity leave until June'
        WHEN employee_id = 9 THEN 'New hire orientation pending'
        WHEN employee_id = 10 THEN 'Quarterly sales award winner'
    END,
    middle_name = CASE
        WHEN employee_id = 1 THEN 'A.'
        WHEN employee_id = 2 THEN 'L.'
        WHEN employee_id = 3 THEN NULL
        WHEN employee_id = 4 THEN 'C.'
        WHEN employee_id = 5 THEN 'X.'
        WHEN employee_id = 6 THEN NULL
        WHEN employee_id = 7 THEN 'P.'
        WHEN employee_id = 8 THEN 'M.'
        WHEN employee_id = 9 THEN 'T.'
        WHEN employee_id = 10 THEN 'R.'
    END;
    
    SET SQL_SAFE_UPDATES=0;

ALTER TABLE employees ADD COLUMN category VARCHAR(200);

update employees
set 
category=case
WHEN employee_id = 1 THEN 'Teammate'
WHEN employee_id = 2 THEN 'Team leader'
WHEN employee_id = 3 THEN 'Teams'
WHEN employee_id = 4 THEN null
WHEN employee_id = 5 THEN 'System architect for Teams'
WHEN employee_id = 6 THEN 'Promoted last year'
WHEN employee_id = 7 THEN 'Teams'
WHEN employee_id = 8 THEN 'Teammates on  maternity leave until June'
WHEN employee_id = 9 THEN 'New hiring in team orientation pending '
WHEN employee_id = 10 THEN 'Quarterly sales award winner to teams'
end;

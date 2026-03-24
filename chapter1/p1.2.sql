-- =========================================
-- COLUMN + ROW LEVEL FULL PRACTICAL SCRIPT
-- =========================================

USE company_db;

-- -----------------------------------------
-- INITIAL CHECK
-- -----------------------------------------
SELECT * FROM employees;

-- -----------------------------------------
-- SHOW COLUMNS
-- -----------------------------------------
SHOW COLUMNS FROM employees;

-- -----------------------------------------
-- ADD COLUMNS (MULTIPLE WITH CONSTRAINTS)
-- -----------------------------------------
ALTER TABLE employees
ADD COLUMN email VARCHAR(100) UNIQUE,
ADD COLUMN bonus INT DEFAULT 0,
ADD COLUMN phone BIGINT NOT NULL;

-- -----------------------------------------
-- ADD COLUMN AT FIRST POSITION
-- -----------------------------------------
ALTER TABLE employees
ADD COLUMN temp_col1 INT FIRST;

-- -----------------------------------------
-- ADD COLUMN AFTER SPECIFIC COLUMN
-- -----------------------------------------
ALTER TABLE employees
ADD COLUMN temp_col2 VARCHAR(50) AFTER department;

-- -----------------------------------------
-- MODIFY COLUMN
-- -----------------------------------------
ALTER TABLE employees
MODIFY COLUMN salary BIGINT;

-- -----------------------------------------
-- RENAME COLUMN
-- -----------------------------------------
ALTER TABLE employees
RENAME COLUMN first_name TO fname;

-- -----------------------------------------
-- ADD PRIMARY KEY (IF NOT EXISTS DROP FIRST)
-- -----------------------------------------
ALTER TABLE employees
DROP PRIMARY KEY;

ALTER TABLE employees
ADD PRIMARY KEY(employee_id);

-- -----------------------------------------
-- ADD CONSTRAINT (UNIQUE)
-- -----------------------------------------
ALTER TABLE employees
ADD CONSTRAINT unique_phone UNIQUE(phone);

-- -----------------------------------------
-- DROP COLUMN
-- -----------------------------------------
ALTER TABLE employees
DROP COLUMN temp_col1;

-- -----------------------------------------
-- INSERT FULL ROW
-- -----------------------------------------
INSERT INTO employees VALUES
(101, 'Usman', 'Ansari', 'IT', 60000, '2024-01-01', FALSE, 'usman@gmail.com', 5000, 9876543210, 'test');

-- -----------------------------------------
-- INSERT SPECIFIC COLUMNS
-- -----------------------------------------
INSERT INTO employees (employee_id, fname, department, salary, phone)
VALUES (102, 'Ali', 'HR', 45000, 9123456789);

-- -----------------------------------------
-- UPDATE MULTIPLE COLUMNS
-- -----------------------------------------
UPDATE employees
SET salary = 70000,
    department = 'Finance',
    bonus = 8000
WHERE employee_id = 2;

-- -----------------------------------------
-- UPDATE USING CASE (MULTIPLE ROWS)
-- -----------------------------------------
UPDATE employees
SET 
salary = CASE
    WHEN department = 'IT' THEN salary + 10000
    WHEN department = 'Sales' THEN salary + 5000
    ELSE salary
END,
bonus = CASE
    WHEN salary > 70000 THEN 10000
    ELSE 5000
END,
is_manager = CASE
    WHEN salary > 80000 THEN TRUE
    ELSE FALSE
END;

-- -----------------------------------------
-- DELETE SPECIFIC ROW
-- -----------------------------------------
DELETE FROM employees
WHERE employee_id = 102;

-- -----------------------------------------
-- DELETE WITH CONDITION
-- -----------------------------------------
DELETE FROM employees
WHERE salary < 50000;

-- -----------------------------------------
-- FINAL CHECK
-- -----------------------------------------
SELECT * FROM employees;
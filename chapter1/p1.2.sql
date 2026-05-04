-- ===================================================================
-- COLUMN + ROW LEVEL OPERATIONS: QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q1: Switch to the company_db database.
USE company_db;

-- Q2: View all data from the employees table.
SELECT * FROM employees;

-- ===================================================================
-- SHOW COLUMNS
-- ===================================================================

-- Q3: How do you display the column definitions (data types, constraints, etc.) of the employees table?
SHOW COLUMNS FROM employees;

-- ===================================================================
-- ADD COLUMNS (MULTIPLE WITH CONSTRAINTS)
-- ===================================================================

-- Q4: Write an ALTER TABLE statement to add three columns to the employees table at once:
--     email (VARCHAR(100), UNIQUE), bonus (INT, DEFAULT 0), phone (BIGINT, NOT NULL).
ALTER TABLE employees
ADD COLUMN email VARCHAR(100) UNIQUE,
ADD COLUMN bonus INT DEFAULT 0,
ADD COLUMN phone BIGINT NOT NULL;

-- ===================================================================
-- ADD COLUMN AT FIRST POSITION
-- ===================================================================

-- Q5: Add a temporary column called temp_col1 of type INT as the first column in the employees table.
ALTER TABLE employees
ADD COLUMN temp_col1 INT FIRST;

-- ===================================================================
-- ADD COLUMN AFTER SPECIFIC COLUMN
-- ===================================================================

-- Q6: Add a temporary column called temp_col2 of type VARCHAR(50) immediately after the department column.
ALTER TABLE employees
ADD COLUMN temp_col2 VARCHAR(50) AFTER department;

-- ===================================================================
-- MODIFY COLUMN
-- ===================================================================

-- Q7: Change the data type of the salary column from INT to BIGINT.
ALTER TABLE employees
MODIFY COLUMN salary BIGINT;

-- ===================================================================
-- RENAME COLUMN
-- ===================================================================

-- Q8: Rename the column first_name to fname.
ALTER TABLE employees
RENAME COLUMN first_name TO fname;

-- ===================================================================
-- ADD PRIMARY KEY (IF NOT EXISTS, DROP FIRST)
-- ===================================================================

-- Q9: Safely add a primary key on employee_id. First drop any existing primary key, then add it.
ALTER TABLE employees
DROP PRIMARY KEY;

ALTER TABLE employees
ADD PRIMARY KEY(employee_id);

-- ===================================================================
-- ADD CONSTRAINT (UNIQUE)
-- ===================================================================

-- Q10: Add a UNIQUE constraint named unique_phone on the phone column.
ALTER TABLE employees
ADD CONSTRAINT unique_phone UNIQUE(phone);

-- ===================================================================
-- DROP COLUMN
-- ===================================================================

-- Q11: Remove the temporary column temp_col1 from the employees table.
ALTER TABLE employees
DROP COLUMN temp_col1;

-- ===================================================================
-- INSERT FULL ROW
-- ===================================================================

-- Q12: Insert a complete row into the employees table with all columns (including the newly added ones). 
--     Values: employee_id=101, fname='Usman', last_name='Ansari', department='IT', salary=60000, 
--     hire_date='2024-01-01', is_manager=FALSE, email='usman@gmail.com', bonus=5000, phone=9876543210, temp_col2='test'.
INSERT INTO employees VALUES
(101, 'Usman', 'Ansari', 'IT', 60000, '2024-01-01', FALSE, 'usman@gmail.com', 5000, 9876543210, 'test');

-- ===================================================================
-- INSERT SPECIFIC COLUMNS
-- ===================================================================

-- Q13: Insert a new employee providing only employee_id, fname, department, salary, and phone. 
--     Values: employee_id=102, fname='Ali', department='HR', salary=45000, phone=9123456789.
INSERT INTO employees (employee_id, fname, department, salary, phone)
VALUES (102, 'Ali', 'HR', 45000, 9123456789);

-- ===================================================================
-- UPDATE MULTIPLE COLUMNS
-- ===================================================================

-- Q14: Update the employee with employee_id = 2, setting salary to 70000, department to 'Finance', and bonus to 8000.
UPDATE employees
SET salary = 70000,
    department = 'Finance',
    bonus = 8000
WHERE employee_id = 2;

-- ===================================================================
-- UPDATE USING CASE (MULTIPLE ROWS)
-- ===================================================================

-- Q15: Perform a conditional update on all employees:
--     - Increase salary: +10000 for IT, +5000 for Sales, else unchanged.
--     - Set bonus: 10000 if salary > 70000 (after the salary update), else 5000.
--     - Set is_manager: TRUE if salary > 80000, else FALSE.
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

-- ===================================================================
-- DELETE SPECIFIC ROW
-- ===================================================================

-- Q16: Delete the employee with employee_id = 102.
DELETE FROM employees
WHERE employee_id = 102;

-- ===================================================================
-- DELETE WITH CONDITION
-- ===================================================================

-- Q17: Delete all employees whose salary is less than 50000.
DELETE FROM employees
WHERE salary < 50000;

-- ===================================================================
-- FINAL CHECK
-- ===================================================================

-- Q18: After all modifications, view the final data in the employees table.
SELECT * FROM employees;


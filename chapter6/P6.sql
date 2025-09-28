-- Simple transactionBEGIN;
INSERT INTO payroll (employee_id, pay_date, amount)
VALUES (1, CURRENT_DATE, 5000.00);
COMMIT;

-- Transaction with error handlingBEGIN;
UPDATE accounts SET balance = balance - 1000 WHERE account_id = 123;
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 456;
-- If any error occurs, the transaction will be rolled backCOMMIT;


-- Transaction with rollbackBEGIN;
DELETE FROM payroll WHERE pay_date < '2023-01-01';
-- Oops, wrong date range!ROLLBACK;

-- Conditional rollbackBEGIN;
INSERT INTO sales_leads (company_name, contact_email)
VALUES ('Acme Corp', 'contact@acme.com');
-- Check for duplicateIF EXISTS (SELECT 1 FROM sales_leads WHERE contact_email = 'contact@acme.com') THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;



-- Transaction 
with savepointsBEGIN;
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (2, CURRENT_DATE, 5500.00);
SAVEPOINT first_insert;
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (3, CURRENT_DATE, 6000.00);
-- Oops, second insert was wrong
ROLLBACK TO SAVEPOINT first_insert;
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (4, CURRENT_DATE, 4800.00);
COMMIT;



-- Set transaction isolation level
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Critical operations here
COMMIT;

-- Read-only transaction
BEGIN;
SET TRANSACTION READ ONLY;
-- Only 
SELECT statements allowedCOMMIT;



-- Basic grants
GRANT 
SELECT ON employees TO hr_team;
GRANT SELECT, INSERT ON sales_leads TO sales_team;
GRANT ALL PRIVILEGES ON payroll TO finance_team;

-- Column-level permissions
GRANT 

SELECT (employee_id, first_name, last_name) ON employees TO sales_team;

-- Schema permissions
GRANT USAGE ON SCHEMA public TO hr_team;

-- Execute permission for functions
GRANT EXECUTE ON FUNCTION calculate_bonus(INT) TO finance_team;



-- Remove specific privileges
REVOKE INSERT ON sales_leads FROM sales_team;

-- Remove all privileges
REVOKE ALL ON payroll FROM finance_team;

-- Column-level revocation
REVOKE SELECT (salary) ON employees FROM hr_team;


-- Create user with specific options
CREATE USER audit_user WITH
    PASSWORD 'audit_pass'
    VALID UNTIL '2024-12-31'
    CONNECTION LIMIT 10;

-- Alter userALTER USER hr_rep WITH
    PASSWORD 'new_secure456'
    VALID UNTIL '2024-06-30';

-- Rename user
ALTER USER sales_person RENAME TO sales_rep;

-- Drop userDROP USER IF EXISTS temp_user;


-- Create role with attributes
CREATE ROLE reporting WITH
    LOGIN
    PASSWORD 'report_pass'
    INHERIT;

-- Grant role to user
GRANT reporting TO hr_rep;

-- Revoke role from user
REVOKE reporting FROM hr_rep;

-- Alter role
ALTER ROLE finance_team WITH NOLOGIN;

-- Drop role
DROP ROLE IF EXISTS temp_role;



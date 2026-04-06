-- =========================================================
-- LEVEL 1: USER MANAGEMENT
-- =========================================================

-- 1.1 CREATE USER (from your code)
-- Basic user creation
CREATE USER finance_manager WITH PASSWORD 'secure123';

-- User with additional options
CREATE USER hr_rep WITH 
    PASSWORD 'secure456'
    VALID UNTIL '2024-12-31'
    CONNECTION LIMIT 5;

-- User with specific role inheritance
CREATE USER sales_person WITH
    PASSWORD 'secure789'
    INHERIT
    CONNECTION LIMIT 10;

-- 1.2 ALTER USER
-- Change password
ALTER USER hr_rep WITH PASSWORD 'new_secure456';

-- Change validity period
ALTER USER hr_rep VALID UNTIL '2025-06-30';

-- Change connection limit
ALTER USER sales_person CONNECTION LIMIT 20;

-- Enable/disable user
ALTER USER hr_rep WITH NOLOGIN;  -- Disable login
ALTER USER hr_rep WITH LOGIN;    -- Enable login

-- 1.3 RENAME USER (from your code)
ALTER USER sales_person RENAME TO sales_rep;

-- 1.4 DROP USER (from your code)
DROP USER IF EXISTS temp_user;

-- Drop user and reassign objects
DROP USER old_employee CASCADE;

-- 1.5 User Attributes & Options
/*
Available attributes:
- PASSWORD: Sets user password
- VALID UNTIL: Account expiration date
- CONNECTION LIMIT: Max concurrent connections
- LOGIN/NOLOGIN: Can user login?
- SUPERUSER/NOSUPERUSER: Admin privileges
- CREATEDB/NOCREATEDB: Can create databases?
- CREATEROLE/NOCREATEROLE: Can create roles?
- INHERIT/NOINHERIT: Inherit role privileges?
- REPLICATION/NOREPLICATION: Replication privileges?
*/

-- Create superuser (only for emergencies)
CREATE USER admin WITH PASSWORD 'admin123' SUPERUSER;

-- 1.6 User Password Management
-- Set password with expiration
CREATE USER temp_employee WITH 
    PASSWORD 'temp123' 
    VALID UNTIL NOW() + INTERVAL '30 days';

-- Force password change on first login
ALTER USER new_user WITH PASSWORD 'changeme' VALID UNTIL '2024-01-01';

-- 1.7 Connection Limits & Time Restrictions
-- Restrict to specific time window (requires additional scripting)
CREATE USER night_worker WITH 
    PASSWORD 'night123'
    CONNECTION LIMIT 1
    VALID UNTIL '2024-12-31';

-- =========================================================
-- LEVEL 2: ROLE MANAGEMENT
-- =========================================================

-- 2.1 CREATE ROLE (from your code)
-- Basic role creation
CREATE ROLE finance_team;
CREATE ROLE hr_team;
CREATE ROLE sales_team;

-- Role with attributes
CREATE ROLE reporting WITH LOGIN PASSWORD 'report_pass';
CREATE ROLE readonly WITH NOLOGIN;
CREATE ROLE app_user WITH LOGIN INHERIT;

-- 2.2 ALTER ROLE
-- Change role attributes
ALTER ROLE finance_team WITH NOLOGIN;
ALTER ROLE hr_team WITH CREATEDB;
ALTER ROLE sales_team WITH CONNECTION LIMIT 50;

-- Rename role
ALTER ROLE reporting RENAME TO reporting_team;

-- 2.3 DROP ROLE
DROP ROLE IF EXISTS temp_role;

-- Drop role and reassign its objects
DROP ROLE old_role CASCADE;

-- 2.4 Role Attributes (from your code)
/*
LOGIN/NOLOGIN: Can the role login directly?
SUPERUSER/NOSUPERUSER: Bypass all permissions
CREATEDB/NOCREATEDB: Can create databases
CREATEROLE/NOCREATEROLE: Can create/manage roles
INHERIT/NOINHERIT: Inherit privileges from parent roles
REPLICATION/NOREPLICATION: Replication privileges
BYPLRFS: Bypass row-level security
*/

-- Example: Reporting role with limited access
CREATE ROLE readonly_reporter WITH 
    LOGIN 
    PASSWORD 'readonly'
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    CONNECTION LIMIT 100;

-- 2.5 Role Inheritance
-- Grant roles to users/other roles (from your code)
GRANT finance_team TO finance_manager;
GRANT hr_team TO hr_rep;
GRANT sales_team TO sales_person;

-- Create role hierarchy
CREATE ROLE manager;
CREATE ROLE employee;
GRANT employee TO manager;  -- Manager inherits employee privileges

-- Check role membership
SELECT rolname, rolcanlogin, rolvaliduntil 
FROM pg_roles 
WHERE rolname IN ('finance_manager', 'finance_team');

-- 2.6 Role vs User (Differences)
/*
In PostgreSQL: Users are roles with LOGIN privilege
- Role: Can have LOGIN or not
- User: Role with LOGIN privilege (conceptually same)

In MySQL:
- User: Login accounts
- Role: Collections of privileges (MySQL 8.0+)
*/

-- 2.7 System Roles vs Custom Roles
-- System roles (built-in)
-- pg_read_all_data, pg_write_all_data, pg_monitor, etc.

-- Grant system role
GRANT pg_read_all_data TO reporting_team;


-- =========================================================
-- LEVEL 3: GRANT PERMISSIONS
-- =========================================================

-- 3.1 Basic GRANT Syntax (from your code)
/*
GRANT {privilege_type | ALL PRIVILEGES} 
ON {object_type} object_name 
TO {role_name | PUBLIC} 
[WITH GRANT OPTION];
*/

-- 3.2 Table-Level Permissions (from your code)
-- Basic table permissions
GRANT SELECT ON employees TO hr_team;
GRANT SELECT, INSERT ON sales_leads TO sales_team;
GRANT ALL PRIVILEGES ON payroll TO finance_team;

-- Grant with GRANT OPTION (allow further granting)
GRANT SELECT ON employees TO hr_manager WITH GRANT OPTION;

-- Grant multiple tables at once
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reporting_team;

-- Grant future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT ON TABLES TO reporting_team;

-- 3.3 Schema-Level Permissions (from your code)
-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO hr_team;

-- Grant all schema privileges
GRANT ALL PRIVILEGES ON SCHEMA public TO finance_team;

-- Create schema with specific owner
CREATE SCHEMA finance AUTHORIZATION finance_manager;

-- 3.4 Database-Level Permissions
-- Grant connect to database
GRANT CONNECT ON DATABASE sql_pract TO hr_team;

-- Grant create on database
GRANT CREATE ON DATABASE sql_pract TO finance_manager;

-- Grant all database privileges
GRANT ALL PRIVILEGES ON DATABASE sql_pract TO admin_role;

-- 3.5 Column-Level Permissions (from your code)
-- Grant access to specific columns only
GRANT SELECT (employee_id, first_name, last_name) ON employees TO sales_team;

-- Grant update on specific columns
GRANT UPDATE (salary, department) ON employees TO hr_manager;

-- Multiple columns
GRANT SELECT (employee_id, first_name, last_name, email) ON employees TO reporting;

-- 3.6 Function/Procedure Permissions (from your code)
-- Grant execute permission
GRANT EXECUTE ON FUNCTION calculate_bonus(INT) TO finance_team;

-- Grant on procedure
GRANT EXECUTE ON PROCEDURE update_salary(INT, DECIMAL) TO hr_manager;

-- Grant on all functions
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO app_role;

-- 3.7 Sequence Permissions
-- Grant usage on sequence
GRANT USAGE ON SEQUENCE employees_employee_id_seq TO hr_team;

-- Grant all sequence privileges
GRANT ALL ON SEQUENCE order_details_order_detail_id_seq TO app_role;

-- 3.8 System Privileges
-- Grant role creation
GRANT CREATEROLE TO user_admin;

-- Grant database creation
GRANT CREATEDB TO db_creator;

-- Grant replication
GRANT REPLICATION TO backup_user;


-- =========================================================
-- LEVEL 4: REVOKE PERMISSIONS
-- =========================================================

-- 4.1 Basic REVOKE Syntax (from your code)
/*
REVOKE {privilege_type | ALL PRIVILEGES}
ON {object_type} object_name
FROM {role_name | PUBLIC}
[CASCADE | RESTRICT];
*/

-- 4.2 Revoke Specific Privileges (from your code)
-- Revoke insert permission
REVOKE INSERT ON sales_leads FROM sales_team;

-- Revoke multiple privileges
REVOKE SELECT, INSERT, UPDATE ON employees FROM temp_user;

-- Revoke with GRANT OPTION only
REVOKE GRANT OPTION FOR SELECT ON employees FROM hr_manager;

-- 4.3 Revoke All Privileges (from your code)
-- Revoke all privileges
REVOKE ALL ON payroll FROM finance_team;

-- Revoke all on schema
REVOKE ALL ON SCHEMA public FROM public;

-- Revoke all on database
REVOKE ALL ON DATABASE sql_pract FROM reporting_role;

-- 4.4 Column-Level Revoke (from your code)
-- Revoke column-specific permission
REVOKE SELECT (salary) ON employees FROM hr_team;

-- Revoke update on column
REVOKE UPDATE (salary) ON employees FROM hr_manager;

-- 4.5 CASCADE vs RESTRICT Options
-- CASCADE: Also revokes privileges granted by this role
REVOKE SELECT ON employees FROM hr_manager CASCADE;

-- RESTRICT: Fails if other privileges depend on it (default)
REVOKE SELECT ON employees FROM hr_manager RESTRICT;

-- 4.6 GRANT OPTION FOR Clause
-- Revoke only the ability to grant, not the privilege itself
REVOKE GRANT OPTION FOR SELECT ON employees FROM hr_manager;

-- Revoke admin option on role membership
REVOKE ADMIN OPTION FOR finance_team FROM finance_manager;


-- =========================================================
-- LEVEL 5: TRANSACTIONS FUNDAMENTALS
-- =========================================================

-- 5.1 What is a Transaction (ACID Properties)
/*
Atomicity: All or nothing - transaction completes fully or not at all
Consistency: Database remains in valid state
Isolation: Concurrent transactions don't interfere
Durability: Committed changes persist even after crash
*/

-- 5.2 BEGIN/START TRANSACTION (from your code)
-- Start transaction (standard)
BEGIN;

-- Start transaction (alternative syntax)
START TRANSACTION;

-- Start with isolation level
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 5.3 COMMIT (from your code)
-- Commit transaction (make changes permanent)
COMMIT;

-- Commit with comment (PostgreSQL)
COMMIT AND CHAIN;  -- Start new transaction after commit

-- 5.4 ROLLBACK (from your code)
-- Rollback transaction (undo all changes)
ROLLBACK;

-- Rollback with savepoint
ROLLBACK TO SAVEPOINT savepoint_name;

-- 5.5 Transaction States
/*
Active: Transaction is running
Partially Committed: After COMMIT, before durability confirmed
Committed: Changes are permanent
Failed: Error occurred, cannot commit
Aborted: Rolled back, changes undone
*/

-- Check current transaction state
SELECT txid_current() AS current_transaction;

-- 5.6 Auto-Commit Mode
-- Check auto-commit (PostgreSQL default is ON)
SHOW AUTOCOMMIT;

-- Disable auto-commit for session (MySQL)
-- SET AUTOCOMMIT = 0;

-- Enable auto-commit
-- SET AUTOCOMMIT = 1;


-- =========================================================
-- LEVEL 6: SAVEPOINTS
-- =========================================================

-- 6.1 Creating Savepoints (from your code)
BEGIN;
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (2, CURRENT_DATE, 5500.00);
SAVEPOINT first_insert;  -- Create savepoint

-- 6.2 Rolling Back to Savepoints (from your code)
-- Oops, second insert was wrong
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (3, CURRENT_DATE, 6000.00);
-- Rollback to savepoint
ROLLBACK TO SAVEPOINT first_insert;

-- Continue with correct insert
INSERT INTO payroll (employee_id, pay_date, amount) VALUES (4, CURRENT_DATE, 4800.00);
COMMIT;

-- 6.3 Releasing Savepoints
-- Release savepoint (removes it)
RELEASE SAVEPOINT first_insert;

-- 6.4 Nested Savepoints
BEGIN;
SAVEPOINT sp1;
    INSERT INTO test VALUES (1);
    SAVEPOINT sp2;
        INSERT INTO test VALUES (2);
        SAVEPOINT sp3;
            INSERT INTO test VALUES (3);
        RELEASE SAVEPOINT sp3;
    ROLLBACK TO SAVEPOINT sp2;
COMMIT;

-- 6.5 Savepoint Use Cases
-- Example: Batch processing with error handling
BEGIN;
SAVEPOINT batch_start;

FOR i IN 1..100 LOOP
    BEGIN
        INSERT INTO large_table VALUES (i);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO SAVEPOINT batch_start;
            -- Log error and continue
    END;
END LOOP;

COMMIT;


-- =========================================================
-- LEVEL 7: TRANSACTION ISOLATION LEVELS
-- =========================================================

-- 7.1 READ UNCOMMITTED (Lowest isolation)
-- Can see uncommitted changes from other transactions (dirty reads)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM payroll;  -- May see uncommitted data
COMMIT;

-- 7.2 READ COMMITTED (PostgreSQL default)
-- Only sees committed data (no dirty reads)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM employees;  -- Only committed data
COMMIT;

-- 7.3 REPEATABLE READ
-- Prevents non-repeatable reads (same query returns same results)
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM products WHERE product_id = 1;
-- Even if another transaction updates, this sees same data
SELECT * FROM products WHERE product_id = 1;  -- Same result
COMMIT;

-- 7.4 SERIALIZABLE (Highest isolation)
-- Complete isolation, prevents phantom reads
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Critical operations that require absolute consistency
SELECT MAX(amount) FROM payroll;
-- Other transactions cannot interfere
COMMIT;

-- 7.5 Setting Isolation Levels
-- For current transaction (from your code)
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Operations here
COMMIT;

-- For entire session (PostgreSQL)
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 7.6 Isolation Phenomena
/*
Dirty Read: Reading uncommitted data
Non-Repeatable Read: Same query returns different results
Phantom Read: New rows appear in range queries
Serialization Anomaly: Concurrent transactions produce inconsistent results
*/

-- Check current isolation level
SHOW TRANSACTION ISOLATION LEVEL;


-- =========================================================
-- LEVEL 8: ADVANCED TRANSACTION PATTERNS
-- =========================================================

-- 8.1 Read-Only Transactions (from your code)
-- Transaction that only reads data
BEGIN;
SET TRANSACTION READ ONLY;
-- Only SELECT statements allowed
SELECT * FROM employees;
SELECT * FROM departments;
-- INSERT, UPDATE, DELETE will fail
COMMIT;

-- 8.2 Read-Write Transactions (Default)
BEGIN;
SET TRANSACTION READ WRITE;
-- Both read and write allowed
INSERT INTO sales_leads VALUES (100, 'New Client', 'client@email.com', NULL, 'New');
COMMIT;

-- 8.3 Deferrable Transactions (PostgreSQL)
-- Only works with SERIALIZABLE and READ ONLY
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE, READ ONLY, DEFERRABLE;
-- Can run in snapshot mode, won't block or be blocked
SELECT * FROM large_table;
COMMIT;

-- 8.4 Nested Transactions (Simulated using savepoints)
BEGIN;
    INSERT INTO audit_log VALUES (1, 'Start operation');
    SAVEPOINT nested_start;
        INSERT INTO payroll VALUES (100, 1, CURRENT_DATE, 5000);
        -- Error here
        ROLLBACK TO SAVEPOINT nested_start;
    INSERT INTO audit_log VALUES (2, 'Operation completed with errors');
COMMIT;

-- 8.5 Distributed Transactions (2PC)
-- Two-Phase Commit
BEGIN;
PREPARE TRANSACTION 'transaction_1';
-- After both prepared
COMMIT PREPARED 'transaction_1';
-- Or rollback
ROLLBACK PREPARED 'transaction_1';

-- 8.6 Autonomous Transactions
-- PostgreSQL doesn't support true autonomous transactions
-- Workaround: Use dblink or separate connection

-- =========================================================
-- LEVEL 9: LOCKING MECHANISMS
-- =========================================================

-- 9.1 Row-Level Locks
-- Automatic on UPDATE/DELETE
BEGIN;
UPDATE employees SET salary = salary * 1.1 WHERE employee_id = 1;
-- Row is locked until COMMIT or ROLLBACK
COMMIT;

-- Explicit row lock (SELECT FOR UPDATE)
BEGIN;
SELECT * FROM employees WHERE employee_id = 1 FOR UPDATE;
-- Now can safely update
UPDATE employees SET salary = 75000 WHERE employee_id = 1;
COMMIT;

-- SELECT FOR SHARE (read lock)
BEGIN;
SELECT * FROM employees WHERE department = 'Sales' FOR SHARE;
-- Other transactions can read but not modify
COMMIT;

-- 9.2 Table-Level Locks
-- Lock entire table
LOCK TABLE employees IN ACCESS EXCLUSIVE MODE;

-- Lock with specific mode
LOCK TABLE payroll IN SHARE MODE;

-- Lock multiple tables
LOCK TABLE employees, departments, projects IN ACCESS SHARE MODE;

-- Lock modes:
/*
ACCESS SHARE: SELECT only
ROW SHARE: SELECT FOR UPDATE/FOR SHARE
ROW EXCLUSIVE: UPDATE, DELETE, INSERT
SHARE UPDATE EXCLUSIVE: VACUUM, CREATE INDEX
SHARE: CREATE INDEX without CONCURRENTLY
SHARE ROW EXCLUSIVE: Not commonly used
EXCLUSIVE: Allows only reads
ACCESS EXCLUSIVE: Full table lock (most restrictive)
*/

-- 9.3 Advisory Locks (Application-level)
-- Session-level advisory lock
SELECT pg_advisory_lock(12345);
-- Critical section
SELECT pg_advisory_unlock(12345);

-- Transaction-level advisory lock
SELECT pg_advisory_xact_lock(12345);
-- Automatically released at transaction end

-- Try lock (non-blocking)
SELECT pg_try_advisory_lock(12345);

-- 9.4 Lock Timeout Configuration
-- Set lock timeout for session
SET lock_timeout = '5s';

-- Set deadlock timeout
SET deadlock_timeout = '1s';

-- 9.5 Deadlock Detection & Resolution
-- PostgreSQL automatically detects deadlocks and rolls back one transaction

-- View current locks
SELECT 
    locktype,
    relation::regclass,
    mode,
    granted,
    pid,
    query
FROM pg_locks
JOIN pg_stat_activity ON pg_locks.pid = pg_stat_activity.pid
WHERE NOT granted;

-- Kill blocked transaction
SELECT pg_terminate_backend(pid);


-- =========================================================
-- LEVEL 10: SECURITY BEST PRACTICES
-- =========================================================

-- 10.1 Principle of Least Privilege
-- Grant minimum necessary permissions
GRANT SELECT ON orders TO sales_team;  -- Not INSERT/UPDATE/DELETE
GRANT SELECT (order_id, customer_name) ON orders TO support_team;  -- Only specific columns

-- 10.2 Password Policies
-- Enforce strong passwords (application-level)
CREATE USER strong_user WITH PASSWORD 'Str0ngP@ssw0rd!2024';

-- Regular password expiration
ALTER USER app_user VALID UNTIL CURRENT_DATE + INTERVAL '90 days';

-- 10.3 Row-Level Security (RLS)
-- Enable RLS on table
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY employee_access ON employees
    USING (employee_id = CURRENT_USER_ID());

-- Policy for managers to see their team
CREATE POLICY manager_access ON employees
    USING (department IN (SELECT department FROM employees WHERE employee_id = CURRENT_USER_ID()));

-- 10.4 Column-Level Encryption
-- Using pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create table with encrypted column
CREATE TABLE sensitive_data (
    id SERIAL PRIMARY KEY,
    ssn TEXT ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = ssn_key),
    credit_card TEXT ENCRYPTED
);

-- 10.5 Audit Logging
-- Create audit table
CREATE TABLE audit_log (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    user_name VARCHAR(50) DEFAULT CURRENT_USER,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);

-- Trigger function for auditing
CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, old_data, new_data)
    VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10.6 Secure Connection Settings
-- In postgresql.conf
-- ssl = on
-- ssl_cert_file = 'server.crt'
-- ssl_key_file = 'server.key'

-- Force SSL for specific users
ALTER USER sensitive_user WITH (SSL);

-- 10.7 Regular Permission Reviews
-- List all grants
SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'employees';

-- List role memberships
SELECT r.rolname AS role_name, m.rolname AS member_name
FROM pg_auth_members am
JOIN pg_roles r ON am.roleid = r.oid
JOIN pg_roles m ON am.member = m.oid;


-- =========================================================
-- LEVEL 11: COMMON SCENARIOS & PATTERNS
-- =========================================================

-- 11.1 User Creation with Time Limits (from your code)
CREATE USER audit_user WITH
    PASSWORD 'audit_pass'
    VALID UNTIL '2024-12-31'
    CONNECTION LIMIT 10;

-- 11.2 Team-Based Role Structure (from your code)
CREATE ROLE finance_team;
CREATE ROLE hr_team;
CREATE ROLE sales_team;

CREATE USER finance_manager WITH PASSWORD 'secure123';
CREATE USER hr_rep WITH PASSWORD 'secure456';
CREATE USER sales_person WITH PASSWORD 'secure789';

GRANT finance_team TO finance_manager;
GRANT hr_team TO hr_rep;
GRANT sales_team TO sales_person;

-- 11.3 Application User Pattern
-- Create application role
CREATE ROLE app_role WITH LOGIN PASSWORD 'app_pass';

-- Grant minimum permissions
GRANT SELECT, INSERT, UPDATE ON app_tables TO app_role;
GRANT USAGE ON app_sequences TO app_role;

-- 11.4 Reporting User Pattern
CREATE ROLE reporting_role WITH LOGIN PASSWORD 'report_pass';

-- Grant read-only access
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reporting_role;
GRANT USAGE ON SCHEMA public TO reporting_role;

-- Set default privileges for new tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT ON TABLES TO reporting_role;

-- 11.5 API Service Account Pattern
CREATE USER api_service WITH 
    PASSWORD 'api_secure_pass'
    CONNECTION LIMIT 50;

-- Grant specific API needed permissions
GRANT SELECT, INSERT ON api_tables TO api_service;
GRANT EXECUTE ON FUNCTION api_function() TO api_service;

-- 11.6 Temporary User Accounts
CREATE USER temp_contractor WITH 
    PASSWORD 'temp123' 
    VALID UNTIL CURRENT_DATE + INTERVAL '3 months'
    CONNECTION LIMIT 1;

GRANT SELECT ON project_tables TO temp_contractor;

-- =========================================================
-- LEVEL 12: PITFALLS & TROUBLESHOOTING
-- =========================================================

-- 12.1 Transaction Blocking
-- Find blocking transactions
SELECT 
    blocked.pid AS blocked_pid,
    blocking.pid AS blocking_pid,
    blocked.query AS blocked_query,
    blocking.query AS blocking_query
FROM pg_stat_activity blocked
JOIN pg_stat_activity blocking 
    ON blocked.wait_event_type = 'Lock' 
    AND blocking.pid != blocked.pid;

-- 12.2 Forgotten COMMIT/ROLLBACK
-- Find idle in transaction
SELECT pid, query, state, xact_start 
FROM pg_stat_activity 
WHERE state = 'idle in transaction'
AND xact_start < NOW() - INTERVAL '5 minutes';

-- Terminate idle transactions
SELECT pg_terminate_backend(pid);

-- 12.3 Permission Denied Errors
-- Check user privileges
SELECT * FROM information_schema.table_privileges 
WHERE grantee = current_user;

-- Check role membership
SELECT * FROM pg_roles WHERE rolname = current_user;

-- 12.4 Role Inheritance Issues
-- Check if role inherits
SELECT rolname, rolinherit FROM pg_roles WHERE rolname = 'user_name';

-- Set inheritance explicitly
ALTER ROLE user_name INHERIT;

-- 12.5 Deadlock Scenarios
-- View deadlock logs in postgresql logs
-- SHOW log_min_messages;

-- Prevent deadlocks by consistent lock ordering
-- Always lock tables in same order across transactions

-- 12.6 Connection Limit Exceeded
-- Check current connections
SELECT COUNT(*) FROM pg_stat_activity;

-- Increase connection limit
ALTER SYSTEM SET max_connections = '200';
SELECT pg_reload_conf();

-- 12.7 Idle in Transaction Problems
-- Set timeout for idle transactions
SET idle_in_transaction_session_timeout = '5min';

-- Kill specific idle transaction
SELECT pg_terminate_backend(pid);

-- =========================================================
-- SECURITY & TRANSACTIONS QUICK REFERENCE
-- =========================================================

-- === USER & ROLE MANAGEMENT ===
CREATE USER username WITH PASSWORD 'pass';
CREATE ROLE rolename;
ALTER USER username WITH PASSWORD 'newpass';
ALTER USER username RENAME TO newname;
DROP USER username;
DROP ROLE rolename;

-- === PERMISSIONS ===
GRANT SELECT ON table TO role;
GRANT ALL PRIVILEGES ON table TO role;
GRANT SELECT (col1, col2) ON table TO role;
GRANT EXECUTE ON FUNCTION func() TO role;
REVOKE INSERT ON table FROM role;
REVOKE ALL ON table FROM role;

-- === ROLE MEMBERSHIP ===
GRANT role TO user;
REVOKE role FROM user;

-- === TRANSACTIONS ===
BEGIN;                              -- Start transaction
COMMIT;                             -- Commit changes
ROLLBACK;                           -- Undo changes
SAVEPOINT sp;                       -- Create savepoint
ROLLBACK TO SAVEPOINT sp;          -- Rollback to savepoint
RELEASE SAVEPOINT sp;               -- Remove savepoint

-- === ISOLATION LEVELS ===
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- === TRANSACTION MODES ===
SET TRANSACTION READ ONLY;
SET TRANSACTION READ WRITE;

-- === LOCKING ===
SELECT * FROM table FOR UPDATE;
SELECT * FROM table FOR SHARE;
LOCK TABLE table IN ACCESS EXCLUSIVE MODE;

-- === MONITORING ===
SELECT * FROM pg_stat_activity;     -- Active connections
SELECT * FROM pg_locks;             -- Current locks
SELECT * FROM pg_roles;             -- All roles
SELECT * FROM information_schema.table_privileges;  -- Permissions

-- === AUDIT ===
CREATE EXTENSION IF NOT EXISTS pgcrypto;  -- Encryption
-- Enable row level security
ALTER TABLE table ENABLE ROW LEVEL SECURITY;

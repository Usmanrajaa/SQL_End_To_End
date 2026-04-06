-- =========================================================
-- SQL SECURITY & TRANSACTIONS RULEBOOK
-- =========================================================

-- LEVEL 1: USER MANAGEMENT
-- 1.1 CREATE USER
-- 1.2 ALTER USER
-- 1.3 RENAME USER
-- 1.4 DROP USER
-- 1.5 User Attributes & Options
-- 1.6 User Password Management
-- 1.7 Connection Limits & Time Restrictions

-- LEVEL 2: ROLE MANAGEMENT
-- 2.1 CREATE ROLE
-- 2.2 ALTER ROLE
-- 2.3 DROP ROLE
-- 2.4 Role Attributes (LOGIN, SUPERUSER, etc.)
-- 2.5 Role Inheritance
-- 2.6 Role vs User (Differences)
-- 2.7 System Roles vs Custom Roles

-- LEVEL 3: GRANT PERMISSIONS
-- 3.1 Basic GRANT Syntax
-- 3.2 Table-Level Permissions
-- 3.3 Schema-Level Permissions
-- 3.4 Database-Level Permissions
-- 3.5 Column-Level Permissions
-- 3.6 Function/Procedure Permissions
-- 3.7 Sequence Permissions
-- 3.8 System Privileges

-- LEVEL 4: REVOKE PERMISSIONS
-- 4.1 Basic REVOKE Syntax
-- 4.2 Revoke Specific Privileges
-- 4.3 Revoke All Privileges
-- 4.4 Column-Level Revoke
-- 4.5 CASCADE vs RESTRICT Options
-- 4.6 GRANT OPTION FOR Clause

-- LEVEL 5: TRANSACTIONS FUNDAMENTALS
-- 5.1 What is a Transaction (ACID Properties)
-- 5.2 BEGIN/START TRANSACTION
-- 5.3 COMMIT
-- 5.4 ROLLBACK
-- 5.5 Transaction States
-- 5.6 Auto-Commit Mode

-- LEVEL 6: SAVEPOINTS
-- 6.1 Creating Savepoints
-- 6.2 Rolling Back to Savepoints
-- 6.3 Releasing Savepoints
-- 6.4 Nested Savepoints
-- 6.5 Savepoint Use Cases

-- LEVEL 7: TRANSACTION ISOLATION LEVELS
-- 7.1 READ UNCOMMITTED
-- 7.2 READ COMMITTED
-- 7.3 REPEATABLE READ
-- 7.4 SERIALIZABLE
-- 7.5 Setting Isolation Levels
-- 7.6 Phantom Reads, Non-Repeatable Reads, Dirty Reads

-- LEVEL 8: ADVANCED TRANSACTION PATTERNS
-- 8.1 Read-Only Transactions
-- 8.2 Read-Write Transactions (Default)
-- 8.3 Deferrable Transactions
-- 8.4 Nested Transactions (Simulated)
-- 8.5 Distributed Transactions (2PC)
-- 8.6 Autonomous Transactions

-- LEVEL 9: LOCKING MECHANISMS
-- 9.1 Row-Level Locks
-- 9.2 Table-Level Locks
-- 9.3 Advisory Locks
-- 9.4 Lock Types (Shared, Exclusive, Update)
-- 9.5 Lock Timeout Configuration
-- 9.6 Deadlock Detection & Resolution

-- LEVEL 10: SECURITY BEST PRACTICES
-- 10.1 Principle of Least Privilege
-- 10.2 Password Policies
-- 10.3 Row-Level Security (RLS)
-- 10.4 Column-Level Encryption
-- 10.5 Audit Logging
-- 10.6 Secure Connection Settings
-- 10.7 Regular Permission Reviews

-- LEVEL 11: COMMON SCENARIOS & PATTERNS
-- 11.1 User Creation with Time Limits
-- 11.2 Team-Based Role Structure
-- 11.3 Application User Pattern
-- 11.4 Reporting User Pattern
-- 11.5 API Service Account Pattern
-- 11.6 Temporary User Accounts

-- LEVEL 12: PITFALLS & TROUBLESHOOTING
-- 12.1 Transaction Blocking
-- 12.2 Forgotten COMMIT/ROLLBACK
-- 12.3 Permission Denied Errors
-- 12.4 Role Inheritance Issues
-- 12.5 Deadlock Scenarios
-- 12.6 Connection Limit Exceeded
-- 12.7 Idle in Transaction Problems
-- ===================================================================
-- DATABASE MANAGEMENT: CREATE, USE, DROP, ALTER, RENAME (Workaround)
-- QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- ===================================================================

-- ===================================================================
-- 1. CREATE DATABASE
-- ===================================================================

-- Q1: How do you create a database named company_db?
CREATE DATABASE company_db;

-- Q2: How do you create a database with UTF-8 character set (utf8mb4) and collation (utf8mb4_unicode_ci) to support emojis and multi-language (Hindi, Arabic, Chinese)?
CREATE DATABASE app_db
   CHARACTER SET utf8mb4
   COLLATE utf8mb4_unicode_ci;

-- Q3: What is the difference between utf8mb4 and utf8? Which one is recommended?
-- Answer: utf8mb4 supports emojis and full Unicode (Hindi, Arabic, Chinese). 
-- utf8 is limited (no full emoji support). Prefer utf8mb4.

-- Q4: What is collation? Give examples of case-insensitive and case-sensitive collation.
-- Answer: Collation defines sorting and searching behavior. 
-- utf8mb4_unicode_ci → case insensitive; utf8mb4_bin → case sensitive.

-- Q5: How do you insert an emoji into a table? (Hint: Windows key + .)
-- Answer: On Windows, press Windows key + period (.) to open the emoji panel when inserting a record.

-- Q6: Write the SQL to create three databases: test_db1, test_db2, test_db3.
CREATE DATABASE test_db1;
CREATE DATABASE test_db2;
CREATE DATABASE test_db3;

-- Q7: After creating the three test databases, how do you list all databases to identify system DBs (mysql, information_schema) and your own DBs (test_db1, test_db2, test_db3)?
SHOW DATABASES;
-- System DBs: mysql, information_schema, performance_schema, sys
-- Your DBs: test_db1, test_db2, test_db3

-- ===================================================================
-- 2. CREATE DATABASE IF NOT EXISTS
-- ===================================================================

-- Q8: What happens if you try to create a database that already exists without IF NOT EXISTS?
-- Answer: It will throw an error. Example: CREATE DATABASE company_db; -- error if exists.

-- Q9: Write the safe way to create a database that avoids errors if it already exists.
CREATE DATABASE IF NOT EXISTS company_db;

-- Q10: Create a database named safe_db using the safe pattern. What happens when you run it twice?
CREATE DATABASE IF NOT EXISTS safe_db;
-- Running twice will produce no error; the second command is ignored.

-- ===================================================================
-- 3. USE DATABASE
-- ===================================================================

-- Q11: How do you select (switch to) the company_db database?
USE company_db;

-- Q12: How do you switch to app_db and then display the current database name?
USE app_db;
SELECT DATABASE();
-- Output should be: app_db

-- ===================================================================
-- 4. DROP DATABASE
-- ===================================================================

-- Q13: Write the command to permanently delete test_db3. Why is this dangerous?
DROP DATABASE test_db3;
-- Danger: It deletes all tables and data inside the database irreversibly.

-- Q14: Write the safe way to drop a database only if it exists, avoiding errors.
DROP DATABASE IF EXISTS test_db3;

-- ===================================================================
-- 5. RENAME DATABASE (IMPORTANT CONCEPT – Workaround)
-- ===================================================================

-- Q15: Does modern MySQL support direct database renaming?
-- Answer: No. Direct RENAME DATABASE is not supported for security reasons.

-- Q16: Describe the workaround to rename a database. Provide the steps.
-- Steps:
-- 1. Create a new database with the desired name.
-- 2. Move all tables from the old database to the new one using RENAME TABLE.
-- 3. Drop the old database.
-- Example:
--   CREATE DATABASE new_sql_pract;
--   RENAME TABLE old_db.table1 TO new_db.table1, old_db.table2 TO new_db.table2, ...;
--   DROP DATABASE old_db;

-- Q17: Write the SQL to rename a database sql_pract (which contains a table T1) to new_sql_pract.
CREATE DATABASE new_sql_pract;
RENAME TABLE sql_pract.T1 TO new_sql_pract.T1;
DROP DATABASE sql_pract;

-- ===================================================================
-- 6. ALTER DATABASE
-- ===================================================================

-- Q18: How do you change the character set of app_db to utf8mb4?
ALTER DATABASE app_db CHARACTER SET = utf8mb4;

-- Q19: How do you change the collation of app_db to utf8mb4_unicode_ci?
ALTER DATABASE app_db COLLATE = utf8mb4_unicode_ci;

-- Q20: Change the character set of test_db1 to utf8mb4.
ALTER DATABASE test_db1 CHARACTER SET = utf8mb4;

-- ===================================================================
-- 7. SHOW DATABASE DETAILS
-- ===================================================================

-- Q21: How do you view the complete creation statement (including character set and collation) of app_db?
SHOW CREATE DATABASE app_db;
-- Output displays the CREATE DATABASE statement with charset and collation.

-- ===================================================================
-- END OF SCRIPT
-- ===================================================================

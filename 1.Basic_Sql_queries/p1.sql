1. CREATE DATABASE company_db;
-- Create with UTF-8 (IMPORTANT for emojis & multi-language)
2. CREATE DATABASE app_db
   CHARACTER SET utf8mb4
   COLLATE utf8mb4_unicode_ci;


utf8mb4 → supports emojis ,hindi/arabic/chinese, 
utf8 → limited (no full emoji support)
-- sorting and searching behaviour(collation)
utf8mb4_unicode_ci -> case insensitive
utf8mb4_bin -> case sensitive

-- Windows key+. (for emoji panel when inserting any record having emoji in table)


TASK1:
Create 3 databases:
CREATE DATABASE test_db1;
CREATE DATABASE test_db2;
CREATE DATABASE test_db3;
Task2:
Run SHOW DATABASES
Identify:
system DBs (mysql, information_schema)
YOUR DB (test_db1,test_db2,test_db3)

3. CREATE DATABASE IF NOT EXISTS
 -- Without IF NOT EXISTS
CREATE DATABASE company_db; -- Error if already exists
-- Safe Way
CREATE DATABASE IF NOT EXISTS company_db;
Task1:
-- Run twice:
CREATE DATABASE IF NOT EXISTS safe_db;
-- Observe: no error

4. -- USE DATABASE
-- Select Database
USE company_db;
-- Now all tables will be created inside this DB
Task1:
USE app_db;
SELECT DATABASE();
--Output should be:
app_db


5. -- DROP DATABASE
-- Danger (Deletes everything)
DROP DATABASE test_db3;
-- Safe Way
DROP DATABASE IF EXISTS test_db3;

6. --RENAME DATABASE (IMPORTANT CONCEPT)
-- Direct rename NOT supported in modern MySQL
-- Alternative way to rename task
    Create database sql_pract; -- make table inside it (say T1)
    CREATE DATABASE new_sql_pract;
-- Move tables from sql_pract to new_sql_pract
    RENAME TABLE sql_pract.T1 TO new_sql_pract.T1;
-- Drop old DB
    DROP DATABASE sql_pract
-- now you have T1 table inside new_sql_pract. so without directly renaming database
-- you made new database and moved all tables to new database from old one 


7. -- ALTER DATABASE
-- Change Character Set
ALTER DATABASE app_db CHARACTER SET = utf8mb4;
-- Change Collation
ALTER DATABASE app_db COLLATE = utf8mb4_unicode_ci;
-- Practice Task
ALTER DATABASE test_db1 CHARACTER SET = utf8mb4;

8: -- SHOW DATABASE DETAILS
SHOW CREATE DATABASE app_db;
-- Output
-- charset
-- collation





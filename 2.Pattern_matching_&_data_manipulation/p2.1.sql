
-- ===================================================================
-- PART 2: PATTERN MATCHING WITH LIKE
-- ===================================================================

-- 2.1 Basic LIKE patterns
-- ----------------------------------------
-- Starts with 'J'
SELECT * FROM employees 
WHERE first_name LIKE 'J%';

-- Ends with 'son'
SELECT * FROM employees 
WHERE last_name LIKE '%son';

-- Contains 'son' anywhere
SELECT * FROM employees 
WHERE last_name LIKE '%son%';

-- 2.2 Single character wildcard (_)
-- ----------------------------------------
-- Exactly one character before @
SELECT * FROM employees 
WHERE email LIKE '_%@company.com';

-- Second letter is 'a'
SELECT * FROM employees 
WHERE first_name LIKE '_a%';

-- Exactly 5-letter names
SELECT * FROM employees 
WHERE first_name LIKE '_____';

-- 2.3 NOT LIKE
-- ----------------------------------------
SELECT * FROM employees 
WHERE first_name NOT LIKE 'J%';

-- 2.4 Complex LIKE patterns
-- ----------------------------------------
-- Names starting with J and ending with n
SELECT * FROM employees 
WHERE first_name LIKE 'J%n';

-- Email with dot before domain
SELECT * FROM employees 
WHERE email LIKE '%.%@company.com';

-- ===================================================================
-- PART 3: ADVANCED PATTERN MATCHING WITH REGEXP
-- ===================================================================

-- 3.1 Basic REGEXP patterns
-- ----------------------------------------
-- Exact match (starts and ends)
SELECT * FROM employees 
WHERE first_name REGEXP '^John$';

-- Starts with J
SELECT * FROM employees 
WHERE first_name REGEXP '^J';

-- Ends with 'son'
SELECT * FROM employees 
WHERE last_name REGEXP 'son$';

-- Contains 'ar'
SELECT * FROM employees 
WHERE first_name REGEXP 'ar';

-- 3.2 Character classes and sets
-- ----------------------------------------
-- Any single character (.)
SELECT * FROM employees 
WHERE first_name REGEXP '^J.n';

-- Character set [abc]
SELECT * FROM employees 
WHERE first_name REGEXP '^[ABC]';

-- Not in set [^abc]
SELECT * FROM employees 
WHERE first_name REGEXP '^[^ABC]';

-- Range [A-Z]
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Z]';

-- 3.3 Character type patterns
-- ----------------------------------------
-- Contains digits
SELECT * FROM employees 
WHERE email REGEXP '[0-9]';

-- Only alphabets
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Za-z]+$';

-- Only lowercase letters
SELECT * FROM employees 
WHERE first_name REGEXP '^[a-z]+$';

-- Only uppercase letters
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Z]+$';

-- 3.4 Length-based patterns
-- ----------------------------------------
-- Exactly 5 letters
SELECT * FROM employees 
WHERE first_name REGEXP '^.{5}$';

-- Between 3 to 6 characters
SELECT * FROM employees 
WHERE first_name REGEXP '^.{3,6}$';

-- Minimum 3 characters
SELECT * FROM employees 
WHERE first_name REGEXP '^.{3,}$';

-- 3.5 OR and alternation
-- ----------------------------------------
-- Using OR (|)
SELECT * FROM employees 
WHERE department REGEXP 'Sales|IT';

-- Multiple patterns
SELECT * FROM employees 
WHERE first_name REGEXP 'John|Jane|Jim';

-- 3.6 Word boundaries and special characters
-- ----------------------------------------
-- Word boundary (\b)
SELECT * FROM employees 
WHERE notes REGEXP '\\bteam\\b';

-- Escape dot (.)
SELECT * FROM employees 
WHERE email REGEXP '\\.com$';

-- Escape backslash
SELECT * FROM employees 
WHERE notes REGEXP '\\\\';

-- 3.7 NOT REGEXP
-- ----------------------------------------
SELECT * FROM employees 
WHERE first_name NOT REGEXP '^J';

-- ===================================================================
-- PART 4: COMBINED PATTERN MATCHING
-- ===================================================================

-- 4.1 LIKE + REGEXP combinations
-- ----------------------------------------
SELECT *
FROM employees
WHERE first_name LIKE 'J%'
  AND email REGEXP '@company\\.com$'
  AND department IN ('Sales', 'IT');

-- 4.2 Multiple pattern conditions
-- ----------------------------------------
SELECT *
FROM employees
WHERE (first_name REGEXP '^[A-Z]' AND last_name LIKE '%son')
   OR email REGEXP '[0-9]';

-- ===================================================================
-- PART 5: CASE EXPRESSIONS
-- ===================================================================

-- 5.1 Simple CASE
-- ----------------------------------------
SELECT first_name, salary,
CASE
    WHEN salary < 50000 THEN 'Low'
    WHEN salary BETWEEN 50000 AND 70000 THEN 'Medium'
    ELSE 'High'
END AS salary_category
FROM employees;

-- 5.2 CASE with pattern matching
-- ----------------------------------------
SELECT first_name, email,
CASE
    WHEN email LIKE '%@company.com' THEN 'Official'
    WHEN email LIKE '%@gmail.com' THEN 'Personal'
    WHEN email IS NULL THEN 'Missing'
    ELSE 'Other'
END AS email_type
FROM employees;

-- 5.3 CASE in ORDER BY
-- ----------------------------------------
SELECT *
FROM employees
ORDER BY 
CASE 
    WHEN department = 'Sales' THEN 1
    WHEN department = 'Marketing' THEN 2
    WHEN department = 'HR' THEN 3
    WHEN department = 'IT' THEN 4
    ELSE 5
END;

-- 5.4 CASE in WHERE clause
-- ----------------------------------------
SELECT *
FROM employees
WHERE CASE 
    WHEN department = 'IT' THEN salary > 70000
    WHEN department = 'Sales' THEN salary > 60000
    ELSE salary > 50000
END;

-- ===================================================================
-- PART 6: SORTING AND LIMITING
-- ===================================================================

-- 6.1 Basic ORDER BY
-- ----------------------------------------
-- Ascending (default)
SELECT * FROM employees
ORDER BY salary ASC;

-- Descending
SELECT * FROM employees
ORDER BY salary DESC;

-- Multiple columns
SELECT * FROM employees
ORDER BY department ASC, salary DESC;

-- 6.2 Custom sorting
-- ----------------------------------------
-- With CASE
SELECT * FROM employees
ORDER BY 
CASE department
    WHEN 'IT' THEN 1
    WHEN 'Sales' THEN 2
    ELSE 3
END;

-- 6.3 LIMIT and OFFSET
-- ----------------------------------------
-- Top 5 highest salaries
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Pagination (5 records per page)
-- Page 1
SELECT * FROM employees LIMIT 5 OFFSET 0;
-- Page 2
SELECT * FROM employees LIMIT 5 OFFSET 5;

-- ===================================================================
-- PART 7: DISTINCT AND UNIQUE VALUES
-- ===================================================================

-- 7.1 Basic DISTINCT
-- ----------------------------------------
SELECT DISTINCT department FROM employees;

-- Multiple columns
SELECT DISTINCT department, job_title FROM employees;





-- ===================================================================
-- PART 8: COMPREHENSIVE EXAMPLES (INTERVIEW STYLE)
-- ===================================================================

-- 8.1 Find high earners in IT department with specific name patterns
-- ----------------------------------------
SELECT first_name, last_name, salary, email
FROM employees
WHERE department = 'IT'
  AND salary > 70000
  AND first_name REGEXP '^[A-M]'
  AND email LIKE '%@company.com'
ORDER BY salary DESC
LIMIT 10;

-- 8.2 Categorize employees with multiple conditions
-- ----------------------------------------
SELECT 
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary > 80000 THEN 'Executive'
        WHEN salary > 60000 AND department IN ('IT', 'Sales') THEN 'Senior'
        WHEN salary > 50000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS level,
    CASE
        WHEN email LIKE '%@company.com' THEN 'Internal'
        WHEN email IS NULL THEN 'No Email'
        ELSE 'External'
    END AS email_status
FROM employees
WHERE hire_date >= '2020-01-01'
ORDER BY salary DESC;

-- 8.3 Pattern matching with multiple criteria
-- ----------------------------------------
SELECT *
FROM employees
WHERE (
    first_name LIKE 'J%' 
    OR last_name REGEXP 'son$'
)
AND email NOT REGEXP '[0-9]'
AND department IN ('IT', 'HR', 'Sales')
ORDER BY 
    CASE department
        WHEN 'Sales' THEN 1
        WHEN 'IT' THEN 2
        ELSE 3
    END,
    last_name;


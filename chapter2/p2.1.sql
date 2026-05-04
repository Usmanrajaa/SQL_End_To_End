-- ===================================================================
-- PATTERN MATCHING, CASE EXPRESSIONS, SORTING, AND DISTINCT
-- QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- ===================================================================

-- ===================================================================
-- PART 2: PATTERN MATCHING WITH LIKE
-- ===================================================================

-- Q1: How do you find employees whose first name starts with 'J'?
SELECT * FROM employees 
WHERE first_name LIKE 'J%';

-- Q2: How do you find employees whose last name ends with 'son'?
SELECT * FROM employees 
WHERE last_name LIKE '%son';

-- Q3: How do you find employees whose last name contains 'son' anywhere?
SELECT * FROM employees 
WHERE last_name LIKE '%son%';

-- Q4: How do you find employees whose email has exactly one character before '@company.com'?
SELECT * FROM employees 
WHERE email LIKE '_%@company.com';

-- Q5: How do you find employees whose first name has second letter 'a'?
SELECT * FROM employees 
WHERE first_name LIKE '_a%';

-- Q6: How do you find employees with exactly 5-letter first names?
SELECT * FROM employees 
WHERE first_name LIKE '_____';

-- Q7: How do you find employees whose first name does NOT start with 'J'?
SELECT * FROM employees 
WHERE first_name NOT LIKE 'J%';

-- Q8: How do you find employees whose first name starts with 'J' and ends with 'n'?
SELECT * FROM employees 
WHERE first_name LIKE 'J%n';

-- Q9: How do you find employees whose email contains a dot before the domain (e.g., @company.com)?
SELECT * FROM employees 
WHERE email LIKE '%.%@company.com';

-- ===================================================================
-- PART 3: ADVANCED PATTERN MATCHING WITH REGEXP
-- ===================================================================

-- Q10: Using REGEXP, find employees whose first name is exactly 'John' (start and end).
SELECT * FROM employees 
WHERE first_name REGEXP '^John$';

-- Q11: Using REGEXP, find employees whose first name starts with 'J'.
SELECT * FROM employees 
WHERE first_name REGEXP '^J';

-- Q12: Using REGEXP, find employees whose last name ends with 'son'.
SELECT * FROM employees 
WHERE last_name REGEXP 'son$';

-- Q13: Using REGEXP, find employees whose first name contains 'ar'.
SELECT * FROM employees 
WHERE first_name REGEXP 'ar';

-- Q14: Using REGEXP with dot (any single character), find employees whose first name starts with 'J' followed by any character then 'n' (e.g., Jan, Jon).
SELECT * FROM employees 
WHERE first_name REGEXP '^J.n';

-- Q15: Using REGEXP character set [abc], find employees whose first name starts with A, B, or C.
SELECT * FROM employees 
WHERE first_name REGEXP '^[ABC]';

-- Q16: Using REGEXP negated set [^abc], find employees whose first name does NOT start with A, B, or C.
SELECT * FROM employees 
WHERE first_name REGEXP '^[^ABC]';

-- Q17: Using REGEXP range [A-Z], find employees whose first name starts with any uppercase letter.
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Z]';

-- Q18: Using REGEXP digit class, find employees whose email contains a digit.
SELECT * FROM employees 
WHERE email REGEXP '[0-9]';

-- Q19: Using REGEXP, find employees whose first name contains only alphabetic characters (no spaces, digits, or punctuation).
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Za-z]+$';

-- Q20: Using REGEXP, find employees whose first name contains only lowercase letters.
SELECT * FROM employees 
WHERE first_name REGEXP '^[a-z]+$';

-- Q21: Using REGEXP, find employees whose first name contains only uppercase letters.
SELECT * FROM employees 
WHERE first_name REGEXP '^[A-Z]+$';

-- Q22: Using REGEXP length pattern, find employees whose first name is exactly 5 characters long.
SELECT * FROM employees 
WHERE first_name REGEXP '^.{5}$';

-- Q23: Using REGEXP length pattern, find employees whose first name length is between 3 and 6 characters inclusive.
SELECT * FROM employees 
WHERE first_name REGEXP '^.{3,6}$';

-- Q24: Using REGEXP length pattern, find employees whose first name has at least 3 characters.
SELECT * FROM employees 
WHERE first_name REGEXP '^.{3,}$';

-- Q25: Using REGEXP alternation (|), find employees in Sales or IT department.
SELECT * FROM employees 
WHERE department REGEXP 'Sales|IT';

-- Q26: Using REGEXP alternation, find employees whose first name is John, Jane, or Jim.
SELECT * FROM employees 
WHERE first_name REGEXP 'John|Jane|Jim';

-- Q27: Using REGEXP word boundary, find employees whose notes contain the exact word 'team' (not as part of another word).
SELECT * FROM employees 
WHERE notes REGEXP '\\bteam\\b';

-- Q28: Using REGEXP, find employees whose email ends with '.com' (escape the dot).
SELECT * FROM employees 
WHERE email REGEXP '\\.com$';

-- Q29: Using REGEXP, find employees whose notes contain a literal backslash.
SELECT * FROM employees 
WHERE notes REGEXP '\\\\';

-- Q30: Using NOT REGEXP, find employees whose first name does NOT start with 'J'.
SELECT * FROM employees 
WHERE first_name NOT REGEXP '^J';

-- ===================================================================
-- PART 4: COMBINED PATTERN MATCHING
-- ===================================================================

-- Q31: Combine LIKE and REGEXP: first name starts with 'J' AND email ends with '@company.com' AND department is Sales or IT.
SELECT *
FROM employees
WHERE first_name LIKE 'J%'
  AND email REGEXP '@company\\.com$'
  AND department IN ('Sales', 'IT');

-- Q32: Combine multiple pattern conditions: first name starts with uppercase letter AND last name ends with 'son' OR email contains a digit.
SELECT *
FROM employees
WHERE (first_name REGEXP '^[A-Z]' AND last_name LIKE '%son')
   OR email REGEXP '[0-9]';

-- ===================================================================
-- PART 5: CASE EXPRESSIONS
-- ===================================================================

-- Q33: Write a simple CASE statement to categorize salary into 'Low' (<50k), 'Medium' (50k-70k), 'High' (>70k).
SELECT first_name, salary,
CASE
    WHEN salary < 50000 THEN 'Low'
    WHEN salary BETWEEN 50000 AND 70000 THEN 'Medium'
    ELSE 'High'
END AS salary_category
FROM employees;

-- Q34: Use CASE with pattern matching to classify email types: '@company.com' as 'Official', '@gmail.com' as 'Personal', NULL as 'Missing', else 'Other'.
SELECT first_name, email,
CASE
    WHEN email LIKE '%@company.com' THEN 'Official'
    WHEN email LIKE '%@gmail.com' THEN 'Personal'
    WHEN email IS NULL THEN 'Missing'
    ELSE 'Other'
END AS email_type
FROM employees;

-- Q35: Use CASE in ORDER BY to sort departments in custom order: Sales first, then Marketing, then HR, then IT, then others.
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

-- Q36: Use CASE in WHERE clause to apply different salary thresholds per department: IT > 70k, Sales > 60k, all others > 50k.
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

-- Q37: Sort employees by salary in ascending order (default).
SELECT * FROM employees
ORDER BY salary ASC;

-- Q38: Sort employees by salary in descending order.
SELECT * FROM employees
ORDER BY salary DESC;

-- Q39: Sort employees by department ascending, and within department by salary descending.
SELECT * FROM employees
ORDER BY department ASC, salary DESC;

-- Q40: Sort employees using a custom order: IT first, then Sales, then others (using CASE).
SELECT * FROM employees
ORDER BY 
CASE department
    WHEN 'IT' THEN 1
    WHEN 'Sales' THEN 2
    ELSE 3
END;

-- Q41: Show the top 5 highest paid employees.
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Q42: Implement pagination: show records 1-5 (page 1) and records 6-10 (page 2) using LIMIT and OFFSET.
-- Page 1
SELECT * FROM employees LIMIT 5 OFFSET 0;
-- Page 2
SELECT * FROM employees LIMIT 5 OFFSET 5;

-- ===================================================================
-- PART 7: DISTINCT AND UNIQUE VALUES
-- ===================================================================

-- Q43: Show all unique department names from the employees table.
SELECT DISTINCT department FROM employees;

-- Q44: Show unique combinations of department and job_title.
SELECT DISTINCT department, job_title FROM employees;

-- ===================================================================
-- PART 8: COMPREHENSIVE EXAMPLES (INTERVIEW STYLE)
-- ===================================================================

-- Q45: Find high earners in IT department with first name starting with letters A-M, official company email, sorted by salary, limit 10.
SELECT first_name, last_name, salary, email
FROM employees
WHERE department = 'IT'
  AND salary > 70000
  AND first_name REGEXP '^[A-M]'
  AND email LIKE '%@company.com'
ORDER BY salary DESC
LIMIT 10;

-- Q46: Categorize employees by salary level and email status, filtering hires after 2020-01-01, order by salary descending.
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

-- Q47: Complex pattern matching: first name starts with J or last name ends with son, email has no digits, department in IT, HR, Sales, custom order by department.
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

-- ===================================================================
-- END OF SCRIPT
-- ===================================================================

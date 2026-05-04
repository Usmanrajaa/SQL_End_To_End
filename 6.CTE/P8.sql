-- ===================================================================
-- CTEs (COMMON TABLE EXPRESSIONS): NON-RECURSIVE & RECURSIVE
-- QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- ===================================================================

-- ===================================================================
-- SECTION 1: SETUP & INITIAL QUERIES
-- ===================================================================

-- Q1: Switch to database DSG_11.
USE DSG_11;

-- Q2: Show all tables in the current database.
SHOW TABLES;

-- Q3: View all data from the EMPLOYEES table.
SELECT * FROM EMPLOYEES;

-- Q4: View all data from the departments table.
SELECT * FROM departments;

-- ===================================================================
-- SECTION 2: NON‑RECURSIVE CTE (SIMPLE CTE)
-- ===================================================================

-- Q5: Create a non‑recursive CTE named `abc` that selects first_name and salary for employees earning > 60000, then select from it.
WITH abc AS (
    SELECT first_name, salary
    FROM employees
    WHERE salary > 60000
)
SELECT * FROM abc;

-- Q6: Create another CTE `xyz` with the same definition, then calculate the average salary from that CTE.
WITH xyz AS (
    SELECT first_name, salary
    FROM employees
    WHERE salary > 60000
)
SELECT AVG(salary) FROM xyz;

-- Q7: (Optional) Show how you can select from a CTE multiple times – here commented.
-- WITH xyz AS (...)
-- SELECT * FROM xyz;
-- SELECT AVG(salary) FROM xyz;

-- ===================================================================
-- SECTION 3: MULTIPLE CTEs (NON‑RECURSIVE)
-- ===================================================================

-- Q8: Write two CTEs – one for managers, one for recent hires (hire_date > '2019-01-01').
--     Then write a query to find recent hires who work in the same department as at least one manager.
WITH manager AS (
    SELECT * FROM employees WHERE is_manager = 1
),
recent_hires AS (
    SELECT * FROM employees WHERE hire_date > '2019-01-01'
)
SELECT rh.*
FROM recent_hires rh
WHERE rh.department IN (SELECT department FROM manager);

-- ===================================================================
-- SECTION 4: TABLE CREATION FOR RECURSIVE CTE PRACTICE
-- ===================================================================

-- Q9: Create and populate the `employee_data` table for hierarchy queries.
CREATE TABLE employee_data (
    emp_id INT,
    emp_name VARCHAR(50),
    manager_id INT
);

INSERT INTO employee_data VALUES
(1, 'A', NULL),
(2, 'B', 1),
(3, 'C', 2),
(4, 'D', 1),
(5, 'E', 2),
(6, 'f', 1),
(7, 'G', 3),
(8, 'H', 1),
(9, 'I', 9),
(10, 'J', 1),
(11, 'K', 7),
(12, 'L', 100),
(13, 'M', 101),
(14, 'N', 104),
(15, 'O', 109);

-- Q10: View all data from employee_data.
SELECT * FROM employee_data;

-- ===================================================================
-- SECTION 5: BASIC RECURSIVE CTE (FIND ALL REPORTERS TO MANAGER 1)
-- ===================================================================

-- Q11: Find all employees who directly or indirectly report to manager with emp_id = 1 (including all levels).
WITH RECURSIVE xyz AS (
    -- Anchor query: direct reporters (manager_id = 1)
    SELECT *
    FROM employee_data
    WHERE manager_id = 1

    UNION ALL

    -- Recursive query: find those who report to the employees already found
    SELECT e.*
    FROM employee_data e
    JOIN xyz x ON e.manager_id = x.emp_id
)
SELECT * FROM xyz;

-- ===================================================================
-- SECTION 6: RECURSIVE CTE WITH LEVEL TRACKING (LABEL COLUMN)
-- ===================================================================

-- Q12: Add a level (label) column to show hierarchical depth (0 = direct reports of manager 1).
WITH RECURSIVE xyz AS (
    SELECT *, 0 AS label
    FROM employee_data
    WHERE manager_id = 1

    UNION ALL

    SELECT e.*, x.label + 1 AS label
    FROM employee_data e
    JOIN xyz x ON e.manager_id = x.emp_id
)
SELECT * FROM xyz;

-- Q13: From the same CTE, count the total number of direct and indirect reporters.
WITH RECURSIVE xyz AS (
    SELECT *, 0 AS label
    FROM employee_data
    WHERE manager_id = 1

    UNION ALL

    SELECT e.*, x.label + 1 AS label
    FROM employee_data e
    JOIN xyz x ON e.manager_id = x.emp_id
)
SELECT COUNT(*) AS total_reporters FROM xyz;

-- Q14: From the same CTE, find all employees at level 3 (label = 3).
WITH RECURSIVE xyz AS (
    SELECT *, 0 AS label
    FROM employee_data
    WHERE manager_id = 1

    UNION ALL

    SELECT e.*, x.label + 1 AS label
    FROM employee_data e
    JOIN xyz x ON e.manager_id = x.emp_id
)
SELECT * FROM xyz WHERE label = 3;

-- ===================================================================
-- SECTION 7: ADVANCED RECURSIVE CTE – AGGREGATIONS PER LEVEL
-- ===================================================================

-- Q15: Write a recursive CTE and then use conditional aggregation to count employees per label.
WITH RECURSIVE xyz AS (
    SELECT *, 0 AS label
    FROM employee_data
    WHERE manager_id = 1

    UNION ALL

    SELECT e.*, x.label + 1 AS label
    FROM employee_data e
    JOIN xyz x ON e.manager_id = x.emp_id
)
SELECT 
    SUM(CASE WHEN label = 0 THEN 1 END) AS direct_reporters_label0,
    SUM(CASE WHEN label = 1 THEN 1 END) AS level1_reporters,
    SUM(CASE WHEN label = 2 THEN 1 END) AS level2_reporters,
    SUM(CASE WHEN label = 3 THEN 1 END) AS level3_reporters
FROM xyz;

-- ===================================================================
-- END OF CTE QUESTIONS & SOLUTIONS
-- ===================================================================

-- ===================================================================
-- PART D: STANDALONE PRACTICE PROBLEM (WITH SOLUTION)
-- ===================================================================
/*
PROBLEM: Using the `employee_data` table above, write a recursive CTE that:

1. Starts with the employee who has no manager (manager_id IS NULL) – that is the CEO.
2. Traverses down the hierarchy, showing each employee's name, level, and a full path of names (e.g., "A → B → C").
3. Finally, list all employees at level 2 (two steps below the CEO).

Expected output (based on data): 
- CEO A (level 0)
- B, D, f, H, J (level 1)
- C, E (level 2)
- G (level 3)
- K (level 4)
- (others with manager_id not in hierarchy appear as orphans)
*/

-- SOLUTION:

WITH RECURSIVE hierarchy AS (
    -- Anchor: top-level (no manager)
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS CHAR(200)) AS path
    FROM employee_data
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: employees reporting to those already in the CTE
    SELECT 
        e.emp_id,
        e.emp_name,
        e.manager_id,
        h.level + 1,
        CONCAT(h.path, ' → ', e.emp_name)
    FROM employee_data e
    JOIN hierarchy h ON e.manager_id = h.emp_id
)
-- Answer 1 & 2: Show all with level and path
SELECT * FROM hierarchy ORDER BY level, emp_id;

-- Answer 3: Employees at level 2
SELECT emp_name, level, path
FROM hierarchy
WHERE level = 2;

-- ===================================================================
-- PART E: RULEBOOK – CTEs (COMMON TABLE EXPRESSIONS)
-- ===================================================================
/*
TOPICS AND SUBTOPICS COVERED

1. NON‑RECURSIVE CTEs
   - Basic syntax: WITH cte_name AS (query) SELECT * FROM cte_name;
   - Using CTEs for readability (replacing derived tables)
   - Multiple CTEs in one WITH clause (separated by commas)
   - Referencing one CTE from another CTE
   - CTEs in SELECT, UPDATE, DELETE, INSERT

2. RECURSIVE CTEs
   - Syntax: WITH RECURSIVE cte_name AS ( anchor_query UNION ALL recursive_query )
   - Anchor query: starting rows (base case)
   - Recursive query: references the CTE itself
   - UNION ALL (must be used; UNION removes duplicates but may infinite loop)
   - Termination condition (when recursive query returns no rows)

3. HIERARCHICAL DATA TRAVERSAL
   - Employee/manager hierarchies (org charts)
   - Finding all subordinates (direct and indirect)
   - Level / depth tracking (label column incremented each recursion)
   - Path enumeration (building string of ancestors/descendants)
   - Filtering by level (WHERE level = N)

4. AGGREGATIONS WITH RECURSIVE CTEs
   - Counting nodes per level (using CASE or GROUP BY)
   - Finding root nodes, leaf nodes
   - Calculating subtree sizes

5. PRACTICAL USE CASES
   - Bill of Materials (BOM) explosion
   - Folder / file system traversal
   - Graph traversal (social networks, friend recommendations)
   - Generating number or date series (without a calendar table)

6. LIMITS & SAFETY
   - MySQL recursion depth limit (default 1000, can be changed via @@cte_max_recursion_depth)
   - Avoiding infinite loops (ensure anchor plus recursive eventually returns empty)
   - Performance considerations (recursive CTEs can be expensive on deep hierarchies)

7. NON‑RECURSIVE CTE USE CASES
   - Breaking down complex queries into steps
   - Reusing the same subquery multiple times
   - Improving readability over nested subqueries
   - Simulating materialized query results within a single statement

8. MULTIPLE CTEs COMBINED
   - Using WITH for both non‑recursive and recursive CTEs (only one recursive allowed)
   - Mixing CTEs with joins, aggregations, window functions
*/


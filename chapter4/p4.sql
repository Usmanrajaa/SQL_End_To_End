LEVEL 1: JOINS FUNDAMENTALS – QUESTIONS & SOLUTIONS
Q1: What is a JOIN?
A JOIN combines rows from two or more tables based on a related column.

Q2: Write the basic syntax structure of a JOIN statement.

 
SELECT columns
FROM table1
[JOIN_TYPE] table2 ON join_condition
[WHERE filter_condition]
[GROUP BY group_columns]
[HAVING group_filter]
[ORDER BY sort_columns];
Q3: Show how to use the ON clause vs the USING clause in a JOIN.
Using ON (most common, works for any condition)

 
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Using USING (when column names are identical)

 
SELECT * FROM employees e
INNER JOIN departments d USING (department);
Q4: List all JOIN types mentioned in the tutorial and give a one‑sentence description of each.

INNER JOIN: Returns rows that match in both tables

LEFT JOIN: Returns all rows from left table + matches from right

RIGHT JOIN: Returns all rows from right table + matches from left

FULL JOIN: Returns all rows from both tables (not directly in My )

CROSS JOIN: Returns Cartesian product (every row from left × every row from right)

SELF JOIN: Joining a table with itself

NATURAL JOIN: Joins on columns with same name (automatic, risky)

Q5: How does NULL behave in join conditions? Provide an example query that finds employees with no projects using NULL handling.
NULL values never match with anything, including other NULLs. Use COALESCE or IS NULL. Example:

 
SELECT * FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.employee_id IS NULL;  -- Finds employees with no projects
LEVEL 2: INNER JOIN – QUESTIONS & SOLUTIONS
Q6: Write a basic INNER JOIN that returns employees’ first/last name, salary, and their department budget.

 
SELECT e.first_name, e.last_name, e.salary, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q7: Write an INNER JOIN with multiple conditions (including a budget condition on the right table).

 
SELECT e.first_name, e.last_name, p.project_name, p.budget
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id 
                      AND p.budget > 50000;
Q8: Show an INNER JOIN involving three tables (employees, departments, projects).

 
SELECT e.first_name, e.last_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
Q9: Write an INNER JOIN with a WHERE clause filtering salary > 60000 and department budget > 200000.

 
SELECT e.first_name, e.last_name, e.salary, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > 60000 AND d.budget > 200000;
Q10: Demonstrate the use of table aliases in an INNER JOIN.

 
SELECT emp.first_name, emp.last_name, dept.dept_name
FROM employees AS emp
INNER JOIN departments AS dept ON emp.department = dept.dept_name;
Q11: Compare the old comma‑join syntax with the modern INNER JOIN syntax. Which is preferred?
Old syntax (avoid):

 
SELECT * FROM employees e, departments d WHERE e.department = d.dept_name;
Modern syntax (preferred):

 
SELECT * FROM employees e INNER JOIN departments d ON e.department = d.dept_name;
Q12: Write a self INNER JOIN that finds pairs of employees in the same department (excluding self‑pairs).

 
SELECT e1.first_name AS employee1, e2.first_name AS employee2, e1.department
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e1.employee_id < e2.employee_id;
Q13: Provide an example of a non‑equi INNER JOIN (joining on a condition other than equality).
Find employees whose salary is within department budget range:

 
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary <= d.budget / 5;
LEVEL 3: LEFT JOIN (LEFT OUTER JOIN) – QUESTIONS & SOLUTIONS
Q14: Write a basic LEFT JOIN that shows all employees and any projects they have.

 
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;
Q15: Explain the danger of filtering the right table in the WHERE clause of a LEFT JOIN. Show the correct way to filter on the right table without converting to an INNER JOIN.
Filtering on the right table in WHERE converts LEFT JOIN to INNER JOIN (removes rows with NULL). Correct way – filter in ON clause:

 
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;
Wrong way (becomes INNER JOIN):

 
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;
Q16: Write a query using LEFT JOIN to find employees with NO projects.

 
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.project_id IS NULL;
Q17: Write a LEFT JOIN with multiple conditions, including a filter on project start date.

 
SELECT e.first_name, e.last_name, p.project_name, p.budget
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id 
                     AND p.start_date >= '2024-01-01';
Q18: Write a LEFT JOIN involving three tables (employees, departments, projects) to keep all employees even if department or project is missing.

 
SELECT e.first_name, e.last_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
LEFT JOIN projects p ON e.employee_id = p.employee_id;
Q19: Write a LEFT JOIN that replaces NULL values with defaults using COALESCE.

 
SELECT e.first_name, 
       COALESCE(p.project_name, 'No Project') AS project_name,
       COALESCE(p.budget, 0) AS project_budget
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;
Q20: Write a query using LEFT JOIN with COUNT that correctly counts employees per department, including those without projects. Explain why COUNT(project_id) vs COUNT(*) matters.
COUNT(column) ignores NULLs, COUNT(*) counts all rows.

 
SELECT e.department,
       COUNT(*) AS total_employees,
       COUNT(p.project_id) AS employees_with_projects
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY e.department;
Q21: Compare the result counts of an INNER JOIN vs a LEFT JOIN between employees and projects on employee_id.

 
-- INNER JOIN: Only employees with projects
SELECT COUNT(*) FROM employees e INNER JOIN projects p ON e.employee_id = p.employee_id;
-- LEFT JOIN: All employees (with or without projects)
SELECT COUNT(*) FROM employees e LEFT JOIN projects p ON e.employee_id = p.employee_id;
LEVEL 4: RIGHT JOIN (RIGHT OUTER JOIN) – QUESTIONS & SOLUTIONS
Q22: Write a basic RIGHT JOIN that shows all projects and the employees assigned to them.

 
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;
Q23: Use a RIGHT JOIN to list all projects, even unassigned ones, with the assigned employee name.

 
SELECT p.project_name, e.first_name AS assigned_to
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;
Q24: Show how a RIGHT JOIN can be rewritten as a LEFT JOIN. Provide an equivalent pair of queries.
The following two queries are equivalent:

 
-- RIGHT JOIN
SELECT * FROM employees e RIGHT JOIN projects p ON e.employee_id = p.employee_id;
-- LEFT JOIN (tables swapped)
SELECT * FROM projects p LEFT JOIN employees e ON p.employee_id = e.employee_id;
Q25: Write a query combining RIGHT JOIN and LEFT JOIN across three tables (projects, employees, departments).

 
SELECT p.project_name, e.first_name, d.dept_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN departments d ON e.department = d.dept_name;
Q26: When might you use a RIGHT JOIN instead of a LEFT JOIN? Provide an example that finds unassigned projects using RIGHT JOIN.
Some people find RIGHT JOIN more readable in certain scenarios. Example:

 
SELECT p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;
LEVEL 5: FULL OUTER JOIN – QUESTIONS & SOLUTIONS
Q27: Does My  natively support FULL OUTER JOIN? How can it be simulated?
My  doesn't support FULL OUTER JOIN directly. Simulate using UNION of LEFT JOIN and RIGHT JOIN.

Q28: Write a query that simulates FULL OUTER JOIN between employees and projects using UNION.

 
SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION

SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id;
Q29: Write a more efficient UNION ALL simulation of FULL OUTER JOIN that avoids duplicate rows.

 
SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION ALL

SELECT e.employee_id, e.first_name, p.project_id, p.project_name
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;  -- Exclude duplicates from LEFT JOIN
Q30: Write a FULL OUTER JOIN simulation that adds a join status column (Match / Only Employee / Only Project).

 
SELECT 
    e.employee_id AS emp_id,
    e.first_name,
    p.project_id,
    p.project_name,
    CASE 
        WHEN e.employee_id IS NOT NULL AND p.project_id IS NOT NULL THEN 'Match'
        WHEN e.employee_id IS NOT NULL THEN 'Only Employee'
        ELSE 'Only Project'
    END AS join_status
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id

UNION

SELECT 
    e.employee_id,
    e.first_name,
    p.project_id,
    p.project_name,
    CASE 
        WHEN e.employee_id IS NOT NULL AND p.project_id IS NOT NULL THEN 'Match'
        WHEN e.employee_id IS NOT NULL THEN 'Only Employee'
        ELSE 'Only Project'
    END
FROM employees e
RIGHT JOIN projects p ON e.employee_id = p.employee_id
WHERE e.employee_id IS NULL;  -- Avoid duplicates
LEVEL 6: CROSS JOIN – QUESTIONS & SOLUTIONS
Q31: What is a CROSS JOIN? Write a basic example that returns every combination of employee and project.
A CROSS JOIN returns the Cartesian product (every row from left table × every row from right table).

 
SELECT e.first_name, p.project_name
FROM employees e
CROSS JOIN projects p;
Q32: Show an old‑style (implicit) CROSS JOIN that simulates an INNER JOIN using a WHERE clause. Why should this approach be avoided?

 
SELECT e.first_name, p.project_name
FROM employees e, projects p
WHERE e.employee_id = p.employee_id;  -- This is actually an INNER JOIN
Avoid because it’s less explicit and easy to miss the join condition. Use explicit INNER JOIN instead.

Q33: Write a CROSS JOIN that generates all combinations of years and months for test data.

 
CREATE TEMPORARY TABLE years (year INT);
CREATE TEMPORARY TABLE months (month INT);
INSERT INTO years VALUES (2023), (2024);
INSERT INTO months VALUES (1,2,3,4,5,6,7,8,9,10,11,12);

SELECT y.year, m.month
FROM years y
CROSS JOIN months m
ORDER BY y.year, m.month;
Q34: Use a CROSS JOIN to calculate each employee’s salary as a percentage of total company payroll.

 
SELECT e.first_name, e.salary,
       e.salary / total.total_salary * 100 AS percentage
FROM employees e
CROSS JOIN (SELECT SUM(salary) AS total_salary FROM employees) total;
Q35: What is a major performance concern with CROSS JOIN? Provide a warning example.
CROSS JOIN can be very expensive (e.g., 10,000 × 10,000 = 100 million rows). Always consider if really needed.

LEVEL 7: SELF JOIN – QUESTIONS & SOLUTIONS
Q36: Write a basic self INNER JOIN that finds colleagues (pairs of employees) in the same department, excluding the same employee.

 
SELECT e1.first_name AS employee, e2.first_name AS colleague, e1.department
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE e1.employee_id != e2.employee_id;
Q37: Write a self LEFT JOIN that displays each employee and their manager’s name.

 
SELECT e1.first_name AS employee, 
       e2.first_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;
Q38: Write a self INNER JOIN that finds employees with salary higher than another employee in the same department.

 
SELECT e1.first_name AS employee1, e1.salary AS salary1,
       e2.first_name AS employee2, e2.salary AS salary2
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE e1.salary > e2.salary AND e1.employee_id != e2.employee_id;
Q39: Write a self JOIN that finds duplicate emails (assuming the column exists).

 
SELECT e1.employee_id, e1.email, e2.employee_id
FROM employees e1
INNER JOIN employees e2 ON e1.email = e2.email
WHERE e1.employee_id < e2.employee_id;
Q40: Write a self JOIN with aggregation that compares each employee’s salary to the average salary of their department.

 
SELECT e1.first_name, e1.salary, AVG(e2.salary) AS dept_avg
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
GROUP BY e1.employee_id, e1.first_name, e1.salary;
Q41: Write a self JOIN that finds employees hired within 30 days of each other in the same department.

 
SELECT e1.first_name, e1.hire_date,
       e2.first_name, e2.hire_date,
       DATEDIFF(e2.hire_date, e1.hire_date) AS days_diff
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department
WHERE DATEDIFF(e2.hire_date, e1.hire_date) BETWEEN 1 AND 30;
Q42: Write a self JOIN that finds the next hire date for each employee in the company.

 
SELECT e1.first_name, e1.hire_date,
       MIN(e2.hire_date) AS next_hire_date
FROM employees e1
LEFT JOIN employees e2 ON e2.hire_date > e1.hire_date
GROUP BY e1.employee_id, e1.first_name, e1.hire_date;
LEVEL 8: NATURAL JOIN (Use with Caution) – QUESTIONS & SOLUTIONS
Q43: Write a basic NATURAL JOIN. What is the main risk?

 
SELECT * FROM employees
NATURAL JOIN departments;  -- Joins on any columns with same name (e.g., department)
Main risk: You don’t know which columns will be used; schema changes break queries silently.

Q44: Why do most coding standards prohibit NATURAL JOIN?

Unintentional join columns

Schema changes break queries silently

Not explicit – hard to maintain

Better to use explicit INNER/LEFT JOIN with ON clause.

LEVEL 9: JOIN WITH CLAUSES – QUESTIONS & SOLUTIONS
Q45: Write a JOIN with a WHERE clause that filters both tables.

 
SELECT e.first_name, e.last_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE e.salary > 60000 AND p.budget < 50000;
Q46: Explain the difference between placing a condition in the ON clause vs the WHERE clause of an OUTER JOIN. Provide an example that shows the pitfall.
Condition in ON (evaluated before JOIN) keeps all left rows:

 
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;
Condition in WHERE (evaluated after JOIN) can convert OUTER JOIN to INNER JOIN:

 
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;  -- Filters out NULLs, effectively becomes INNER JOIN
Q47: Write a JOIN with ORDER BY that sorts by department budget descending, then employee salary descending.

 
SELECT e.first_name, e.salary, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
ORDER BY d.budget DESC, e.salary DESC;
Q48: Write a JOIN with GROUP BY that counts employees per department, including departments with no employees.

 
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;
Q49: Write a JOIN with HAVING that filters departments with more than 2 employees.

 
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count, AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name
HAVING COUNT(e.employee_id) > 2;
Q50: Write a JOIN with DISTINCT to remove duplicates caused by multiple matches.

 
SELECT DISTINCT e.department, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
LEVEL 10: COMPLEX JOIN CONDITIONS – QUESTIONS & SOLUTIONS
Q51: Write a non‑equi JOIN that finds employees with salary greater than their department’s average salary.

 
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department = e.department);
Q52: Write a JOIN with BETWEEN that links employees to projects that started within 2 years of their hire date.

 
SELECT e.first_name, e.hire_date, p.project_name, p.start_date
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE YEAR(p.start_date) BETWEEN YEAR(e.hire_date) AND YEAR(e.hire_date) + 2;
Q53: Write a JOIN using LIKE pattern matching to join departments and projects with similar names.

 
SELECT d.dept_name, p.project_name
FROM departments d
INNER JOIN projects p ON p.project_name LIKE CONCAT('%', d.dept_name, '%');
Q54: Write a query using EXISTS to find departments that have at least one employee.

 
SELECT d.dept_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);
Q55: Write a query using NOT EXISTS to find departments with no employees.

 
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);
Q56: Write a JOIN with a date range condition that finds projects overlapping with an employee’s first hire anniversary.

 
SELECT e.first_name, e.hire_date, p.project_name, p.start_date, p.end_date
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
WHERE DATE_ADD(e.hire_date, INTERVAL 1 YEAR) BETWEEN p.start_date AND p.end_date;
Q57: Write a JOIN with OR conditions to find employees who either manage a department OR lead a project.

 
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
LEFT JOIN departments d ON e.employee_id = d.manager_id
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE d.manager_id IS NOT NULL OR p.employee_id IS NOT NULL;
LEVEL 11: JOINS WITH MULTIPLE TABLES – QUESTIONS & SOLUTIONS
Q58: Write a 3‑table INNER JOIN connecting employees → departments → projects.

 
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
Q59: Write a 4‑table join that includes the manager name from the employees table as a dimension.

 
SELECT e.first_name, d.dept_name, p.project_name, m.first_name AS manager_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN employees m ON d.manager_id = m.employee_id;
Q60: Describe a star schema join between a fact table (projects) and dimension tables (employees, departments). Provide the  .

 
SELECT 
    f.project_name,
    f.budget AS fact_budget,
    d.dept_name,
    d.budget AS dept_budget,
    e.first_name,
    e.salary
FROM projects f
INNER JOIN employees e ON f.employee_id = e.employee_id
INNER JOIN departments d ON e.department = d.dept_name;
Q61: Write a many‑to‑many join using a bridge table employee_projects.

 
SELECT e.first_name, p.project_name, ep.role
FROM employees e
INNER JOIN employee_projects ep ON e.employee_id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.project_id;
Q62: Explain why the order of LEFT JOINs matters. Show an example where an INNER JOIN after a LEFT JOIN can accidentally filter out rows, and how to fix it.
Order matters:

 
-- This INNER JOIN will filter out employees with no projects
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;

-- Fix by placing LEFT JOIN at the end
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
LEFT JOIN departments d ON e.department = d.dept_name;
LEVEL 12: JOINS WITH AGGREGATIONS – QUESTIONS & SOLUTIONS
Q63: Write a JOIN with COUNT to get the number of employees per department (including departments with no employees).

 
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;
Q64: Write a JOIN with SUM to calculate total salary expense per department.

 
SELECT d.dept_name, SUM(e.salary) AS total_salary_expense
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;
Q65: Write a JOIN with AVG, MIN, and MAX to show salary statistics per department.

 
SELECT d.dept_name, 
       AVG(e.salary) AS average_salary,
       MIN(e.salary) AS min_salary,
       MAX(e.salary) AS max_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;
Q66: Write a query with multiple aggregations (COUNT, SUM, AVG) across two joined tables, using DISTINCT to avoid double‑counting.

 
SELECT 
    d.dept_name,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    COUNT(p.project_id) AS project_count,
    SUM(e.salary) AS total_salary,
    AVG(p.budget) AS avg_project_budget
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;
Q67: Write a JOIN with HAVING to find departments where total salary exceeds 150,000.

 
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name
HAVING SUM(e.salary) > 150000;
Q68: Show three different ways to avoid double‑counting when joining a one‑to‑many relationship with another one‑to‑many relationship: using DISTINCT, using subqueries, and aggregating before joining.
Using DISTINCT:

 
SELECT d.dept_name, COUNT(DISTINCT e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;
Aggregating before joining (best):

 
SELECT 
    d.dept_name,
    emp.employee_count,
    proj.project_count
FROM departments d
LEFT JOIN (SELECT department, COUNT(*) AS employee_count 
           FROM employees GROUP BY department) emp 
    ON d.dept_name = emp.department
LEFT JOIN (SELECT e.department, COUNT(*) AS project_count
           FROM projects p
           INNER JOIN employees e ON p.employee_id = e.employee_id
           GROUP BY e.department) proj 
    ON d.dept_name = proj.department;
Q69: Compare aggregating before JOIN vs aggregating after JOIN with an example.
Aggregate BEFORE JOIN (more efficient):

 
SELECT d.dept_name, emp_stats.avg_salary
FROM departments d
INNER JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) emp_stats ON d.dept_name = emp_stats.department;
Aggregate AFTER JOIN (can be less efficient):

 
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name;
Q70: Write a JOIN with ROLLUP to show subtotals and grand totals per department and manager status.

 
SELECT 
    COALESCE(d.dept_name, 'All Departments') AS department,
    COALESCE(e.is_manager, 'All Types') AS is_manager,
    COUNT(e.employee_id) AS employee_count,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_name, e.is_manager WITH ROLLUP;
LEVEL 13: JOINS WITH SUBQUERIES – QUESTIONS & SOLUTIONS
Q71: Write a JOIN that uses a derived table (subquery in FROM clause) to get department average salary and then join with employees.

 
SELECT e.first_name, dept_stats.avg_salary
FROM employees e
INNER JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) dept_stats ON e.department = dept_stats.department;
Q72: Write a query using two derived tables (department stats and project stats) and join them to departments.

 
SELECT 
    e.first_name,
    e.salary,
    dept_stats.avg_salary,
    dept_stats.total_salary,
    proj_stats.project_count
FROM employees e
INNER JOIN (
    SELECT department, 
           AVG(salary) AS avg_salary,
           SUM(salary) AS total_salary
    FROM employees
    GROUP BY department
) dept_stats ON e.department = dept_stats.department
LEFT JOIN (
    SELECT e.department, COUNT(*) AS project_count
    FROM projects p
    INNER JOIN employees e ON p.employee_id = e.employee_id
    GROUP BY e.department
) proj_stats ON e.department = proj_stats.department;
Q73: Rewrite the previous query using CTEs (Common Table Expressions) for better readability.

 
WITH dept_stats AS (
    SELECT department, 
           AVG(salary) AS avg_salary,
           COUNT(*) AS emp_count
    FROM employees
    GROUP BY department
),
proj_stats AS (
    SELECT e.department, COUNT(*) AS project_count
    FROM projects p
    INNER JOIN employees e ON p.employee_id = e.employee_id
    GROUP BY e.department
)
SELECT d.dept_name, 
       ds.emp_count,
       ds.avg_salary,
       COALESCE(ps.project_count, 0) AS project_count
FROM departments d
LEFT JOIN dept_stats ds ON d.dept_name = ds.department
LEFT JOIN proj_stats ps ON d.dept_name = ps.department;
Q74: Write a query using a scalar subquery in the SELECT clause to show each employee’s salary alongside their department average.

 
SELECT e.first_name, 
       e.salary,
       (SELECT AVG(salary) FROM employees WHERE department = e.department) AS dept_avg
FROM employees e;
Q75: Compare using EXISTS vs INNER JOIN to find departments with at least one employee. Provide both versions.
EXISTS (often more efficient):

 
SELECT d.dept_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);
Equivalent INNER JOIN:

 
SELECT DISTINCT d.dept_name
FROM departments d
INNER JOIN employees e ON d.dept_name = e.department;
Q76: Compare NOT EXISTS vs LEFT JOIN with NULL check for finding departments with no employees.
NOT EXISTS:

 
SELECT d.dept_name
FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department = d.dept_name);
LEFT JOIN with NULL check:

 
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
WHERE e.employee_id IS NULL;
Q77: When should you use IN vs JOIN? Provide an example where IN might be better.
IN is good for small lists. Example:

 
SELECT * FROM employees 
WHERE department IN ('Sales', 'Marketing', 'IT');
JOIN is better for large datasets:

 
SELECT e.*
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE d.dept_name IN ('Sales', 'Marketing', 'IT');
LEVEL 14: SPECIALIZED JOINS – QUESTIONS & SOLUTIONS
Q78: What is an ANTI JOIN? Write an example finding employees who never worked on any project.

 
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.project_id IS NULL;
Q79: What is a SEMI JOIN? Write an example finding employees who have at least one project, using EXISTS (more efficient).

 
SELECT e.first_name, e.last_name
FROM employees e
WHERE EXISTS (SELECT 1 FROM projects p WHERE p.employee_id = e.employee_id);
Q80: Write a Theta JOIN (non‑equality) that finds employees with salary greater than the department average.

 
SELECT e.first_name, e.salary, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.salary > (SELECT AVG(salary) FROM employees WHERE department = e.department);
Q81: Compare an Equi JOIN and a Theta JOIN with examples.
Equi JOIN (equality):

 
SELECT * FROM employees e INNER JOIN departments d ON e.department = d.dept_name;
Theta JOIN (non‑equality):

 
SELECT * FROM employees e INNER JOIN departments d ON e.salary < d.budget;
Q82: Write a recursive CTE (My  8.0+) to show the employee hierarchy (org chart).

 
WITH RECURSIVE employee_hierarchy AS (
    -- Anchor member: top-level employees (managers)
    SELECT employee_id, first_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: employees reporting to others
    SELECT e.employee_id, e.first_name, e.manager_id, h.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM employee_hierarchy ORDER BY level, employee_id;
Q83: Write a temporal JOIN that gets the salary applicable at the start date of a project, using a salary_history table.
Assume table salary_history (employee_id, salary, effective_date, end_date).

 
SELECT e.first_name, p.project_name, p.start_date, sh.salary
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id
INNER JOIN salary_history sh ON e.employee_id = sh.employee_id
    AND p.start_date BETWEEN sh.effective_date AND sh.end_date;
Q84: Write a fuzzy JOIN using LIKE to match employee notes with project names.

 
SELECT e.first_name, d.dept_name
FROM employees e
CROSS JOIN departments d
WHERE e.department LIKE CONCAT('%', SUBSTRING(d.dept_name, 1, 3), '%');
LEVEL 15: PERFORMANCE OPTIMIZATION – QUESTIONS & SOLUTIONS
Q85: What indexes should you create to optimize the joins between employees, departments, and projects?

 
CREATE INDEX idx_emp_department ON employees(department);
CREATE INDEX idx_dept_name ON departments(dept_name);
CREATE INDEX idx_proj_employee ON projects(employee_id);
Q86: How can you influence join order in My  (force the optimizer to join smaller table first)?
Use STRAIGHT_JOIN:

 
SELECT STRAIGHT_JOIN e.first_name, d.dept_name
FROM departments d  -- Smaller table first
INNER JOIN employees e ON d.dept_name = e.department;
Q87: Write a query that forces a hash join in My  8.0+ using a hint.

 
SELECT /*+ HASH_JOIN(e, d) */ e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q88: How do you analyze the execution plan of a join query? Provide an example.

 
EXPLAIN FORMAT=JSON
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q89: What command updates table statistics to help the optimizer with join cardinality estimation?

 
ANALYZE TABLE employees;
ANALYZE TABLE departments;
Q90: Write   to create a materialized view (summary table) for a common join between employees and departments.

 
CREATE TABLE emp_dept_summary AS
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
-- Refresh periodically
TRUNCATE TABLE emp_dept_summary;
INSERT INTO emp_dept_summary
SELECT e.employee_id, e.first_name, e.last_name, d.dept_name, d.budget
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q91: Write a denormalized table (pre‑joined) for faster reads, showing the trade‑off.

 
CREATE TABLE emp_dept_denormalized AS
SELECT e.*, d.budget AS dept_budget, d.location
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name;
Trade‑off: faster reads, slower writes, more storage.

Q92: Write a batched (chunked) join query to process large datasets in portions.

 
SELECT * FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE e.employee_id BETWEEN 1 AND 1000;
LEVEL 16: JOIN PITFALLS & COMMON ERRORS – QUESTIONS & SOLUTIONS
Q93: What happens when you forget the JOIN condition? Show the bad and good version.
BAD (Cartesian product):

 
SELECT e.first_name, d.dept_name
FROM employees e, departments d;
GOOD (proper join condition):

 
SELECT e.first_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q94: Show an example where double‑counting occurs in a one‑to‑many‑to‑many join and how to fix it with DISTINCT.
BAD (counts employees multiple times due to projects):

 
SELECT d.dept_name, COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;
FIX with DISTINCT:

 
SELECT d.dept_name, COUNT(DISTINCT e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
LEFT JOIN projects p ON e.employee_id = p.employee_id
GROUP BY d.dept_id, d.dept_name;
Q95: Why does NULL in a join condition cause problems? Write an example showing that employees with NULL department won’t match.

 
SELECT * FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name AND d.budget IS NOT NULL;
-- Employees with NULL department won't match
Fix: handle NULL explicitly:

 
SELECT * FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
WHERE e.department IS NOT NULL;
Q96: Show the consequence of using INNER JOIN instead of LEFT JOIN when you need to keep all rows from one side.
BAD (excludes employees without projects):

 
SELECT e.first_name, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id;
GOOD (includes all employees):

 
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id;
Q97: Write an example of ambiguous column names and how to resolve them with table aliases.
BAD:

 
SELECT employee_id, first_name, department
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;  -- department is ambiguous
GOOD:

 
SELECT e.employee_id, e.first_name, e.department
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q98: What performance issue arises when using functions like UPPER() in a JOIN condition? How can it be fixed?
Functions on columns prevent index usage. Fix by storing normalized data or using generated columns:

 
ALTER TABLE employees ADD COLUMN department_upper VARCHAR(50) 
GENERATED ALWAYS AS (UPPER(department)) STORED;
CREATE INDEX idx_department_upper ON employees(department_upper);
Q99: Write a query that incorrectly uses an INNER JOIN after a LEFT JOIN, nullifying the LEFT JOIN. Show the corrected version.
BAD (INNER JOIN filters out employees without projects):

 
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
INNER JOIN projects p ON e.employee_id = p.employee_id;
GOOD (keep LEFT JOIN consistent):

 
SELECT e.first_name, d.dept_name, p.project_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name
LEFT JOIN projects p ON e.employee_id = p.employee_id;
Q100: Show how a WHERE clause on the right table can convert a LEFT JOIN into an INNER JOIN. Provide the correct alternative.
BAD (filters out employees with NULL projects):

 
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id
WHERE p.budget > 50000;
GOOD (put filter in ON clause):

 
SELECT e.first_name, p.project_name
FROM employees e
LEFT JOIN projects p ON e.employee_id = p.employee_id AND p.budget > 50000;
LEVEL 17: DATABASE-SPECIFIC JOINS – QUESTIONS & SOLUTIONS
Q101: Write a STRAIGHT_JOIN in My  to force join order.

 
SELECT STRAIGHT_JOIN * FROM table1 t1
INNER JOIN table2 t2 ON t1.id = t2.id;
Q102: Show the USING clause and NATURAL JOIN in Postgre . Why is NATURAL JOIN risky?
USING clause:

 
SELECT * FROM employees e
INNER JOIN departments d USING (department);
NATURAL JOIN:

 
SELECT * FROM employees NATURAL JOIN departments;
Risky because it joins on all matching column names automatically; schema changes break queries.

Q103: Write a join hint in   Server to force a hash join.

 
SELECT * FROM employees e
INNER HASH JOIN departments d ON e.department = d.dept_name;
Q104: Show Oracle’s old (+) outer join syntax and the preferred ANSI equivalent.
Oracle old syntax (avoid):

 
SELECT e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.department = d.dept_name(+);
Preferred ANSI syntax:

 
SELECT e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.department = d.dept_name;
Q105: How do you join tables from different databases in My ?

 
SELECT * FROM company_db.employees e
INNER JOIN  _pract.departments d ON e.department = d.dept_name;
LEVEL 18: PRACTICAL BUSINESS SCENARIOS – QUESTIONS & SOLUTIONS
Q106: Write a query (e‑commerce) showing customer_name, order_count, and total_items, including customers with no orders.

 
SELECT c.customer_name, COUNT(o.order_id) AS order_count, SUM(od.quantity) AS total_items
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;
Q107: Write an HR query that shows department budget, total salary expense, and budget utilization percentage.

 
SELECT d.dept_name, d.budget, 
       SUM(e.salary) AS total_salary_expense,
       (SUM(e.salary) / d.budget) * 100 AS budget_utilization_pct
FROM departments d
LEFT JOIN employees e ON d.dept_name = e.department
GROUP BY d.dept_id, d.dept_name, d.budget;
Q108: Write a query for education domain: student_name, number of distinct courses taken, and average grade.

 
SELECT s.student_name, COUNT(DISTINCT c.course_id) AS courses_taken, AVG(e.grade) AS avg_grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
GROUP BY s.student_id, s.student_name;
Q109: Write a healthcare query: doctor_name, total appointments, unique patients for the current year.

 
SELECT d.doctor_name, COUNT(a.appointment_id) AS total_appointments, 
       COUNT(DISTINCT p.patient_id) AS unique_patients
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date >= '2024-01-01'
GROUP BY d.doctor_id, d.doctor_name;
Q110: Write an inventory query that finds slow‑moving products (no sales in last 90 days).

 
SELECT p.product_name, c.category_name, s.supplier_name,
       COALESCE(SUM(si.quantity), 0) AS total_sold
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
LEFT JOIN sales_items si ON p.product_id = si.product_id
LEFT JOIN sales sa ON si.sale_id = sa.sale_id AND sa.sale_date >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY p.product_id, p.product_name, c.category_name, s.supplier_name
HAVING total_sold = 0;
Q111: Write a banking query that finds accounts with unusual activity (>100 transactions or >100,000 total amount in last 7 days).

 
SELECT a.account_number, 
       COUNT(t.transaction_id) AS transaction_count,
       SUM(t.amount) AS total_amount,
       AVG(t.amount) AS avg_transaction
FROM accounts a
INNER JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY a.account_id, a.account_number
HAVING transaction_count > 100 OR total_amount > 100000;
Q112: Write a social media query that returns each post with its comment count and like count.

 
SELECT p.post_id, p.content, 
       COUNT(DISTINCT c.comment_id) AS comment_count,
       COUNT(DISTINCT l.like_id) AS like_count
FROM posts p
LEFT JOIN comments c ON p.post_id = c.post_id
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content;
Q113: Write a logistics query that finds delayed shipments (shipping > 5 days after order).

 
SELECT o.order_id, o.order_date, 
       p.payment_date, s.shipping_date,
       DATEDIFF(s.shipping_date, o.order_date) AS days_to_ship
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id
LEFT JOIN shipping s ON o.order_id = s.order_id
WHERE s.shipping_date > DATE_ADD(o.order_date, INTERVAL 5 DAY);
Q114: Write a project management query showing project completion percentage (tasks completed / total tasks).

 
SELECT p.project_name, 
       COUNT(t.task_id) AS total_tasks,
       SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks,
       ROUND(SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) / COUNT(t.task_id) * 100, 2) AS completion_pct
FROM projects p
LEFT JOIN tasks t ON p.project_id = t.project_id
GROUP BY p.project_id, p.project_name;
LEVEL 19: INTERVIEW-STYLE JOIN PROBLEMS – QUESTIONS & SOLUTIONS
Q115: Find employees without managers (manager_id is NULL).

 
SELECT e1.first_name AS employee
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IS NULL;
Q116: Find customers who never placed an order.

 
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
Q117: Find products never purchased.

 
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
Q118: Find the second highest salary per department.

 
SELECT e1.department, e1.first_name, e1.salary
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e1.salary <= e2.salary
GROUP BY e1.employee_id, e1.department, e1.first_name, e1.salary
HAVING COUNT(DISTINCT e2.salary) = 2;
Q119: Find overlapping date ranges (projects that overlap in time).

 
SELECT p1.project_name AS project1, p2.project_name AS project2,
       p1.start_date, p1.end_date, p2.start_date, p2.end_date
FROM projects p1
INNER JOIN projects p2 ON p1.project_id < p2.project_id
WHERE p1.start_date <= p2.end_date AND p1.end_date >= p2.start_date;
Q120: Find duplicate records using self join (employees with same first and last name).

 
SELECT e1.employee_id, e2.employee_id, e1.first_name, e1.last_name
FROM employees e1
INNER JOIN employees e2 ON e1.first_name = e2.first_name 
                        AND e1.last_name = e2.last_name
                        AND e1.employee_id < e2.employee_id;
Q121: Find cumulative sum (running total) of salaries per department using a self join.

 
SELECT e1.employee_id, e1.first_name, e1.salary, e1.department,
       SUM(e2.salary) AS running_total
FROM employees e1
INNER JOIN employees e2 ON e1.department = e2.department AND e2.employee_id <= e1.employee_id
GROUP BY e1.employee_id, e1.first_name, e1.salary, e1.department
ORDER BY e1.department, e1.employee_id;
Q122: Calculate each employee’s salary as a percentage of total company payroll using a CROSS JOIN.

 
SELECT e.first_name, e.salary, 
       e.salary / total.total_salary * 100 AS pct_of_total
FROM employees e
CROSS JOIN (SELECT SUM(salary) AS total_salary FROM employees) total;
Q123: Generate a series of all dates in 2024 using CROSS JOIN and number tables.

 
SELECT DATE('2024-01-01') + INTERVAL (a.n + b.n * 10) DAY AS date
FROM (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
      UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
CROSS JOIN (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) b
WHERE DATE('2024-01-01') + INTERVAL (a.n + b.n * 10) DAY <= '2024-12-31'
ORDER BY date;
Q124: Find the hierarchical path (org chart) using a recursive CTE.

 
WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, manager_id, 
           CAST(first_name AS CHAR(1000)) AS path, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.employee_id, e.first_name, e.manager_id,
           CONCAT(oc.path, ' -> ', e.first_name), oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart ORDER BY level, employee_id;
LEVEL 20: ADVANCED JOIN PATTERNS – QUESTIONS & SOLUTIONS
Q125: Write a JOIN on multiple columns (composite key) between employees and projects.

 
SELECT e.first_name, e.department, p.project_name
FROM employees e
INNER JOIN projects p ON e.employee_id = p.employee_id 
                      AND e.department = p.department;  -- If department column exists in projects
Q126: Write a JOIN on computed columns (rounded salary / 1000 vs rounded budget / 1000).

 
SELECT e.first_name, e.salary, d.dept_name
FROM employees e
INNER JOIN departments d ON ROUND(e.salary / 1000) = ROUND(d.budget / 1000);
Q127: Write a JOIN using LIKE pattern matching between employee notes and project names.

 
SELECT e.first_name, e.notes, p.project_name
FROM employees e
INNER JOIN projects p ON p.project_name LIKE CONCAT('%', SUBSTRING_INDEX(e.notes, ' ', 1), '%');
Q128: Write a JOIN using BETWEEN to assign salary grades from a salary_grades table.
Assuming salary_grades table exists:

 
SELECT e.first_name, e.salary, sg.grade_name
FROM employees e
INNER JOIN salary_grades sg ON e.salary BETWEEN sg.min_salary AND sg.max_salary;
Q129: Write a JOIN on a substring (email domain) to match department names.

 
SELECT e.first_name, e.email, d.dept_name
FROM employees e
INNER JOIN departments d ON SUBSTRING_INDEX(e.email, '@', -1) = CONCAT(d.dept_name, '.com');
Q130: Write a JOIN using date parts (month) to match employees hired in the same month as a project start.

 
SELECT e.first_name, e.hire_date, p.project_name, p.start_date
FROM employees e
INNER JOIN projects p ON MONTH(e.hire_date) = MONTH(p.start_date)
WHERE YEAR(p.start_date) = 2024;
Q131: Write a JOIN with a CASE expression to create a salary category column.

 
SELECT e.first_name, e.salary, d.dept_name, d.budget,
       CASE 
           WHEN e.salary > 70000 THEN 'High'
           WHEN e.salary > 50000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_category
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name;
Q132: Write a self JOIN with date gaps to find gaps in hire dates per department greater than 30 days.

 
SELECT e1.department, e1.first_name, e1.hire_date,
       MIN(e2.hire_date) AS next_hire_date,
       DATEDIFF(MIN(e2.hire_date), e1.hire_date) AS days_gap
FROM employees e1
LEFT JOIN employees e2 ON e1.department = e2.department AND e2.hire_date > e1.hire_date
GROUP BY e1.employee_id, e1.department, e1.first_name, e1.hire_date
HAVING days_gap > 30;
Q133: Write an asymmetric join that compares each employee’s salary to the department average using a derived table.

 
SELECT e.department, 
       e.first_name, 
       e.salary,
       dept_stats.avg_salary,
       e.salary - dept_stats.avg_salary AS salary_diff
FROM employees e
INNER JOIN (SELECT department, AVG(salary) AS avg_salary 
            FROM employees 
            GROUP BY department) dept_stats 
    ON e.department = dept_stats.department;
Q134: Write a semi‑join optimization using IN instead of JOIN for better performance with large datasets.

 
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.department IN (SELECT dept_name FROM departments WHERE budget > 200000);
Equivalent JOIN (may be slower):

 
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
INNER JOIN departments d ON e.department = d.dept_name
WHERE d.budget > 200000;

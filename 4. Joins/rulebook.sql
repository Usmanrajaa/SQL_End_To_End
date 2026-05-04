-- =========================================================
-- JOINS RULEBOOK - MASTER REFERENCE GUIDE
-- =========================================================

-- LEVEL 1: JOINS FUNDAMENTALS
-- 1.1 What is a JOIN?
-- 1.2 JOIN Syntax Structure
-- 1.3 JOIN Conditions (ON vs USING)
-- 1.4 JOIN Types Overview
-- 1.5 NULL Handling in Joins

-- LEVEL 2: INNER JOIN
-- 2.1 Basic INNER JOIN
-- 2.2 INNER JOIN with Multiple Conditions
-- 2.3 INNER JOIN with 3+ Tables
-- 2.4 INNER JOIN with WHERE Clause
-- 2.5 INNER JOIN with Aliases
-- 2.6 INNER JOIN vs Comma Join (Old Syntax)
-- 2.7 Self INNER JOIN
-- 2.8 Non-Equi INNER JOIN

-- LEVEL 3: LEFT JOIN (LEFT OUTER JOIN)
-- 3.1 Basic LEFT JOIN
-- 3.2 LEFT JOIN with WHERE (Filtering Right Table)
-- 3.3 LEFT JOIN to Find Missing Rows
-- 3.4 LEFT JOIN with Multiple Conditions
-- 3.5 LEFT JOIN with 3+ Tables
-- 3.6 LEFT JOIN with COALESCE
-- 3.7 LEFT JOIN with COUNT (Beware of NULLs)
-- 3.8 LEFT JOIN vs INNER JOIN Comparison

-- LEVEL 4: RIGHT JOIN (RIGHT OUTER JOIN)
-- 4.1 Basic RIGHT JOIN
-- 4.2 RIGHT JOIN Use Cases
-- 4.3 RIGHT JOIN vs LEFT JOIN (Convertibility)
-- 4.4 RIGHT JOIN with Multiple Tables
-- 4.5 When to Use RIGHT JOIN (Rare Cases)

-- LEVEL 5: FULL OUTER JOIN
-- 5.1 FULL OUTER JOIN Syntax (MySQL Workaround)
-- 5.2 FULL OUTER JOIN using UNION
-- 5.3 FULL OUTER JOIN using UNION ALL
-- 5.4 FULL OUTER JOIN with WHERE Filter
-- 5.5 FULL OUTER JOIN vs LEFT + RIGHT UNION
-- 5.6 Simulating FULL OUTER JOIN in MySQL

-- LEVEL 6: CROSS JOIN
-- 6.1 Basic CROSS JOIN (Cartesian Product)
-- 6.2 CROSS JOIN with WHERE (Simulates INNER JOIN)
-- 6.3 CROSS JOIN for Generating Test Data
-- 6.4 CROSS JOIN for Combinations
-- 6.5 CROSS JOIN with Aggregations
-- 6.6 CROSS JOIN Performance Considerations

-- LEVEL 7: SELF JOIN
-- 7.1 Basic Self Join
-- 7.2 Self Join for Hierarchical Data (Employee-Manager)
-- 7.3 Self Join for Comparing Rows
-- 7.4 Self Join for Finding Duplicates
-- 7.5 Self Join with Aggregation
-- 7.6 Self Join for Date Ranges
-- 7.7 Self Join for Sequential Data

-- LEVEL 8: NATURAL JOIN (Use with Caution)
-- 8.1 Basic NATURAL JOIN
-- 8.2 NATURAL JOIN Risks
-- 8.3 NATURAL LEFT JOIN
-- 8.4 NATURAL RIGHT JOIN
-- 8.5 Why Avoid NATURAL JOIN

-- LEVEL 9: JOIN WITH CLAUSES
-- 9.1 JOIN with WHERE
-- 9.2 JOIN with AND vs WHERE (Condition Placement)
-- 9.3 JOIN with ORDER BY
-- 9.4 JOIN with GROUP BY
-- 9.5 JOIN with HAVING
-- 9.6 JOIN with LIMIT
-- 9.7 JOIN with DISTINCT

-- LEVEL 10: COMPLEX JOIN CONDITIONS
-- 10.1 Non-Equi Joins (>, <, >=, <=, <>)
-- 10.2 JOIN with BETWEEN
-- 10.3 JOIN with LIKE Pattern Matching
-- 10.4 JOIN with IN
-- 10.5 JOIN with EXISTS/NOT EXISTS
-- 10.6 JOIN with Date Ranges
-- 10.7 JOIN with Multiple Conditions
-- 10.8 JOIN with OR Conditions

-- LEVEL 11: JOINS WITH MULTIPLE TABLES
-- 11.1 3-Table Join Patterns
-- 11.2 4+ Table Joins
-- 11.3 Star Schema Joins (Fact + Dimensions)
-- 11.4 Snowflake Schema Joins
-- 11.5 Many-to-Many Join Handling
-- 11.6 Circular Joins (Avoid)
-- 11.7 Chaining LEFT JOINs (Order Matters)

-- LEVEL 12: JOINS WITH AGGREGATIONS
-- 12.1 JOIN with COUNT
-- 12.2 JOIN with SUM
-- 12.3 JOIN with AVG
-- 12.4 JOIN with MIN/MAX
-- 12.5 JOIN with GROUP BY
-- 12.6 JOIN with HAVING
-- 12.7 Avoiding Double Counting in Aggregations
-- 12.8 Aggregating Before vs After JOIN
-- 12.9 JOIN with ROLLUP/CUBE


--   (Prerequisite->subqueries,cte,wf)

-- LEVEL 13: JOINS WITH SUBQUERIES
-- 13.1 Subquery in JOIN
-- 13.2 JOIN with Derived Tables
-- 13.3 JOIN with CTE (Common Table Expression)
-- 13.4 JOIN with Scalar Subquery
-- 13.5 EXISTS vs JOIN
-- 13.6 NOT EXISTS vs LEFT JOIN WHERE NULL
-- 13.7 IN vs JOIN Performance

-- LEVEL 14: SPECIALIZED JOINS
-- 14.1 ANTI JOIN (Finding Non-Matches)
-- 14.2 SEMI JOIN (Finding Matches Without Duplicates)
-- 14.3 Theta Join
-- 14.4 Equi Join vs Theta Join
-- 14.5 Recursive Joins (Hierarchy Queries)
-- 14.6 Temporal Joins (Effective Date Ranges)
-- 14.7 Fuzzy Joins (Similarity Matching)

-- LEVEL 15: PERFORMANCE OPTIMIZATION
-- 15.1 Indexing for Joins
-- 15.2 Join Order (Smallest Table First)
-- 15.3 Join Algorithms (Nested Loop, Hash, Merge)
-- 15.4 EXPLAIN ANALYZE for Joins
-- 15.5 Avoiding Cartesian Products
-- 15.6 Join Cardinality Estimation
-- 15.7 Materialized Views for Complex Joins
-- 15.8 Denormalization vs Joins
-- 15.9 Batch Joining for Large Datasets
-- 15.10 Partitioned Table Joins

-- LEVEL 16: JOIN PITFALLS & COMMON ERRORS
-- 16.1 Cartesian Product (Missing JOIN Condition)
-- 16.2 Double Counting in One-to-Many Joins
-- 16.3 NULL Handling in JOIN Conditions
-- 16.4 Incorrect JOIN Type Selection
-- 16.5 Ambiguous Column Names
-- 16.6 JOIN Condition Data Type Mismatch
-- 16.7 Performance Issues with OR in JOIN
-- 16.8 Functions in JOIN Conditions
-- 16.9 Implicit JOIN vs Explicit JOIN
-- 16.10 Chained LEFT JOIN Misunderstandings
-- 16.11 WHERE Clause Nullifying OUTER JOIN
-- 16.12 Duplicate Rows from Multiple Joins

-- LEVEL 17: DATABASE-SPECIFIC JOINS
-- 17.1 MySQL Joins (Default)
-- 17.2 PostgreSQL Joins (USING, NATURAL)
-- 17.3 SQL Server Joins (HASH, MERGE hints)
-- 17.4 Oracle Joins (+ syntax, ANSI)
-- 17.5 Cross-Database Joins
-- 17.6 Federated Table Joins

-- LEVEL 18: PRACTICAL BUSINESS SCENARIOS
-- 18.1 Customer-Orders-Products (E-commerce)
-- 18.2 Employees-Departments-Salaries (HR)
-- 18.3 Students-Courses-Enrollments (Education)
-- 18.4 Doctors-Appointments-Patients (Healthcare)
-- 18.5 Products-Categories-Suppliers (Inventory)
-- 18.6 Users-Logs-Sessions (Analytics)
-- 18.7 Accounts-Transactions (Banking)
-- 18.8 Posts-Comments-Likes (Social Media)
-- 18.9 Orders-Payments-Shipping (Logistics)
-- 18.10 Projects-Tasks-Assignees (Project Management)

-- LEVEL 19: INTERVIEW-STYLE JOIN PROBLEMS
-- 19.1 Find employees without managers
-- 19.2 Find customers who never ordered
-- 19.3 Find products never purchased
-- 19.4 Find the second highest salary per department
-- 19.5 Find overlapping date ranges
-- 19.6 Find duplicate records using self join
-- 19.7 Find cumulative sum with self join
-- 19.8 Find percentage of total using cross join
-- 19.9 Generate date series with cross join
-- 19.10 Find hierarchical path (org chart)

-- LEVEL 20: ADVANCED JOIN PATTERNS
-- 20.1 Joining on Multiple Columns
-- 20.2 Joining on Computed Columns
-- 20.3 Joining on LIKE Pattern
-- 20.4 Joining on Range (BETWEEN)
-- 20.5 Joining on Substring
-- 20.6 Joining with Date Parts
-- 20.7 Joining with CASE Expressions
-- 20.8 Self Join with Date Gaps
-- 20.9 Asymmetric Joins
-- 20.10 Semi-join Optimization
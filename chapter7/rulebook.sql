-- =========================================================
-- SQL SUBQUERIES RULEBOOK - MASTER REFERENCE GUIDE
-- =========================================================

-- LEVEL 1: SUBQUERY FUNDAMENTALS
-- 1.1 What is a Subquery?
-- 1.2 Subquery Syntax Structure
-- 1.3 Subquery Types Overview
-- 1.4 Where Subqueries Can Be Used
-- 1.5 Subquery Execution Order

-- LEVEL 2: SCALAR SUBQUERIES (Single Row, Single Column)
-- 2.1 Scalar Subquery in SELECT Clause
-- 2.2 Scalar Subquery in WHERE Clause
-- 2.3 Scalar Subquery in HAVING Clause
-- 2.4 Scalar Subquery in ORDER BY
-- 2.5 Scalar Subquery with Aggregate Functions
-- 2.6 Handling NULL in Scalar Subqueries

-- LEVEL 3: ROW SUBQUERIES (Single Row, Multiple Columns)
-- 3.1 Row Constructor Comparison
-- 3.2 Row Subquery in WHERE Clause
-- 3.3 Row Subquery with IN/NOT IN
-- 3.4 Row Subquery with EXISTS

-- LEVEL 4: TABLE SUBQUERIES (Multiple Rows, Multiple Columns)
-- 4.1 Table Subquery in FROM Clause (Derived Table)
-- 4.2 Table Subquery with JOIN
-- 4.3 Table Subquery in WITH Clause (CTE)
-- 4.4 Table Subquery with GROUP BY
-- 4.5 Nested Table Subqueries

-- LEVEL 5: CORRELATED SUBQUERIES
-- 5.1 What Makes a Subquery Correlated?
-- 5.2 Correlated Subquery in WHERE Clause
-- 5.3 Correlated Subquery in SELECT Clause
-- 5.4 Correlated Subquery with EXISTS
-- 5.5 Correlated Subquery with NOT EXISTS
-- 5.6 Correlated Subquery Performance
-- 5.7 Correlated vs Non-Correlated Comparison

-- LEVEL 6: EXISTS & NOT EXISTS SUBQUERIES
-- 6.1 Basic EXISTS Syntax
-- 6.2 EXISTS with Correlated Subquery
-- 6.3 NOT EXISTS for Finding Missing Rows
-- 6.4 EXISTS vs IN Performance
-- 6.5 EXISTS vs JOIN Comparison
-- 6.6 Double NOT EXISTS (Division in SQL)

-- LEVEL 7: IN & NOT IN SUBQUERIES
-- 7.1 Basic IN Subquery
-- 7.2 NOT IN Subquery
-- 7.3 IN with Multiple Columns
-- 7.4 IN with Subquery vs VALUES List
-- 7.5 NULL Handling in IN/NOT IN (Critical!)
-- 7.6 IN vs EXISTS vs JOIN

-- LEVEL 8: ANY, SOME, ALL SUBQUERIES
-- 8.1 ANY / SOME Operator
-- 8.2 ALL Operator
-- 8.3 Comparison with ANY/ALL (>ANY, <ALL, etc.)
-- 8.4 ANY vs IN
-- 8.5 ALL vs MAX/MIN
-- 8.6 Practical ANY/ALL Examples

-- LEVEL 9: SUBQUERIES IN DML (Data Modification)
-- 9.1 Subquery in INSERT
-- 9.2 Subquery in UPDATE
-- 9.3 Subquery in DELETE
-- 9.4 Subquery with MERGE/UPSERT
-- 9.5 Correlated Updates

-- LEVEL 10: ADVANCED SUBQUERY PATTERNS
-- 10.1 Subquery with JOINs
-- 10.2 Nested Subqueries (Subquery in Subquery)
-- 10.3 Subquery with Window Functions
-- 10.4 Subquery with CASE Expressions
-- 10.5 Subquery with GROUP BY and HAVING
-- 10.6 Subquery with LIMIT/TOP
-- 10.7 Lateral Subqueries (LATERAL JOIN)

-- LEVEL 11: COMMON SUBQUERY SCENARIOS
-- 11.1 Find Above Average Records
-- 11.2 Find Top N Per Group
-- 11.3 Find Duplicate Records
-- 11.4 Find Missing Records
-- 11.5 Compare with Previous/Next Record
-- 11.6 Running Totals with Subquery
-- 11.7 Hierarchical Queries with Subqueries

-- LEVEL 12: PERFORMANCE & OPTIMIZATION
-- 12.1 Subquery vs JOIN Performance
-- 12.2 Subquery vs CTE Performance
-- 12.3 Correlated Subquery Optimization
-- 12.4 EXISTS vs IN Performance Guidelines
-- 12.5 Subquery Flattening
-- 12.6 Materialized Subqueries
-- 12.7 EXPLAIN for Subqueries

-- LEVEL 13: PITFALLS & COMMON ERRORS
-- 13.1 Subquery Returns Multiple Rows (Scalar Error)
-- 13.2 NULL in NOT IN Subquery
-- 13.3 Correlated Subquery Without Alias
-- 13.4 Performance with Large Result Sets
-- 13.5 Subquery in SELECT Causing N+1 Problem
-- 13.6 Forgetting to Alias Derived Tables
-- 13.7 Ambiguous Column References
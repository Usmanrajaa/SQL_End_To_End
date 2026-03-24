-- =========================================================
-- AGGREGATION CLAUSES RULEBOOK
-- =========================================================

-- LEVEL 1: BASIC AGGREGATE FUNCTIONS
-- 1. COUNT
-- 2. SUM
-- 3. AVG
-- 4. MIN
-- 5. MAX

-- LEVEL 2: GROUP BY CLAUSE
-- 1. Single Column GROUP BY
-- 2. Multiple Columns GROUP BY
-- 3. GROUP BY with Expressions
-- 4. GROUP BY with ORDER BY
-- 5. GROUP BY with WHERE

-- LEVEL 3: HAVING CLAUSE
-- 1. Basic HAVING
-- 2. HAVING with Aggregate Conditions
-- 3. HAVING with Multiple Conditions
-- 4. WHERE vs HAVING (Combined)
-- 5. HAVING with Subqueries

-- LEVEL 4: ADVANCED AGGREGATE FUNCTIONS
-- 1. GROUP_CONCAT / STRING_AGG
-- 2. STDDEV / VARIANCE
-- 3. MEDIAN / PERCENTILE
-- 4. Multiple Aggregates Combined

-- LEVEL 5: CONDITIONAL AGGREGATION
-- 1. COUNT with CASE
-- 2. SUM with CASE
-- 3. AVG with CASE
-- 4. Percentage Calculations with CASE
-- 5. Pivot-style Aggregation

-- LEVEL 6: ROLLUP, CUBE & GROUPING SETS
-- 1. WITH ROLLUP
-- 2. WITH CUBE
-- 3. GROUPING SETS
-- 4. GROUPING Function
-- 5. Subtotals & Grand Totals

-- LEVEL 7: AGGREGATION WITH JOINS
-- 1. Single Join Aggregation
-- 2. Multiple Joins Aggregation
-- 3. LEFT JOIN Aggregation
-- 4. Aggregation with Self Join
-- 5. Aggregation with Subqueries

-- LEVEL 8: WINDOW FUNCTIONS (Analytic Aggregation)
-- 1. OVER() Clause
-- 2. PARTITION BY
-- 3. ROW_NUMBER, RANK, DENSE_RANK
-- 4. LEAD, LAG
-- 5. Running Totals with SUM OVER
-- 6. Moving Averages with AVG OVER
-- 7. NTILE

-- LEVEL 9: AGGREGATION SCENARIOS
-- 1. Department-wise Aggregates
-- 2. Year-over-Year Aggregates
-- 3. Hierarchical Aggregates
-- 4. Time-based Aggregates
-- 5. Percentage of Total
-- 6. Cumulative Aggregates
-- 7. Comparative Aggregates (vs Company Avg)

-- LEVEL 10: PERFORMANCE & OPTIMIZATION
-- 1. Indexing for Aggregation
-- 2. Filter Early (WHERE before GROUP BY)
-- 3. Avoid Functions in GROUP BY
-- 4. Temp Tables for Complex Aggregations
-- 5. Materialized Views
-- 6. EXPLAIN for Aggregation Queries
-- 7. Batch Processing for Large Datasets

-- LEVEL 11: COMMON PITFALLS
-- 1. Non-aggregated Columns without GROUP BY
-- 2. WHERE vs HAVING Misuse
-- 3. NULL Handling in Aggregates
-- 4. Cartesian Product in Joined Aggregations
-- 5. ORDER BY with Non-aggregated Columns
-- 6. Double Counting in JOIN Aggregations
-- 7. Floating Point Precision Issues

-- LEVEL 12: ADVANCED SCENARIOS (Interview Style)
-- 1. Top N Per Group
-- 2. Find Duplicates with Aggregation
-- 3. Gap Analysis with Aggregates
-- 4. Cohort Analysis
-- 5. Retention Analysis
-- 6. Funnel Analysis
-- 7. Sessionization with Aggregates
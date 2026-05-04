-- =========================================================
-- VIEWS & INDEXES RULEBOOK - MASTER REFERENCE GUIDE
-- =========================================================

-- LEVEL 1: VIEWS FUNDAMENTALS
-- 1.1 What is a View?
-- 1.2 View Syntax Structure
-- 1.3 Types of Views
-- 1.4 View Security & Benefits
-- 1.5 View Limitations

-- LEVEL 2: CREATE VIEW
-- 2.1 Basic View Creation
-- 2.2 View with Specific Columns
-- 2.3 View with WHERE Clause
-- 2.4 View with JOINs
-- 2.5 View with Aggregations
-- 2.6 View with Subqueries
-- 2.7 View with Calculated Columns
-- 2.8 View with Aliases

-- LEVEL 3: MODIFY VIEWS
-- 3.1 CREATE OR REPLACE VIEW
-- 3.2 ALTER VIEW (Rename, Set Options)
-- 3.3 DROP VIEW
-- 3.4 Temporary Views
-- 3.5 Materialized Views (PostgreSQL)

-- LEVEL 4: VIEW WITH JOINS & COMPLEX QUERIES
-- 4.1 View with Multiple JOINs
-- 4.2 View with LEFT/RIGHT JOINs
-- 4.3 View with Self Join
-- 4.4 View with UNION/INTERSECT
-- 4.5 Nested Views (View on View)
-- 4.6 View with Window Functions

-- LEVEL 5: UPDATABLE VIEWS
-- 5.1 Simple Updatable Views
-- 5.2 INSERT through View
-- 5.3 UPDATE through View
-- 5.4 DELETE through View
-- 5.5 View with CHECK OPTION
-- 5.6 Local vs Cascaded Check Option
-- 5.7 Non-Updatable Views (When and Why)

-- LEVEL 6: INDEXES FUNDAMENTALS
-- 6.1 What is an Index?
-- 6.2 Index Types Overview
-- 6.3 How Indexes Work (B-Tree, Hash, etc.)
-- 6.4 Index Benefits & Costs
-- 6.5 When to Use/Not Use Indexes

-- LEVEL 7: CREATE INDEX
-- 7.1 Single-Column Index
-- 7.2 Composite/Multi-Column Index
-- 7.3 Unique Index
-- 7.4 Full-Text Index
-- 7.5 Partial Index (WHERE clause)
-- 7.6 Expression Index (Function-based)
-- 7.7 Descending Index
-- 7.8 Covering Index (INCLUDE columns)

-- LEVEL 8: INDEX MANAGEMENT
-- 8.1 View Indexes
-- 8.2 Drop Index
-- 8.3 Rebuild/Reindex Index
-- 8.4 Disable/Enable Index
-- 8.5 Rename Index
-- 8.6 Analyze Index Statistics

-- LEVEL 9: INDEX PERFORMANCE
-- 9.1 EXPLAIN Query Analysis
-- 9.2 Index Scan vs Seq Scan
-- 9.3 Index-Only Scan (Covering Index)
-- 9.4 Bitmap Index Scan
-- 9.5 Index Condition Pushdown
-- 9.6 Multi-Column Index Order Importance
-- 9.7 Index Maintenance

-- LEVEL 10: ADVANCED INDEX CONCEPTS
-- 10.1 Clustered vs Non-Clustered Index
-- 10.2 Primary Key as Clustered Index
-- 10.3 Foreign Key Indexes
-- 10.4 Composite Index Column Order
-- 10.5 Index on Expressions/Lowercase
-- 10.6 Index with NULL values
-- 10.7 Index Skip Scan

-- LEVEL 11: VIEW & INDEX PRACTICAL SCENARIOS
-- 11.1 Reporting Views
-- 11.2 Security Views (Hide Sensitive Data)
-- 11.3 Aggregated Summary Views
-- 11.4 Performance Tuning with Indexes
-- 11.5 Slow Query Optimization
-- 11.6 Join Optimization with Indexes

-- LEVEL 12: COMMON PITFALLS & BEST PRACTICES
-- 12.1 Over-Indexing Problems
-- 12.2 Unused Indexes
-- 12.3 Index Maintenance Overhead
-- 12.4 View Performance Issues
-- 12.5 Nested View Performance
-- 12.6 Updatable View Restrictions
-- 12.7 Index Blocking Writes
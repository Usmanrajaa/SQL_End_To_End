-- =========================================================
-- LEVEL 1: VIEWS FUNDAMENTALS
-- =========================================================

-- 1.1 What is a View?
-- A view is a virtual table based on a SELECT query
-- It doesn't store data physically (except materialized views)
-- Acts as a stored query that can be queried like a table

-- 1.2 View Syntax Structure
/*
CREATE [OR REPLACE] VIEW view_name AS
SELECT columns
FROM tables
WHERE conditions
[WITH CHECK OPTION];
*/

-- 1.3 Types of Views
/*
1. Simple Views - Based on single table, no functions/aggregations
2. Complex Views - Based on multiple tables, JOINs, functions
3. Updatable Views - Can perform INSERT/UPDATE/DELETE
4. Read-Only Views - Complex views that can't be updated
5. Materialized Views - Physically stored (PostgreSQL, Oracle)
*/

-- 1.4 View Security & Benefits
/*
Benefits:
- Security: Hide sensitive columns
- Simplicity: Complex queries become simple
- Consistency: Standardize business logic
- Performance: Pre-defined optimized queries
- Data Integrity: Controlled data access
*/

-- 1.5 View Limitations
/*
- Performance: Each query executes the view's SELECT
- No indexing (except materialized views)
- Nested views can be slow
- Some views are read-only
- ORDER BY in view may be ignored (depends on DB)
*/


-- =========================================================
-- LEVEL 2: CREATE VIEW (With Your Dataset)
-- =========================================================

-- 2.1 Basic View Creation
-- Create a view for active sales employees (from your code)
CREATE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;

-- Query the view (works like a table)
SELECT * FROM active_sales_employees;

-- 2.2 View with Specific Columns
-- Hide sensitive information
CREATE VIEW public_employee_info AS
SELECT employee_id, first_name, last_name, department
FROM employees
WHERE is_manager = FALSE;

-- 2.3 View with WHERE Clause
-- Show only high-value orders
CREATE VIEW high_value_orders AS
SELECT order_id, customer_name, order_date, status
FROM orders
WHERE order_id IN (
    SELECT DISTINCT order_id 
    FROM order_details 
    WHERE quantity * unit_price > 1000
);

-- Test the view
SELECT * FROM high_value_orders;

-- 2.4 View with JOINs (From your code)
CREATE VIEW order_summary AS
SELECT
    o.order_id,
    o.customer_name,
    o.order_date,
    CONCAT(e.first_name, ' ', e.last_name) AS sales_rep,
    SUM(od.quantity * od.unit_price) AS order_total,
    o.status
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, o.customer_name, o.order_date, e.first_name, e.last_name, o.status;

-- Query the view
SELECT * FROM order_summary WHERE order_total > 500;

-- 2.5 View with Aggregations
-- Product sales summary view
CREATE VIEW product_sales_summary AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT od.order_id) AS times_ordered,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.quantity * od.unit_price) AS total_revenue,
    AVG(od.unit_price) AS avg_selling_price,
    MAX(od.unit_price) AS max_price_paid,
    MIN(od.unit_price) AS min_price_paid
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category;

-- Query the summary
SELECT * FROM product_sales_summary ORDER BY total_revenue DESC;

-- 2.6 View with Subqueries
-- View showing products above average price
CREATE VIEW premium_products AS
SELECT 
    product_name,
    category,
    price,
    (SELECT AVG(price) FROM products) AS company_avg_price,
    price - (SELECT AVG(price) FROM products) AS price_difference
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Check premium products
SELECT * FROM premium_products;

-- 2.7 View with Calculated Columns
-- Employee performance view
CREATE VIEW employee_performance AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    COUNT(DISTINCT o.order_id) AS total_orders_handled,
    COALESCE(SUM(od.quantity * od.unit_price), 0) AS total_sales_value,
    ROUND(COALESCE(SUM(od.quantity * od.unit_price), 0) / NULLIF(e.salary, 0), 2) AS sales_to_salary_ratio,
    CASE 
        WHEN COUNT(DISTINCT o.order_id) >= 3 THEN 'High Performer'
        WHEN COUNT(DISTINCT o.order_id) >= 1 THEN 'Active'
        ELSE 'Inactive'
    END AS performance_rating
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.salary;

-- View employee performance
SELECT * FROM employee_performance ORDER BY total_sales_value DESC;

-- 2.8 View with Aliases
CREATE VIEW inventory_status AS
SELECT 
    p.product_id AS id,
    p.product_name AS name,
    p.stock_quantity AS stock,
    p.last_restock_date AS last_restocked,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity < 10 THEN 'Low Stock'
        WHEN p.stock_quantity < 50 THEN 'Normal Stock'
        ELSE 'Overstocked'
    END AS stock_status
FROM products p;


-- =========================================================
-- LEVEL 3: MODIFY VIEWS
-- =========================================================

-- 3.1 CREATE OR REPLACE VIEW
-- Update the sales employees view to include email (from your code)
CREATE OR REPLACE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.email
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;

-- 3.2 ALTER VIEW (Rename, Set Options)
-- Rename a view (PostgreSQL)
ALTER VIEW active_sales_employees RENAME TO active_sales_team;

-- Or in MySQL: RENAME TABLE active_sales_employees TO active_sales_team;

-- Set view options (PostgreSQL)
ALTER VIEW active_sales_team SET (security_invoker = true);

-- 3.3 DROP VIEW
-- Drop a view if no longer needed (from your code)
DROP VIEW IF EXISTS old_sales_report;

-- Drop multiple views
DROP VIEW IF EXISTS view1, view2, view3 CASCADE;

-- 3.4 Temporary Views
-- View that exists only for the session
CREATE TEMPORARY VIEW temp_recent_orders AS
SELECT * FROM orders 
WHERE order_date >= CURRENT_DATE - INTERVAL '7 days';

-- Use temp view
SELECT * FROM temp_recent_orders;

-- 3.5 Materialized Views (PostgreSQL)
-- Physically stored view for better performance
CREATE MATERIALIZED VIEW mv_product_sales AS
SELECT 
    p.product_name,
    p.category,
    COUNT(*) AS order_count,
    SUM(od.quantity) AS total_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW mv_product_sales;

-- Drop materialized view
DROP MATERIALIZED VIEW IF EXISTS mv_product_sales;


-- =========================================================
-- LEVEL 4: VIEW WITH JOINS & COMPLEX QUERIES
-- =========================================================

-- 4.1 View with Multiple JOINs
-- Complete order details view
CREATE VIEW complete_order_details AS
SELECT 
    o.order_id,
    o.customer_name,
    o.order_date,
    o.status AS order_status,
    e.first_name AS sales_rep_first,
    e.last_name AS sales_rep_last,
    p.product_name,
    p.category,
    od.quantity,
    od.unit_price,
    (od.quantity * od.unit_price) AS line_total,
    SUM(od.quantity * od.unit_price) OVER (PARTITION BY o.order_id) AS order_total
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

-- Query the comprehensive view
SELECT * FROM complete_order_details WHERE order_total > 500;

-- 4.2 View with LEFT/RIGHT JOINs
-- Show all products, even those never ordered
CREATE VIEW product_order_status AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    COALESCE(SUM(od.quantity), 0) AS total_ordered,
    CASE 
        WHEN SUM(od.quantity) IS NULL THEN 'Never Ordered'
        WHEN SUM(od.quantity) = 0 THEN 'Ordered but Zero Quantity'
        ELSE 'Has Orders'
    END AS order_status
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category, p.price;

-- 4.3 View with Self Join
-- Employee hierarchy view (if manager_id exists)
CREATE VIEW employee_hierarchy AS
SELECT 
    e1.employee_id,
    e1.first_name AS employee_name,
    e1.is_manager,
    e2.first_name AS manager_name,
    CASE 
        WHEN e1.is_manager = TRUE THEN 'Manager'
        WHEN e2.employee_id IS NOT NULL THEN 'Has Manager'
        ELSE 'No Manager'
    END AS hierarchy_level
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- 4.4 View with UNION
-- Combined active and inactive products view
CREATE VIEW all_products_status AS
SELECT 
    product_name,
    category,
    price,
    'Active' AS status
FROM products
WHERE stock_quantity > 0

UNION

SELECT 
    product_name,
    category,
    price,
    'Out of Stock' AS status
FROM products
WHERE stock_quantity = 0;

-- 4.5 Nested Views (View on View)
-- Build upon existing view
CREATE VIEW high_value_product_sales AS
SELECT 
    product_name,
    total_quantity_sold,
    total_revenue,
    avg_selling_price
FROM product_sales_summary
WHERE total_revenue > 500;

-- 4.6 View with Window Functions
CREATE VIEW employee_rankings AS
SELECT 
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS rank_in_dept,
    DENSE_RANK() OVER (ORDER BY e.salary DESC) AS company_rank,
    ROUND(100.0 * e.salary / SUM(e.salary) OVER (), 2) AS pct_of_payroll
FROM employees e;


-- =========================================================
-- LEVEL 5: UPDATABLE VIEWS
-- =========================================================

-- 5.1 Simple Updatable Views
-- View on single table (updatable)
CREATE VIEW active_products AS
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE stock_quantity > 0;

-- 5.2 INSERT through View
-- Insert new product through view
INSERT INTO active_products (product_name, price, stock_quantity)
VALUES ('New Tablet', 399.99, 50);

-- Verify insertion
SELECT * FROM active_products WHERE product_name = 'New Tablet';
SELECT * FROM products WHERE product_name = 'New Tablet';

-- 5.3 UPDATE through View
-- Update price through view
UPDATE active_products 
SET price = 379.99 
WHERE product_name = 'New Tablet';

-- 5.4 DELETE through View
-- Delete through view (only if view is updatable)
DELETE FROM active_products 
WHERE product_name = 'New Tablet';

-- 5.5 View with CHECK OPTION
-- Prevent inserts/updates that would make row disappear from view
CREATE VIEW high_value_products AS
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE price > 100
WITH CHECK OPTION;

-- This will FAIL because price 50 would make row disappear
-- INSERT INTO high_value_products (product_name, price, stock_quantity)
-- VALUES ('Cheap Item', 50, 100);  -- ERROR!

-- This works
INSERT INTO high_value_products (product_name, price, stock_quantity)
VALUES ('Premium Item', 299.99, 30);

-- 5.6 Local vs Cascaded Check Option
-- LOCAL CHECK: Only checks this view's condition
-- CASCADED CHECK: Checks this and all underlying views
CREATE VIEW expensive_electronics AS
SELECT product_id, product_name, category, price
FROM high_value_products
WHERE category = 'Electronics'
WITH CASCADED CHECK OPTION;

-- 5.7 Non-Updatable Views (When and Why)
-- Views with these features are NOT updatable:
-- - JOINs (multiple tables)
-- - Aggregations (GROUP BY, SUM, COUNT)
-- - DISTINCT
-- - Window functions
-- - Subqueries in SELECT
-- - UNION/INTERSECT/EXCEPT

-- Example: Non-updatable view (JOIN)
CREATE VIEW order_product_view AS
SELECT o.order_id, p.product_name
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

-- This INSERT will FAIL (multiple tables)
-- INSERT INTO order_product_view VALUES (999, 'New Product');  -- ERROR!


-- =========================================================
-- LEVEL 6: INDEXES FUNDAMENTALS
-- =========================================================

-- 6.1 What is an Index?
-- An index is a data structure that improves query speed
-- Similar to a book's index - quickly locates data without scanning everything

-- 6.2 Index Types Overview
/*
1. B-Tree Index - Default, good for equality and range queries
2. Hash Index - Only equality, very fast for exact matches
3. GiST/GIN - Full-text search, geometric data
4. Bitmap Index - For low-cardinality columns
5. Unique Index - Enforces uniqueness
6. Composite Index - Multiple columns
7. Partial Index - Subset of rows
8. Expression Index - Based on function results
*/

-- 6.3 How Indexes Work (B-Tree)
-- Structure: Root → Branches → Leaves (sorted)
-- Search complexity: O(log n) vs full table scan O(n)

-- 6.4 Index Benefits & Costs
/*
Benefits:
- Faster SELECT queries
- Enforce uniqueness
- Faster JOIN operations
- Faster ORDER BY and GROUP BY
- Covering indexes (index-only scans)

Costs:
- Slower INSERT/UPDATE/DELETE
- Extra disk space (up to 2-3x table size)
- Index maintenance overhead
*/

-- 6.5 When to Use/Not Use Indexes
/*
USE indexes when:
- Columns in WHERE clause frequently
- Columns used for JOINs
- Columns used for ORDER BY / GROUP BY
- High cardinality columns (many unique values)
- Large tables (>10,000 rows)

DON'T use indexes when:
- Small tables (<100 rows)
- Low cardinality columns (e.g., gender)
- Frequently updated tables
- Columns rarely used in queries
- Most queries are INSERT/UPDATE/DELETE
*/

-- =========================================================
-- LEVEL 7: CREATE INDEX (With Your Dataset)
-- =========================================================

-- 7.1 Single-Column Index
-- Index on frequently searched column
CREATE INDEX idx_product_name ON products(product_name);

-- Now this query will use the index
SELECT * FROM products WHERE product_name = 'Laptop Pro';

-- 7.2 Composite/Multi-Column Index
-- Index on multiple columns for combined searches
CREATE INDEX idx_employee_name ON employees(last_name, first_name);

-- This query can use the index
SELECT * FROM employees 
WHERE last_name = 'Smith' AND first_name = 'John';

-- Also works for just last_name (leftmost prefix)
SELECT * FROM employees WHERE last_name = 'Smith';

-- But NOT for just first_name (index can't be used)
SELECT * FROM employees WHERE first_name = 'John';  -- Won't use index efficiently

-- 7.3 Unique Index
-- Ensure no duplicate product names (from your code)
CREATE UNIQUE INDEX idx_product_name ON products(product_name);

-- This would now fail if duplicate product name inserted
-- INSERT INTO products (product_name) VALUES ('Laptop Pro');  -- ERROR!

-- 7.4 Full-Text Index (PostgreSQL/MySQL)
-- For searching text within columns
-- PostgreSQL
CREATE INDEX idx_product_description ON products USING GIN(to_tsvector('english', description));

-- MySQL
-- CREATE FULLTEXT INDEX idx_product_fulltext ON products(product_name, category);

-- 7.5 Partial Index (WHERE clause)
-- Index only on in-stock products
CREATE INDEX idx_active_products ON products(product_name)
WHERE stock_quantity > 0;

-- This query uses the partial index
SELECT * FROM products WHERE stock_quantity > 0 AND product_name = 'Laptop Pro';

-- This query won't use it (different WHERE condition)
SELECT * FROM products WHERE stock_quantity = 0 AND product_name = 'Laptop Pro';

-- 7.6 Expression Index (Function-based)
-- Index on lowercase name for case-insensitive search
CREATE INDEX idx_employee_lower_name ON employees(LOWER(last_name));

-- This query can now use the index
SELECT * FROM employees WHERE LOWER(last_name) = 'smith';

-- 7.7 Descending Index
-- For queries ordering by DESC
CREATE INDEX idx_product_price_desc ON products(price DESC);

-- Optimized for descending order
SELECT * FROM products ORDER BY price DESC;

-- 7.8 Covering Index (INCLUDE columns) - PostgreSQL
-- Index that includes extra columns for index-only scans
CREATE INDEX idx_orders_covering ON orders(order_date) INCLUDE (customer_name, status);

-- This query can be satisfied entirely from index (no table access)
SELECT customer_name, status FROM orders WHERE order_date >= '2023-06-01';


-- =========================================================
-- LEVEL 8: INDEX MANAGEMENT
-- =========================================================

-- 8.1 View Indexes
-- Show all indexes on a table (PostgreSQL)
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';

-- Show indexes with details (MySQL)
-- SHOW INDEX FROM employees;

-- 8.2 Drop Index
-- Remove an existing index (from your code)
DROP INDEX IF EXISTS idx_old_product_name;

-- Drop multiple indexes
DROP INDEX IF EXISTS idx1, idx2, idx3;

-- 8.3 Rebuild/Reindex Index
-- Rebuild index to remove fragmentation (PostgreSQL)
REINDEX INDEX idx_product_name;

-- Rebuild all indexes on a table
REINDEX TABLE products;

-- 8.4 Disable/Enable Index (PostgreSQL)
-- Disable index (only for testing)
-- UPDATE pg_index SET indisready = false WHERE indexrelid = 'idx_product_name'::regclass;

-- Enable index
-- UPDATE pg_index SET indisready = true WHERE indexrelid = 'idx_product_name'::regclass;

-- 8.5 Rename Index
ALTER INDEX idx_product_name RENAME TO idx_products_product_name;

-- 8.6 Analyze Index Statistics
-- Update statistics for query optimizer
ANALYZE products;

-- Show index statistics (PostgreSQL)
SELECT * FROM pg_stat_user_indexes WHERE indexrelname = 'idx_product_name';


-- =========================================================
-- LEVEL 9: INDEX PERFORMANCE
-- =========================================================

-- 9.1 EXPLAIN Query Analysis
-- Check if index is being used (from your code)
EXPLAIN ANALYZE SELECT * FROM employees WHERE last_name = 'Smith';

-- Understanding EXPLAIN output:
/*
Seq Scan - Full table scan (bad for large tables)
Index Scan - Using index (good)
Index Only Scan - No table access needed (best)
Bitmap Index Scan - Multiple indexes combined
*/

-- 9.2 Index Scan vs Seq Scan
-- Compare performance with and without index

-- Without index (might do Seq Scan)
EXPLAIN ANALYZE SELECT * FROM employees WHERE last_name = 'Unknown';

-- With index (should do Index Scan)
CREATE INDEX idx_lastname ON employees(last_name);
EXPLAIN ANALYZE SELECT * FROM employees WHERE last_name = 'Smith';

-- 9.3 Index-Only Scan (Covering Index)
-- Create covering index for common query
CREATE INDEX idx_employee_covering ON employees(last_name, first_name, department);

-- This query can use index-only scan (fastest)
EXPLAIN ANALYZE 
SELECT last_name, first_name, department 
FROM employees 
WHERE last_name = 'Smith';

-- 9.4 Bitmap Index Scan
-- When multiple indexes are combined
CREATE INDEX idx_emp_dept ON employees(department);
CREATE INDEX idx_emp_salary ON employees(salary);

-- May use Bitmap Index Scan
EXPLAIN ANALYZE 
SELECT * FROM employees 
WHERE department = 'Sales' AND salary > 60000;

-- 9.5 Index Condition Pushdown
-- Some conditions pushed to index level (MySQL)
EXPLAIN SELECT * FROM employees 
WHERE last_name LIKE 'S%' AND first_name LIKE 'J%';

-- 9.6 Multi-Column Index Order Importance
-- Good order: Most selective first
CREATE INDEX idx_good_order ON employees(department, salary);
-- Use for: WHERE department = 'Sales' AND salary > 50000

-- Bad order: Least selective first
CREATE INDEX idx_bad_order ON employees(salary, department);
-- Less efficient for same query

-- 9.7 Index Maintenance
-- Monitor index size
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) AS index_size
FROM pg_indexes
WHERE tablename = 'employees';


-- =========================================================
-- LEVEL 10: ADVANCED INDEX CONCEPTS
-- =========================================================

-- 10.1 Clustered vs Non-Clustered Index
-- Clustered: Determines physical order of data (only one per table)
-- Primary key is usually clustered index (MySQL InnoDB)

-- Non-Clustered: Separate structure pointing to data (many per table)
-- Most indexes are non-clustered

-- 10.2 Primary Key as Clustered Index
-- Primary keys automatically create a unique clustered index
ALTER TABLE products ADD PRIMARY KEY (product_id);

-- 10.3 Foreign Key Indexes
-- Always index foreign key columns (from your code)
CREATE INDEX idx_order_employee ON orders(employee_id);
CREATE INDEX idx_order_details_order ON order_details(order_id);
CREATE INDEX idx_order_details_product ON order_details(product_id);

-- 10.4 Composite Index Column Order
-- Rule: Most selective column first
-- Check cardinality (number of distinct values)
SELECT 
    COUNT(DISTINCT department) AS dept_cardinality,
    COUNT(DISTINCT salary) AS salary_cardinality
FROM employees;

-- department has low cardinality (few distinct)
-- salary has high cardinality (many distinct)
-- So put salary first
CREATE INDEX idx_emp_salary_dept ON employees(salary, department);

-- 10.5 Index on Expressions/Lowercase
-- Case-insensitive search index
CREATE INDEX idx_emp_lower_email ON employees(LOWER(email));

-- Query using the expression index
SELECT * FROM employees WHERE LOWER(email) = 'john.smith@company.com';

-- 10.6 Index with NULL values
-- Index includes NULLs (can be useful for finding NULLs)
CREATE INDEX idx_nullable ON products(last_restock_date);

-- This can use the index
SELECT * FROM products WHERE last_restock_date IS NULL;

-- 10.7 Index Skip Scan (MySQL 8.0+)
-- Allows skipping first column of composite index
-- For query: WHERE salary > 50000 (even if index is on (department, salary))
-- MySQL can skip the department part


-- =========================================================
-- LEVEL 11: PRACTICAL SCENARIOS
-- =========================================================

-- 11.1 Reporting Views
-- Create daily sales report view
CREATE VIEW daily_sales_report AS
SELECT 
    o.order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_name) AS unique_customers,
    SUM(od.quantity * od.unit_price) AS total_revenue,
    AVG(od.quantity * od.unit_price) AS avg_order_value
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_date
ORDER BY o.order_date DESC;

-- Use for reporting
SELECT * FROM daily_sales_report WHERE order_date >= '2023-06-01';

-- 11.2 Security Views (Hide Sensitive Data)
-- Hide salary information from non-managers
CREATE VIEW employees_public AS
SELECT employee_id, first_name, last_name, department, email
FROM employees;

-- Managers view with salary
CREATE VIEW employees_manager AS
SELECT * FROM employees;

-- 11.3 Aggregated Summary Views
-- Product performance dashboard
CREATE VIEW product_performance AS
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS product_count,
    COUNT(DISTINCT od.order_id) AS times_ordered,
    SUM(od.quantity) AS units_sold,
    SUM(od.quantity * od.unit_price) AS revenue,
    ROUND(AVG(od.quantity * od.unit_price), 2) AS avg_sale_value
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category;

-- 11.4 Performance Tuning with Indexes
-- Slow query without index
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_name = 'Acme Corp';

-- Add index to fix
CREATE INDEX idx_customer_name ON orders(customer_name);

-- Now fast
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_name = 'Acme Corp';

-- 11.5 Slow Query Optimization Example
-- Problem: Slow ORDER BY on non-indexed column
EXPLAIN ANALYZE
SELECT * FROM products ORDER BY last_restock_date DESC;

-- Solution: Create index on the column
CREATE INDEX idx_restock_date ON products(last_restock_date DESC);

-- Query now uses index for sorting
EXPLAIN ANALYZE
SELECT * FROM products ORDER BY last_restock_date DESC;

-- 11.6 Join Optimization with Indexes
-- Ensure join columns are indexed
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_emp_id ON employees(employee_id);

-- Now this join will be fast
EXPLAIN ANALYZE
SELECT o.order_id, e.first_name
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id;


-- =========================================================
-- LEVEL 12: COMMON PITFALLS & BEST PRACTICES
-- =========================================================

-- 12.1 Over-Indexing Problems
-- BAD: Indexing every column (wastes space, slows writes)
CREATE INDEX idx1 ON products(product_name);
CREATE INDEX idx2 ON products(category);
CREATE INDEX idx3 ON products(price);
CREATE INDEX idx4 ON products(stock_quantity);
CREATE INDEX idx5 ON products(last_restock_date);
-- Too many indexes!

-- GOOD: Only index columns used in WHERE, JOIN, ORDER BY

-- 12.2 Unused Indexes
-- Find unused indexes (PostgreSQL)
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
WHERE idx_scan = 0  -- Never used
ORDER BY idx_tup_read;

-- Drop unused indexes
-- DROP INDEX unused_index_name;

-- 12.3 Index Maintenance Overhead
-- Each index slows INSERT/UPDATE/DELETE by ~30%
-- For high-write tables, minimize indexes

-- Example: Log table with mostly INSERTs
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    log_message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
-- Only index created_at if needed for queries

-- 12.4 View Performance Issues
-- BAD: View with nested views
CREATE VIEW v1 AS SELECT * FROM products;
CREATE VIEW v2 AS SELECT * FROM v1;
CREATE VIEW v3 AS SELECT * FROM v2;
-- Querying v3 is slow (multiple layers)

-- GOOD: Flatten views or use materialized views

-- 12.5 Nested View Performance
-- Instead of nested views, create a single view
CREATE VIEW flattened_view AS
SELECT * FROM products;  -- Direct access

-- 12.6 Updatable View Restrictions
-- This view is NOT updatable (has JOIN)
CREATE VIEW order_details_view AS
SELECT o.order_id, o.customer_name, p.product_name
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

-- This UPDATE will FAIL
-- UPDATE order_details_view SET customer_name = 'New Name' WHERE order_id = 1;

-- 12.7 Index Blocking Writes
-- During large updates, consider dropping indexes temporarily
-- DROP INDEX idx_product_name;
-- UPDATE products SET price = price * 1.1;
-- CREATE INDEX idx_product_name ON products(product_name);


-- =========================================================
-- VIEWS & INDEXES QUICK REFERENCE
-- =========================================================

-- === VIEWS ===
CREATE VIEW view_name AS SELECT ...;              -- Create view
CREATE OR REPLACE VIEW view_name AS ...;         -- Modify view
DROP VIEW IF EXISTS view_name;                   -- Delete view
CREATE TEMPORARY VIEW view_name AS ...;          -- Session-only view
CREATE MATERIALIZED VIEW mv_name AS ...;         -- Stored view (PG)
SELECT * FROM view_name;                         -- Query view

-- === INDEXES ===
CREATE INDEX idx_name ON table(column);          -- Basic index
CREATE UNIQUE INDEX idx_name ON table(column);   -- Unique constraint
CREATE INDEX idx_name ON table(col1, col2);      -- Composite index
CREATE INDEX idx_name ON table(column) WHERE condition;  -- Partial index
CREATE INDEX idx_name ON table(LOWER(column));   -- Expression index
DROP INDEX idx_name;                             -- Delete index
ANALYZE table_name;                              -- Update statistics

-- === Performance Analysis ===
EXPLAIN SELECT ...;                              -- See query plan
EXPLAIN ANALYZE SELECT ...;                      -- Execute and analyze

-- === View Indexes ===
SELECT * FROM pg_indexes WHERE tablename = 'table';  -- List indexes (PG)
SHOW INDEX FROM table_name;                      -- List indexes (MySQL)

-- === Common Patterns ===
-- Covering index (index-only scan)
CREATE INDEX idx_covering ON table(col1, col2) INCLUDE (col3);  -- PG

-- Conditional view
CREATE VIEW active_orders AS
SELECT * FROM orders WHERE status NOT IN ('Cancelled', 'Completed');

-- Security view (hide sensitive data)
CREATE VIEW public_employee AS
SELECT id, name, department FROM employees;  -- Excludes salary



LEVEL 1: VIEWS FUNDAMENTALS – QUESTIONS & SOLUTIONS
Q1: What is a view, and does it store data physically?
A view is a virtual table based on a SELECT query. It does not store data physically (except materialized views). It acts as a stored query that can be queried like a table.

Q2: List at least 3 benefits of using views.

Security: Hide sensitive columns

Simplicity: Complex queries become simple

Consistency: Standardize business logic

Performance: Pre-defined optimized queries

Data integrity: Controlled data access

Q3: Name 2 limitations or downsides of using views.

Performance: Each query executes the view's SELECT

No indexing (except materialized views)

Nested views can be slow

Some views are read-only

ORDER BY in view may be ignored (depends on DB)

Q4: What are the 5 types of views mentioned in the tutorial?

Simple Views – single table, no functions/aggregations

Complex Views – multiple tables, JOINs, functions

Updatable Views – can perform INSERT/UPDATE/DELETE

Read-Only Views – complex views that can't be updated

Materialized Views – physically stored (PostgreSQL, Oracle)

Q5: What does WITH CHECK OPTION do when creating a view?
It prevents inserts or updates that would cause the row to disappear from the view.

LEVEL 2: CREATE VIEW – QUESTIONS & SOLUTIONS (Based on Your Dataset)
Q6: Write the SQL to create a view called active_sales_employees that shows employee_id, first_name, last_name, and salary for employees in department 10 who are not managers.

sql
CREATE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;
Q7: How would you create a view public_employee_info that hides sensitive columns and only shows non‑manager employees?

sql
CREATE VIEW public_employee_info AS
SELECT employee_id, first_name, last_name, department
FROM employees
WHERE is_manager = FALSE;
Q8: Create a view high_value_orders that displays orders where the total value (quantity * unit_price) exceeds 1000.

sql
CREATE VIEW high_value_orders AS
SELECT order_id, customer_name, order_date, status
FROM orders
WHERE order_id IN (
    SELECT DISTINCT order_id 
    FROM order_details 
    WHERE quantity * unit_price > 1000
);
Q9: Write a view order_summary that joins orders, employees, and order_details, showing order_id, customer_name, order_date, sales rep full name, order total, and status.

sql
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
Q10: Create a view product_sales_summary that aggregates product_id, product_name, category, times ordered, total quantity sold, total revenue, average selling price, max price, and min price.

sql
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
Q11: Write a view premium_products that shows products with a price above the company average, including the average price and the difference.

sql
CREATE VIEW premium_products AS
SELECT 
    product_name,
    category,
    price,
    (SELECT AVG(price) FROM products) AS company_avg_price,
    price - (SELECT AVG(price) FROM products) AS price_difference
FROM products
WHERE price > (SELECT AVG(price) FROM products);
Q12: Create an employee_performance view with calculated columns: total orders handled, total sales value, sales‑to‑salary ratio, and a performance rating (High Performer / Active / Inactive).

sql
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
Q13: Write a view inventory_status that uses CASE to label stock status as Out of Stock, Low Stock, Normal Stock, or Overstocked.

sql
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
LEVEL 3: MODIFY VIEWS – QUESTIONS & SOLUTIONS
Q14: How do you update an existing view without dropping it? Provide an example that adds the email column to active_sales_employees.

sql
CREATE OR REPLACE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.email
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;
Q15: Write the SQL to rename the view active_sales_employees to active_sales_team (PostgreSQL syntax).

sql
ALTER VIEW active_sales_employees RENAME TO active_sales_team;
Q16: How do you safely drop a view if it exists?

sql
DROP VIEW IF EXISTS old_sales_report;
Q17: What is a temporary view, and how do you create one that shows orders from the last 7 days?
A temporary view exists only for the current session.

sql
CREATE TEMPORARY VIEW temp_recent_orders AS
SELECT * FROM orders 
WHERE order_date >= CURRENT_DATE - INTERVAL '7 days';
Q18: What is a materialized view? Write the SQL to create one called mv_product_sales that stores product sales aggregations.
A materialized view is physically stored for better performance.

sql
CREATE MATERIALIZED VIEW mv_product_sales AS
SELECT 
    p.product_name,
    p.category,
    COUNT(*) AS order_count,
    SUM(od.quantity) AS total_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category;
Q19: How do you refresh a materialized view?

sql
REFRESH MATERIALIZED VIEW mv_product_sales;
LEVEL 4: VIEW WITH JOINS & COMPLEX QUERIES – QUESTIONS & SOLUTIONS
Q20: Create a view complete_order_details that uses multiple JOINs to show: order ID, customer name, order date, order status, sales rep first/last name, product name, category, quantity, unit price, line total, and order total (window function).

sql
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
Q21: Write a view product_order_status using a LEFT JOIN to show all products, even those never ordered, with a column order_status that says Never Ordered, Ordered but Zero Quantity, or Has Orders.

sql
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
Q22: Assuming an employees table has a manager_id, create a view employee_hierarchy that shows each employee’s name, whether they are a manager, their manager’s name, and a hierarchy level.

sql
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
Q23: Write a view all_products_status using UNION to show active products (stock > 0) labeled Active and out‑of‑stock products labeled Out of Stock.

sql
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
Q24: What is a nested view? Show an example that builds high_value_product_sales on top of product_sales_summary.

sql
CREATE VIEW high_value_product_sales AS
SELECT 
    product_name,
    total_quantity_sold,
    total_revenue,
    avg_selling_price
FROM product_sales_summary
WHERE total_revenue > 500;
Q25: Create a view employee_rankings that uses window functions to show rank within department, company‑wide dense rank, and percentage of total payroll.

sql
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
LEVEL 5: UPDATABLE VIEWS – QUESTIONS & SOLUTIONS
Q26: What makes a simple view updatable? Provide an example active_products based on a single table.
A simple view on a single table without aggregations, DISTINCT, window functions, or JOINs is updatable.

sql
CREATE VIEW active_products AS
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE stock_quantity > 0;
Q27: Show how to insert a new product through the active_products view.

sql
INSERT INTO active_products (product_name, price, stock_quantity)
VALUES ('New Tablet', 399.99, 50);
Q28: Update the price of a product through the view.

sql
UPDATE active_products 
SET price = 379.99 
WHERE product_name = 'New Tablet';
Q29: Delete a product through the view.

sql
DELETE FROM active_products 
WHERE product_name = 'New Tablet';
Q30: What does WITH CHECK OPTION prevent? Write a view high_value_products with CHECK OPTION and explain why inserting a product with price 50 would fail.
It prevents inserts/updates that would make the row disappear from the view.

sql
CREATE VIEW high_value_products AS
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE price > 100
WITH CHECK OPTION;
Inserting price 50 would fail because the new row would not satisfy price > 100 and would vanish from the view.

Q31: Explain the difference between LOCAL CHECK OPTION and CASCADED CHECK OPTION.

LOCAL CHECK OPTION: only checks the condition of this view.

CASCADED CHECK OPTION: checks this view's condition and all underlying views' conditions.

Q32: List at least 4 features that make a view non‑updatable. Why does INSERT fail on order_product_view?
Features: JOINs, aggregations (GROUP BY, SUM), DISTINCT, window functions, subqueries in SELECT, UNION.
INSERT fails because the view joins multiple tables – there is no way to map the insert to a single underlying table.

LEVEL 6: INDEXES FUNDAMENTALS – QUESTIONS & SOLUTIONS
Q33: What is an index, and how does it improve query speed?
An index is a data structure (like a book's index) that allows the database to quickly locate rows without scanning the entire table.

Q34: Name 5 types of indexes mentioned.

B-Tree Index

Hash Index

GiST/GIN (full-text)

Bitmap Index

Unique Index

Composite Index

Partial Index

Expression Index

Q35: How does a B‑Tree index achieve O(log n) search complexity?
It organizes data in a tree structure (root → branches → leaves). The height grows logarithmically with the number of rows.

Q36: List 3 benefits and 3 costs of using indexes.
Benefits: faster SELECT, uniqueness enforcement, faster JOIN/ORDER BY/GROUP BY, covering indexes.
Costs: slower INSERT/UPDATE/DELETE, extra disk space (2-3x table size), maintenance overhead.

Q37: When should you avoid creating an index?

Small tables (<100 rows)

Low cardinality columns (e.g., gender)

Frequently updated tables

Columns rarely used in WHERE/JOIN/ORDER BY

When most queries are INSERT/UPDATE/DELETE

LEVEL 7: CREATE INDEX – QUESTIONS & SOLUTIONS
Q38: Write the SQL to create a single‑column index on product_name in the products table.

sql
CREATE INDEX idx_product_name ON products(product_name);
Q39: Create a composite index on employees(last_name, first_name). Which queries can use it?

sql
CREATE INDEX idx_employee_name ON employees(last_name, first_name);
It can be used for:

WHERE last_name = 'Smith' AND first_name = 'John'

WHERE last_name = 'Smith' (leftmost prefix)
It cannot be used efficiently for WHERE first_name = 'John' alone.

Q40: Create a unique index on product_name to prevent duplicates.

sql
CREATE UNIQUE INDEX idx_product_name ON products(product_name);
Q41: What is a partial index? Write one on products that indexes only rows where stock_quantity > 0.

sql
CREATE INDEX idx_active_products ON products(product_name)
WHERE stock_quantity > 0;
Q42: Create an expression index on LOWER(last_name) to speed up case‑insensitive searches.

sql
CREATE INDEX idx_employee_lower_name ON employees(LOWER(last_name));
Q43: Write a descending index on price in the products table.

sql
CREATE INDEX idx_product_price_desc ON products(price DESC);
Q44: What is a covering index? Create one on orders(order_date) INCLUDE (customer_name, status) (PostgreSQL).
A covering index includes extra columns so that the query can be satisfied entirely from the index without accessing the table.

sql
CREATE INDEX idx_orders_covering ON orders(order_date) INCLUDE (customer_name, status);
LEVEL 8: INDEX MANAGEMENT – QUESTIONS & SOLUTIONS
Q45: How do you list all indexes on the employees table in PostgreSQL?

sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';
Q46: Write the SQL to drop an index named idx_old_product_name.

sql
DROP INDEX IF EXISTS idx_old_product_name;
Q47: Rebuild an index named idx_product_name (PostgreSQL).

sql
REINDEX INDEX idx_product_name;
Q48: Rename an index from idx_product_name to idx_products_product_name.

sql
ALTER INDEX idx_product_name RENAME TO idx_products_product_name;
Q49: Why would you run ANALYZE products after creating indexes?
To update statistics for the query optimizer, helping it decide whether to use the index.

LEVEL 9: INDEX PERFORMANCE – QUESTIONS & SOLUTIONS
Q50: What does EXPLAIN ANALYZE show? Write a command to analyze a query filtering employees by last_name = 'Smith'.
It executes the query and shows the actual execution plan (operations, row counts, timings).

sql
EXPLAIN ANALYZE SELECT * FROM employees WHERE last_name = 'Smith';
Q51: Compare Seq Scan, Index Scan, and Index Only Scan – which is best and why?

Seq Scan: full table scan (bad for large tables)

Index Scan: uses index to find rows (good)

Index Only Scan: reads only the index, no table access (best, fastest)

Q52: What is a covering index? Show an example query that could use an index‑only scan.
A covering index includes all columns needed by the query.

sql
-- Index: CREATE INDEX idx_covering ON employees(last_name, first_name, department)
SELECT last_name, first_name, department 
FROM employees 
WHERE last_name = 'Smith';
Q53: Explain Bitmap Index Scan. Write two indexes that might cause it when filtering department = 'Sales' AND salary > 60000.
Bitmap Index Scan combines multiple indexes using bitmaps.

sql
CREATE INDEX idx_emp_dept ON employees(department);
CREATE INDEX idx_emp_salary ON employees(salary);
-- Query: SELECT * FROM employees WHERE department = 'Sales' AND salary > 60000;
Q54: Why is the order of columns important in a composite index? Provide an example of good order vs. bad order.
Columns should be ordered from most selective to least selective.
Good: (salary, department) if salary has high cardinality.
Bad: (department, salary) if department has low cardinality.

Q55: How can you monitor the size of an index in PostgreSQL?

sql
SELECT schemaname, tablename, indexname, pg_size_pretty(pg_relation_size(indexname::regclass)) AS index_size
FROM pg_indexes
WHERE tablename = 'employees';
LEVEL 10: ADVANCED INDEX CONCEPTS – QUESTIONS & SOLUTIONS
Q56: What is the difference between a clustered index and a non‑clustered index? How does a primary key relate to this?
Clustered index determines physical order of data (one per table). Non‑clustered is a separate structure pointing to data (many per table). In MySQL/InnoDB, the primary key is the clustered index.

Q57: Why should you create indexes on foreign key columns? Write indexes for orders(employee_id), order_details(order_id), and order_details(product_id).
Foreign key indexes speed up JOINs and cascading operations.

sql
CREATE INDEX idx_order_employee ON orders(employee_id);
CREATE INDEX idx_order_details_order ON order_details(order_id);
CREATE INDEX idx_order_details_product ON order_details(product_id);
Q58: How do you decide which column to put first in a composite index? (Hint: cardinality)
Choose the column with higher cardinality (more distinct values) first.

Q59: Create an index on LOWER(email) to support case‑insensitive email searches.

sql
CREATE INDEX idx_emp_lower_email ON employees(LOWER(email));
Q60: Can an index help find NULL values? Explain.
Yes, most B-tree indexes include NULLs. A query like WHERE last_restock_date IS NULL can use the index.

LEVEL 11: PRACTICAL SCENARIOS – QUESTIONS & SOLUTIONS
Q61: Create a view daily_sales_report that shows date, total orders, unique customers, total revenue, and average order value.

sql
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
Q62: Write a security view employees_public that hides the salary column.

sql
CREATE VIEW employees_public AS
SELECT employee_id, first_name, last_name, department, email
FROM employees;
Q63: Create a view product_performance that groups by category and shows product count, times ordered, units sold, revenue, and average sale value.

sql
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
Q64: You have a slow query SELECT * FROM orders WHERE customer_name = 'Acme Corp'. What index would you add to fix it?

sql
CREATE INDEX idx_customer_name ON orders(customer_name);
Q65: A query using ORDER BY last_restock_date DESC is slow. Write the index that would speed it up.

sql
CREATE INDEX idx_restock_date ON products(last_restock_date DESC);
Q66: Write the indexes needed to optimize a join between orders and employees on employee_id.

sql
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_emp_id ON employees(employee_id);
LEVEL 12: COMMON PITFALLS & BEST PRACTICES – QUESTIONS & SOLUTIONS
Q67: What is over‑indexing? Why is it bad for write operations?
Over‑indexing means creating indexes on every column. Each index slows INSERT/UPDATE/DELETE (by about 30% per index) and wastes disk space.

Q68: How can you find indexes that are never used (PostgreSQL)?

sql
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY idx_tup_read;
Q69: Why do views that nest other views cause performance problems?
Each nested layer adds overhead; the database may materialize intermediate results. Flattening views or using materialized views is better.

Q70: Give an example of a view that is not updatable (e.g., involves a JOIN) and explain why an UPDATE would fail.

sql
CREATE VIEW order_product_view AS
SELECT o.order_id, p.product_name
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;
UPDATE order_product_view SET customer_name = ... fails because the view spans multiple tables; the database doesn't know which table to update.

Q71: During a large update like UPDATE products SET price = price * 1.1, why might you temporarily drop indexes? What is the safe procedure?
Indexes slow down bulk updates. Procedure:

sql
DROP INDEX idx_product_name;
UPDATE products SET price = price * 1.1;
CREATE INDEX idx_product_name ON products(product_name);
VIEWS & INDEXES QUICK REFERENCE – QUESTIONS & SOLUTIONS
Q72: Write the shortest syntax to: create a basic view; replace an existing view; drop a view if it exists; create a basic index; drop an index.

sql
CREATE VIEW v AS SELECT ...;
CREATE OR REPLACE VIEW v AS SELECT ...;
DROP VIEW IF EXISTS v;
CREATE INDEX i ON t(c);
DROP INDEX i;
Q73: What command shows the query plan without executing it?

sql
EXPLAIN SELECT ...;
Q74: How do you list all indexes on a table in PostgreSQL? In MySQL?
PostgreSQL: SELECT * FROM pg_indexes WHERE tablename = 'table';
MySQL: SHOW INDEX FROM table_name;

Q75: Write a covering index (PostgreSQL syntax) that allows index-only scans for queries selecting col1, col2, and col3 with a filter on col1 and col2.

sql
CREATE INDEX idx_covering ON table_name(col1, col2) INCLUDE (col3);

-- 1. Create View
-- Create a view for active sales employees
CREATE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;

-- Create a view for order summaries
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

-- Update the sales employees view to include email
CREATE OR REPLACE VIEW active_sales_employees AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary, e.email
FROM employees e
WHERE e.dept_id = 10 AND e.is_manager = FALSE;


-- Drop a view if no longer needed
DROP VIEW IF EXISTS old_sales_report;


-- Query the order summary view
SELECT * FROM order_summary
WHERE order_date >= '2023-06-01'
ORDER BY order_total DESC;

-- Join a view with other tables
SELECT a.first_name, a.last_name, COUNT(s.sale_id) AS sale_count
FROM active_sales_employees a
LEFT JOIN sales s ON a.employee_id = s.employee_id
GROUP BY a.employee_id, a.first_name, a.last_name;


-- Create index on frequently searched columns
CREATE INDEX idx_employee_name ON employees(last_name, first_name);

-- Create index on foreign keys
CREATE INDEX idx_order_employee ON orders(employee_id);

-- Create unique index
CREATE UNIQUE INDEX idx_product_name ON products(product_name);

-- Create partial index
CREATE INDEX idx_high_value_orders ON order_details(order_id)
WHERE unit_price > 1000;


-- Drop an existing index
DROP INDEX IF EXISTS idx_old_product_name;


-- Check if index is being used (PostgreSQL example)EXPLAIN 
ANALYZE SELECT * FROM employees WHERE last_name = 'Smith';

-- Show all indexes on a table
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';
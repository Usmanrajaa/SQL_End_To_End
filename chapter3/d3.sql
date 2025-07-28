USE sql_pract;
SELECT * FROM employees;
SELECT * FROM sales;
DESCRIBE employees;
DROP TABLE sales;
SHOW TABLES;
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    sale_date DATE,
    amount DECIMAL(10,2),
    region VARCHAR(50)
);
INSERT INTO sales VALUES
(204, 11, '2023-01-15', 12500.00, 'East');
-- (101, 1, '2023-01-15', 12500.00, 'East'),
-- (102, 1, '2023-02-20', 8400.00, 'East'),
-- (103, 2, '2023-01-10', 15300.00, 'West'),
-- (104, 3, '2023-03-05', 9200.00, 'North'),
-- (105, 3, '2023-04-18', 11000.00, 'North'),
-- (106, 6, '2023-02-28', 7600.00, 'South'),
-- (107, 6, '2023-03-15', 14200.00, 'South'),
-- (108, 6, '2023-04-01', 9800.00, 'South'),
-- (109, 10, '2023-01-22', 16500.00, 'East'),
-- (110, 10, '2023-03-30', 12300.00, 'East'),
-- (111, 5, '2023-04-10', 8700.00, 'West'),
-- (112, 7, '2023-02-15', 5400.00, 'North'),
-- (113, 4, '2023-03-20', 3200.00, 'West'),
-- (114, 8, '2023-04-05', 11800.00, 'South'),
-- (115, 9, '2023-01-30', 9500.00, 'East');
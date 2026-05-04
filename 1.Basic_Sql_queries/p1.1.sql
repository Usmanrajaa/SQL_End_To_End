-- =========================================================
-- MASTER SQL FILE: COMPLETE DATABASE OPERATIONS
-- =========================================================
-- This file contains all operations in proper order:
-- 1. Database Setup
-- 2. Table Creation
-- 3. Column Level Operations
-- 4. Row Level Operations
-- 5. Cleanup Operations
-- =========================================================

-- =========================================================
-- SECTION 1: DATABASE SETUP
-- =========================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

-- =========================================================
-- SECTION 2: TABLE CREATION
-- =========================================================

-- 2.1 NUMERIC DATATYPES TABLE
CREATE TABLE product (
    product_id TINYINT UNSIGNED PRIMARY KEY,        -- 0 to 255
    product_no SMALLINT UNSIGNED UNIQUE,            -- up to ~65k
    product_serial INT UNSIGNED NOT NULL,           -- large integer
    product_price DECIMAL(10,2) NOT NULL,           -- precise price
    product_info BIGINT,                            -- very large number
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- tracking
);

-- 2.2 STRING DATATYPES TABLE
CREATE TABLE car (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    car_name CHAR(20) NOT NULL,                     -- fixed length
    car_model VARCHAR(50) NOT NULL,                 -- variable length
    car_info TEXT,                                  -- long text
    car_category ENUM('electric','diesel','petrol') NOT NULL,
    UNIQUE(car_name, car_model)                     -- composite uniqueness
);

-- 2.3 BOOLEAN DATATYPE TABLE
CREATE TABLE verify (
    verify_id INT AUTO_INCREMENT PRIMARY KEY,
    is_delivered BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE
);

-- 2.4 TEMPORAL DATATYPES TABLE
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,                       -- only date
    order_time TIME NOT NULL,                       -- only time
    order_datetime DATETIME NOT NULL,               -- date + time
    order_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- auto tracking
    delivery_date DATE,
    CHECK (delivery_date >= order_date)             -- logical constraint
);

-- 2.5 EMPLOYEE TABLE (for additional operations)
CREATE TABLE employees_data (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    employee_salary DECIMAL(10,2),
    employee_department VARCHAR(50),
    hire_date DATE
);

-- =========================================================
-- SECTION 3: INITIAL DATA INSERTION
-- =========================================================

-- Insert sample data into product
INSERT INTO product (product_id, product_no, product_serial, product_price, product_info)
VALUES 
(1, 1001, 123456, 999.99, 9876543210),
(2, 2002, 222222, 1999.99, 1234567890),
(3, 3003, 333333, 2999.99, 1111111111);

-- Insert sample data into car
INSERT INTO car (car_name, car_model, car_info, car_category)
VALUES 
('Tesla', 'Model S', 'Electric luxury sedan', 'electric'),
('Toyota', 'Camry', 'Mid-size sedan', 'petrol'),
('Honda', 'Civic', 'Compact car', 'petrol');

-- Insert sample data into verify
INSERT INTO verify (is_delivered, is_active)
VALUES 
(TRUE, TRUE), 
(FALSE, TRUE),
(TRUE, FALSE);

-- Insert sample data into orders
INSERT INTO orders (order_date, order_time, order_datetime, delivery_date)
VALUES 
('2024-01-01', '10:30:00', '2024-01-01 10:30:00', '2024-01-05'),
('2024-01-02', '14:15:00', '2024-01-02 14:15:00', '2024-01-06'),
('2024-01-03', '09:45:00', '2024-01-03 09:45:00', '2024-01-07');

-- Insert sample data into employees_data
INSERT INTO employees_data (employee_name, employee_salary, employee_department, hire_date)
VALUES
('John Doe', 45000, 'IT', '2023-01-15'),
('Jane Smith', 55000, 'HR', '2023-02-20'),
('Bob Johnson', 65000, 'IT', '2023-03-10'),
('Alice Brown', 75000, 'Finance', '2023-04-05');

-- =========================================================
-- SECTION 4: COLUMN LEVEL OPERATIONS
-- =========================================================

-- 4.1 SHOW COLUMNS (View table structure)
SHOW COLUMNS FROM product;
SHOW COLUMNS FROM car;
SHOW COLUMNS FROM verify;
SHOW COLUMNS FROM orders;

-- 4.2 SELECT ALL DATA (Verify initial data)
SELECT * FROM product;
SELECT * FROM car;
SELECT * FROM verify;
SELECT * FROM orders;
SELECT * FROM employees_data;

-- 4.3 ADD MULTIPLE COLUMNS WITH CONSTRAINTS
ALTER TABLE product
ADD COLUMN product_status VARCHAR(20) DEFAULT 'available',
ADD COLUMN product_rating DECIMAL(3,2) CHECK (product_rating <= 5),
ADD COLUMN product_code VARCHAR(50) UNIQUE;

-- 4.4 ADD COLUMN AT FIRST POSITION
ALTER TABLE product
ADD COLUMN temp_first_col INT FIRST;

-- 4.5 ADD COLUMN AFTER SPECIFIC COLUMN
ALTER TABLE product
ADD COLUMN temp_after_col VARCHAR(50) AFTER product_price;

-- 4.6 MODIFY COLUMN DATATYPE
ALTER TABLE product
MODIFY COLUMN product_price DECIMAL(12,2);

-- 4.7 RENAME COLUMN
ALTER TABLE product
RENAME COLUMN product_info TO product_details;

-- 4.8 ADD PRIMARY KEY (DROP IF EXISTS FIRST)
ALTER TABLE verify
DROP PRIMARY KEY;

ALTER TABLE verify
ADD PRIMARY KEY (verify_id);

-- 4.9 ADD CONSTRAINT (UNIQUE)
ALTER TABLE car
ADD CONSTRAINT unique_car_model UNIQUE(car_model);

-- 4.10 DROP COLUMN
ALTER TABLE product
DROP COLUMN temp_first_col;

-- 4.11 Verify column changes
DESCRIBE product;
SELECT * FROM product;

-- =========================================================
-- SECTION 5: ROW LEVEL OPERATIONS
-- =========================================================

-- 5.1 INSERT FULL ROW
INSERT INTO product VALUES
(4, 4004, 444444, 3999.99, 9999999999, NOW(), 'available', 4.5, 'P004', 'extra');

-- 5.2 INSERT SPECIFIC COLUMNS
INSERT INTO product (product_id, product_no, product_serial, product_price)
VALUES (5, 5005, 555555, 4999.99);

-- 5.3 UPDATE MULTIPLE COLUMNS (SINGLE ROW)
UPDATE product
SET product_price = 2500.00,
    product_status = 'sold'
WHERE product_id = 1;

-- 5.4 UPDATE MULTIPLE COLUMNS (ANOTHER STYLE)
UPDATE product
SET product_price = 2700.00,
    product_code = 'UPDATED_CODE',
    product_rating = 4.8
WHERE product_id = 2;

-- 5.5 UPDATE MULTIPLE ROWS USING CASE (IMPORTANT)
UPDATE product
SET 
product_price = CASE
    WHEN product_id = 1 THEN 3000
    WHEN product_id = 2 THEN 3500
    ELSE product_price
END,
product_status = CASE
    WHEN product_price > 3000 THEN 'premium'
    ELSE 'standard'
END,
product_rating = CASE
    WHEN product_id = 1 THEN 4.2
    WHEN product_id = 2 THEN 4.9
    ELSE product_rating
END;

-- 5.6 DELETE SPECIFIC ROW
DELETE FROM product
WHERE product_id = 3;

-- 5.7 DELETE WITH CONDITION
DELETE FROM product
WHERE product_price < 2000;

-- 5.8 REPLACE INTO (INSERT OR OVERWRITE)
REPLACE INTO product (product_id, product_no, product_serial, product_price)
VALUES (1, 9999, 888888, 5000.00);

-- 5.9 Verify all row changes
SELECT * FROM product ORDER BY product_id;

-- =========================================================
-- SECTION 6: TABLE MANAGEMENT OPERATIONS
-- =========================================================

-- 6.1 SHOW ALL TABLES
SHOW TABLES;

-- 6.2 DESCRIBE TABLE STRUCTURE
DESCRIBE employees_data;

-- 6.3 CLONE TABLE STRUCTURE
CREATE TABLE emp_clone LIKE employees_data;

-- 6.4 CREATE FILTERED TABLE FROM EXISTING DATA
CREATE TABLE high_paid AS
SELECT * FROM employees_data WHERE employee_salary > 60000;

-- 6.5 VERIFY CLONED AND FILTERED TABLES
SELECT * FROM emp_clone;
SELECT * FROM high_paid;

-- 6.6 DELETE DATA FROM EMPLOYEES TABLE
DELETE FROM employees_data WHERE employee_salary < 60000;

-- 6.7 VERIFY DELETE OPERATION
SELECT * FROM employees_data;

-- 6.8 TRUNCATE CLONE TABLE (Remove all data but keep structure)
TRUNCATE TABLE emp_clone;

-- 6.9 VERIFY TRUNCATE
SELECT * FROM emp_clone;

-- 6.10 RENAME TABLE
RENAME TABLE employees_data TO emp_main;

-- 6.11 VERIFY RENAME
SHOW TABLES;

-- =========================================================
-- SECTION 7: FINAL VERIFICATION
-- =========================================================

-- Final data verification for all main tables
SELECT '=== PRODUCT TABLE ===' AS '';
SELECT * FROM product ORDER BY product_id;

SELECT '=== CAR TABLE ===' AS '';
SELECT * FROM car;

SELECT '=== VERIFY TABLE ===' AS '';
SELECT * FROM verify;

SELECT '=== ORDERS TABLE ===' AS '';
SELECT * FROM orders;

SELECT '=== EMP_MAIN TABLE ===' AS '';
SELECT * FROM emp_main;

SELECT '=== HIGH_PAID TABLE ===' AS '';
SELECT * FROM high_paid;

-- ===================================================================
-- MASTER SQL FILE: COMPLETE DATABASE OPERATIONS
-- QUESTIONS & SOLUTIONS
-- ===================================================================
-- Each question is followed immediately by its SQL solution.
-- Sections: Database Setup, Table Creation, Data Insertion,
-- Column Operations, Row Operations, Table Management, Final Verification
-- ===================================================================

-- ===================================================================
-- SECTION 1: DATABASE SETUP - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q1: How do you create a database named company_db only if it does not already exist?
CREATE DATABASE IF NOT EXISTS company_db;

-- Q2: How do you switch to (use) the company_db database?
USE company_db;

-- ===================================================================
-- SECTION 2: TABLE CREATION - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q3: Create a table called 'product' that demonstrates various numeric data types:
--     product_id (TINYINT UNSIGNED, PRIMARY KEY), product_no (SMALLINT UNSIGNED, UNIQUE),
--     product_serial (INT UNSIGNED, NOT NULL), product_price (DECIMAL(10,2), NOT NULL),
--     product_info (BIGINT), and created_at (TIMESTAMP with default CURRENT_TIMESTAMP).
CREATE TABLE product (
    product_id TINYINT UNSIGNED PRIMARY KEY,
    product_no SMALLINT UNSIGNED UNIQUE,
    product_serial INT UNSIGNED NOT NULL,
    product_price DECIMAL(10,2) NOT NULL,
    product_info BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Q4: Create a table called 'car' using string data types:
--     car_id (INT AUTO_INCREMENT PRIMARY KEY), car_name (CHAR(20) NOT NULL),
--     car_model (VARCHAR(50) NOT NULL), car_info (TEXT),
--     car_category (ENUM('electric','diesel','petrol') NOT NULL),
--     and a composite UNIQUE constraint on (car_name, car_model).
CREATE TABLE car (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    car_name CHAR(20) NOT NULL,
    car_model VARCHAR(50) NOT NULL,
    car_info TEXT,
    car_category ENUM('electric','diesel','petrol') NOT NULL,
    UNIQUE(car_name, car_model)
);

-- Q5: Create a table called 'verify' that uses BOOLEAN data types:
--     verify_id (INT AUTO_INCREMENT PRIMARY KEY), is_delivered (BOOLEAN DEFAULT FALSE),
--     is_active (BOOLEAN DEFAULT TRUE).
CREATE TABLE verify (
    verify_id INT AUTO_INCREMENT PRIMARY KEY,
    is_delivered BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Q6: Create a table called 'orders' that uses temporal data types:
--     order_id (INT AUTO_INCREMENT PRIMARY KEY), order_date (DATE NOT NULL),
--     order_time (TIME NOT NULL), order_datetime (DATETIME NOT NULL),
--     order_timestamp (TIMESTAMP DEFAULT CURRENT_TIMESTAMP), delivery_date (DATE),
--     with a CHECK constraint ensuring delivery_date >= order_date.
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_datetime DATETIME NOT NULL,
    order_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_date DATE,
    CHECK (delivery_date >= order_date)
);

-- Q7: Create an 'employees_data' table with columns:
--     employee_id (INT AUTO_INCREMENT PRIMARY KEY), employee_name (VARCHAR(100) NOT NULL),
--     employee_salary (DECIMAL(10,2)), employee_department (VARCHAR(50)), hire_date (DATE).
CREATE TABLE employees_data (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    employee_salary DECIMAL(10,2),
    employee_department VARCHAR(50),
    hire_date DATE
);

-- ===================================================================
-- SECTION 3: INITIAL DATA INSERTION - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q8: Insert three sample rows into the product table.
INSERT INTO product (product_id, product_no, product_serial, product_price, product_info)
VALUES 
(1, 1001, 123456, 999.99, 9876543210),
(2, 2002, 222222, 1999.99, 1234567890),
(3, 3003, 333333, 2999.99, 1111111111);

-- Q9: Insert sample data into the car table (Tesla, Toyota, Honda).
INSERT INTO car (car_name, car_model, car_info, car_category)
VALUES 
('Tesla', 'Model S', 'Electric luxury sedan', 'electric'),
('Toyota', 'Camry', 'Mid-size sedan', 'petrol'),
('Honda', 'Civic', 'Compact car', 'petrol');

-- Q10: Insert three rows into the verify table with different boolean combinations.
INSERT INTO verify (is_delivered, is_active)
VALUES 
(TRUE, TRUE), 
(FALSE, TRUE),
(TRUE, FALSE);

-- Q11: Insert three sample orders into the orders table.
INSERT INTO orders (order_date, order_time, order_datetime, delivery_date)
VALUES 
('2024-01-01', '10:30:00', '2024-01-01 10:30:00', '2024-01-05'),
('2024-01-02', '14:15:00', '2024-01-02 14:15:00', '2024-01-06'),
('2024-01-03', '09:45:00', '2024-01-03 09:45:00', '2024-01-07');

-- Q12: Insert four sample employees into employees_data.
INSERT INTO employees_data (employee_name, employee_salary, employee_department, hire_date)
VALUES
('John Doe', 45000, 'IT', '2023-01-15'),
('Jane Smith', 55000, 'HR', '2023-02-20'),
('Bob Johnson', 65000, 'IT', '2023-03-10'),
('Alice Brown', 75000, 'Finance', '2023-04-05');

-- ===================================================================
-- SECTION 4: COLUMN LEVEL OPERATIONS - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q13: Show the structure (columns) of the product, car, verify, and orders tables.
SHOW COLUMNS FROM product;
SHOW COLUMNS FROM car;
SHOW COLUMNS FROM verify;
SHOW COLUMNS FROM orders;

-- Q14: Select all data from each table to verify initial data.
SELECT * FROM product;
SELECT * FROM car;
SELECT * FROM verify;
SELECT * FROM orders;
SELECT * FROM employees_data;

-- Q15: Add three new columns to the product table at once:
--     product_status (VARCHAR(20) DEFAULT 'available'),
--     product_rating (DECIMAL(3,2) with CHECK constraint rating <= 5),
--     product_code (VARCHAR(50) UNIQUE).
ALTER TABLE product
ADD COLUMN product_status VARCHAR(20) DEFAULT 'available',
ADD COLUMN product_rating DECIMAL(3,2) CHECK (product_rating <= 5),
ADD COLUMN product_code VARCHAR(50) UNIQUE;

-- Q16: Add a temporary column temp_first_col as INT at the first position of the product table.
ALTER TABLE product
ADD COLUMN temp_first_col INT FIRST;

-- Q17: Add a temporary column temp_after_col as VARCHAR(50) immediately after product_price.
ALTER TABLE product
ADD COLUMN temp_after_col VARCHAR(50) AFTER product_price;

-- Q18: Modify the product_price column to DECIMAL(12,2) to allow larger numbers.
ALTER TABLE product
MODIFY COLUMN product_price DECIMAL(12,2);

-- Q19: Rename the column product_info to product_details.
ALTER TABLE product
RENAME COLUMN product_info TO product_details;

-- Q20: Safely add a PRIMARY KEY on verify_id (drop any existing primary key first).
ALTER TABLE verify
DROP PRIMARY KEY;
ALTER TABLE verify
ADD PRIMARY KEY (verify_id);

-- Q21: Add a UNIQUE constraint named unique_car_model on the car_model column of the car table.
ALTER TABLE car
ADD CONSTRAINT unique_car_model UNIQUE(car_model);

-- Q22: Drop the temporary column temp_first_col from the product table.
ALTER TABLE product
DROP COLUMN temp_first_col;

-- Q23: Verify all column changes on product table using DESCRIBE and SELECT.
DESCRIBE product;
SELECT * FROM product;

-- ===================================================================
-- SECTION 5: ROW LEVEL OPERATIONS - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q24: Insert a complete row into the product table (including all columns).
INSERT INTO product VALUES
(4, 4004, 444444, 3999.99, 9999999999, NOW(), 'available', 4.5, 'P004', 'extra');

-- Q25: Insert a row into product specifying only some columns (product_id, product_no, product_serial, product_price).
INSERT INTO product (product_id, product_no, product_serial, product_price)
VALUES (5, 5005, 555555, 4999.99);

-- Q26: Update multiple columns (price, status) for a single row where product_id = 1.
UPDATE product
SET product_price = 2500.00,
    product_status = 'sold'
WHERE product_id = 1;

-- Q27: Update multiple columns (price, code, rating) for a different row (product_id = 2).
UPDATE product
SET product_price = 2700.00,
    product_code = 'UPDATED_CODE',
    product_rating = 4.8
WHERE product_id = 2;

-- Q28: Update multiple rows using CASE expressions:
--     - Set product_price = 3000 for product_id=1, 3500 for product_id=2, else unchanged.
--     - Set product_status = 'premium' if price > 3000, else 'standard'.
--     - Set product_rating = 4.2 for product_id=1, 4.9 for product_id=2, else unchanged.
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

-- Q29: Delete the row where product_id = 3.
DELETE FROM product
WHERE product_id = 3;

-- Q30: Delete all rows where product_price is less than 2000.
DELETE FROM product
WHERE product_price < 2000;

-- Q31: Use REPLACE INTO to insert or overwrite product_id = 1 with new values.
REPLACE INTO product (product_id, product_no, product_serial, product_price)
VALUES (1, 9999, 888888, 5000.00);

-- Q32: Verify all row changes in product table, ordered by product_id.
SELECT * FROM product ORDER BY product_id;

-- ===================================================================
-- SECTION 6: TABLE MANAGEMENT OPERATIONS - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q33: Show all tables in the current database.
SHOW TABLES;

-- Q34: Describe the structure of the employees_data table.
DESCRIBE employees_data;

-- Q35: Clone the structure of employees_data into a new table called emp_clone (without data).
CREATE TABLE emp_clone LIKE employees_data;

-- Q36: Create a new table high_paid that contains only rows from employees_data where salary > 60000.
CREATE TABLE high_paid AS
SELECT * FROM employees_data WHERE employee_salary > 60000;

-- Q37: Verify the contents of emp_clone and high_paid tables.
SELECT * FROM emp_clone;
SELECT * FROM high_paid;

-- Q38: Delete all employees from employees_data whose salary is less than 60000.
DELETE FROM employees_data WHERE employee_salary < 60000;

-- Q39: Verify that the delete operation worked correctly.
SELECT * FROM employees_data;

-- Q40: Truncate the emp_clone table (remove all data but keep the structure).
TRUNCATE TABLE emp_clone;

-- Q41: Verify that emp_clone is now empty.
SELECT * FROM emp_clone;

-- Q42: Rename the employees_data table to emp_main.
RENAME TABLE employees_data TO emp_main;

-- Q43: Verify the rename by listing all tables again.
SHOW TABLES;

-- ===================================================================
-- SECTION 7: FINAL VERIFICATION - QUESTIONS & SOLUTIONS
-- ===================================================================

-- Q44: Perform final verification of all main tables after all operations.
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

-- ===================================================================
-- END OF MASTER SCRIPT
-- ===================================================================

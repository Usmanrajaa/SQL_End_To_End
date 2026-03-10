CREATE DATABASE PRACTICE;
USE PRACTICE;
-- numeric datatypes
DROP TABLE product;
-- primary_key
-- CREATE TABLE product(
-- product_id TINYINT PRIMARY KEY,
-- product_no SMALLINT,
-- product_serial INT,
-- product_price DOUBLE(10,2),
-- product_info BIGINT
-- );
-- composite  primary key
CREATE TABLE product(
product_id TINYINT , -- digit capacity 3
product_no SMALLINT, -- digit capacity 5
product_serial INT,  -- digit capacity 10
product_price DOUBLE(10,2), 
product_info BIGINT, -- digit capacity 19
PRIMARY KEY (product_id,product_serial)
);
SELECT * FROM product;
DESCRIBE product;
INSERT INTO product
VALUES
(13,12,46758,44456.78,8957557758596);

-- string datatypes
CREATE TABLE car(
car_name CHAR(20),
car_model VARCHAR(50),
car_info  TEXT,
car_category ENUM("electric","dieseal","petrol")
);
INSERT INTO car
VALUES
('mahindra','2022','world is facing dire backlash in car production','petrol');

-- Employees not in these departments
SELECT * FROM employees
WHERE department NOT IN ('Sales', 'IT', 'HR');

-- Assuming we add some NULL values
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;

SELECT first_name, last_name, salary,
    CASE
        WHEN salary < 50000 THEN 'Low'
        WHEN salary BETWEEN 50000 AND 70000 THEN 'Medium'
        ELSE 'High'
    END AS salary_level
FROM employees;

-- Aliases(AS)
SELECT first_name AS "First Name",
       last_name AS "Last Name",
       salary AS "Annual Salary"
FROM employees;

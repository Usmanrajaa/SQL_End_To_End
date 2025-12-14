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


-- 1.Numeric Datatype

CREATE TABLE product(
product_id TINYINT , -- digit capacity 3
product_no SMALLINT, -- digit capacity 5
product_serial INT,  -- digit capacity 10
product_price DOUBLE(10,2), 
product_info BIGINT, -- digit capacity 19
);
INSERT INTO product
VALUES
(13,12,46758,44456.78,8957557758596);


-- 2.string datatypes

CREATE TABLE car(
car_name CHAR(20),
car_model VARCHAR(50),
car_info  TEXT,
car_category ENUM("electric","dieseal","petrol")
);
INSERT INTO car
VALUES
('mahindra','2022','world is facing dire backlash in car production','petrol');


-- 3.DATE AND TIME

CREATE TABLE sales(
sale_date DATE,
sale_time TIME,
purchased_at DATETIME,
delivered_at TIMESTAMP
);
INSERT INTO sales
VALUES
('2022-11-12','17:12:24','2022-11-12,17:12:24',NOW());
SELECT * FROM sales;


-- 4. BOOLEAN

CREATE TABLE verify(
is_delivered bool,
is_sold boolean
);
INSERT INTO verify
VALUES
(TRUE,FALSE);
SELECT * FROM verify;

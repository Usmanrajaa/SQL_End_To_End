CREATE DATABASE sql_pract;
use sql_pract;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    is_manager BOOLEAN
);

INSERT INTO employees VALUES
(1, 'John', 'Smith', 'Sales', 55000.00, '2020-03-15', FALSE),
(2, 'Sarah', 'Johnson', 'Marketing', 62000.00, '2019-07-22', TRUE),
(3, 'Michael', 'Williams', 'Sales', 48000.00, '2021-01-10', FALSE),
(4, 'Emily', 'Brown', 'HR', 58000.00, '2018-11-05', FALSE),
(5, 'David', 'Jones', 'IT', 75000.00, '2017-05-30', TRUE),
(6, 'Jessica', 'Garcia', 'Sales', 52000.00, '2020-09-18', FALSE),
(7, 'Daniel', 'Miller', 'IT', 68000.00, '2019-04-12', FALSE),
(8, 'Lisa', 'Davis', 'Marketing', 59000.00, '2021-02-28', FALSE),
(9, 'Kevin', 'Rodriguez', 'HR', 53000.00, '2020-06-15', FALSE),
(10, 'Amanda', 'Martinez', 'Sales', 56000.00, '2018-12-01', TRUE);


CREATE TABLE managers AS
SELECT employee_id, first_name, last_name, department
FROM employees
WHERE is_manager = TRUE;
-- Enhanced employees table
ALTER TABLE employees ADD COLUMN manager_id INT REFERENCES employees(employee_id);
UPDATE employees SET manager_id = 5 WHERE employee_id IN (1, 2, 3, 4, 6, 7, 8, 9, 10);

-- Create performance_reviews table
CREATE TABLE performance_reviews (
    review_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    review_date DATE NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 5),
    reviewer_id INT REFERENCES employees(employee_id)
);

INSERT INTO performance_reviews (employee_id, review_date, score, reviewer_id) VALUES
(1, '2023-01-15', 4, 5),
(2, '2023-01-20', 5, 5),
(3, '2023-02-10', 3, 5),
(4, '2023-02-15', 4, 5),
(6, '2023-03-05', 2, 1),
(7, '2023-03-10', 4, 5),
(8, '2023-03-15', 3, 2),
(9, '2023-04-01', 5, 4),
(10, '2023-04-10', 4, 1),
(1, '2022-07-15', 3, 5),
(2, '2022-07-20', 4, 5);

-- Create sales_regions tableCREATE TABLE sales_regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL,
    manager_id INT REFERENCES employees(employee_id)
);

INSERT INTO sales_regions (region_name, manager_id) VALUES
('Northeast', 1),
('Southeast', 6),
('West', 10);
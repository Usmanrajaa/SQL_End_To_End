-- Create employee_data table for hierarchical queries
CREATE TABLE employee_data (
    emp_id INT,
    emp_name VARCHAR(50),
    manager_id INT
);

-- Insert sample data
INSERT INTO employee_data VALUES
(1, 'A', NULL),
(2, 'B', 1),
(3, 'C', 2),
(4, 'D', 1),
(5, 'E', 2),
(6, 'f', 1),
(7, 'G', 3),
(8, 'H', 1),
(9, 'I', 9),
(10, 'J', 1),
(11, 'K', 7),
(12, 'L', 100),
(13, 'M', 101),
(14, 'N', 104),
(15, 'O', 109);
-- Departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(12,2)
);

INSERT INTO departments VALUES
(10, 'Sales', 'Building A', 1000000.00),
(20, 'Marketing', 'Building B', 800000.00),
(30, 'HR', 'Building C', 600000.00),
(40, 'IT', 'Building D', 1200000.00),
(50, 'Finance', 'Building E', 900000.00);

-- Update employees table to include dept_id
ALTER TABLE employees ADD COLUMN dept_id INT REFERENCES departments(dept_id);

UPDATE employees SET dept_id =
    CASE department
        WHEN 'Sales' THEN 10
        WHEN 'Marketing' THEN 20
        WHEN 'HR' THEN 30
        WHEN 'IT' THEN 40
        ELSE NULL
    END;

-- Projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2)
);

INSERT INTO projects VALUES
(1, 'Website Redesign', '2023-01-01', '2023-06-30', 50000.00),
(2, 'HR System Upgrade', '2023-02-15', '2023-08-31', 75000.00),
(3, 'Sales Training', '2023-03-01', '2023-04-30', 25000.00),
(4, 'Marketing Campaign', '2023-01-15', '2023-12-31', 150000.00),
(5, 'IT Security Audit', '2023-04-01', '2023-05-31', 60000.00);

-- Employee projects junction table
CREATE TABLE employee_projects (
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    hours_worked DECIMAL(5,2),
    PRIMARY KEY (employee_id, project_id)
);

INSERT INTO employee_projects VALUES
(1, 3, 40.5),
(2, 4, 85.0),
(3, 3, 35.0),
(5, 1, 60.0),
(5, 5, 45.5),
(7, 1, 75.0),
(7, 5, 30.0),
(10, 3, 50.0),
(4, 2, 90.0),
(9, 2, 55.0);
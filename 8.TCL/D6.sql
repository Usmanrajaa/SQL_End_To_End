-- Create roles and users for demonstrationCREATE ROLE finance_team;
CREATE ROLE hr_team;
CREATE ROLE sales_team;

CREATE USER finance_manager WITH PASSWORD 'secure123';
CREATE USER hr_rep WITH PASSWORD 'secure456';
CREATE USER sales_person WITH PASSWORD 'secure789';

GRANT finance_team TO finance_manager;
GRANT hr_team TO hr_rep;
GRANT sales_team TO sales_person;

-- Create tables with security considerationsCREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    pay_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    processed_by VARCHAR(50) DEFAULT CURRENT_USER,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_confidential (
    employee_id INT PRIMARY KEY,
    ssn VARCHAR(11) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    bank_account VARCHAR(20) NOT NULL
);

CREATE TABLE sales_leads (
    lead_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    assigned_to INT,
    status VARCHAR(20) DEFAULT 'New'
);
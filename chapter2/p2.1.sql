USE sql_pract;
SELECT * FROM employees;

-- Names starting with 'J'
SELECT * FROM employees WHERE first_name LIKE 'J%';

-- Names with 'son' anywhere
SELECT * FROM employees WHERE last_name LIKE '%son%';

-- Emails with exactly one character before the dot
SELECT * FROM employees WHERE email LIKE '_.%@company.com';

-- Names with second letter 'a'
SELECT * FROM employees WHERE first_name LIKE '_a%';

-- Employees without email
SELECT * FROM employees WHERE email IS NULL;

-- Employees with notes
SELECT * FROM employees WHERE notes IS NOT NULL;

-- NULL-safe comparison (returns nothing)
SELECT * FROM employees WHERE notes = NULL;-- Wrong!

SELECT employee_id,email,notes,middle_name,
COALESCE(email,'not valid email') AS corrected_mail,
COALESCE (notes,'not valide note') AS corrected_notes,
COALESCE(middle_name,'invalid middle_name') AS corrected_middle_name,
NULLIF(notes,'not valid note') AS cleaned_notes
FROM employees;

SELECT first_name,last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM employees;

SELECT first_name,
UPPER(first_name) AS upper_name,
LOWER(first_name) AS lower_name,
LENGTH(first_name) AS lenght_of_name
FROM employees;

SELECT first_name,
TRIM(first_name) AS trimmed,
LTRIM(first_name) AS left_trimmed,
RTRIM(first_name) AS rigth_trimmed
FROM employees;
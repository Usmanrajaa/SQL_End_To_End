-- Compare salary to department average
SELECT
    first_name,
    last_name,
    salary,
    dept_name,
    AVG(salary) OVER (PARTITION BY dept_name) AS dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY dept_name) AS diff_from_avg
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;


-- Divide employees into 4 salary brackets
SELECT
    first_name,
    last_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;


-- Divide employees into 4 salary brackets
SELECT
    first_name,
    last_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;


-- Running total of sales by month
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    SUM(amount) AS monthly_sales,
    SUM(SUM(amount)) OVER (ORDER BY DATE_TRUNC('month', sale_date)) AS running_total
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;

-- Difference from previous review scoreSELECT
    e.first_name,
    e.last_name,
    p.review_date,
    p.score,
    LAG(p.score) OVER (PARTITION BY p.employee_id ORDER BY p.review_date) AS prev_score,
    p.score - LAG(p.score) OVER (PARTITION BY p.employee_id ORDER BY p.review_date) AS score_change
FROM performance_reviews p
JOIN employees e ON p.employee_id = e.employee_id;


WITH employee_performance AS (
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        d.dept_name,
        e.salary,
        AVG(p.score) AS avg_score,
        COUNT(p.review_id) AS review_count
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    LEFT JOIN performance_reviews p ON e.employee_id = p.employee_id
    GROUP BY e.employee_id, e.first_name, e.last_name, d.dept_name, e.salary
)
SELECT
    employee_id,
    first_name,
    last_name,
    dept_name,
    salary,
    avg_score,
    review_count,
    RANK() OVER (ORDER BY avg_score DESC NULLS LAST) AS overall_rank,
    RANK() OVER (PARTITION BY dept_name ORDER BY avg_score DESC NULLS LAST) AS dept_rank,
    salary - AVG(salary) OVER (PARTITION BY dept_name) AS salary_diff_from_dept_avg
FROM employee_performance
ORDER BY overall_rank;


WITH region_sales AS (
    SELECT
        sr.region_id,
        sr.region_name,
        e.employee_id,
        e.first_name || ' ' || e.last_name AS sales_rep,
        COUNT(s.sale_id) AS sale_count,
        SUM(s.amount) AS total_sales,
        AVG(s.amount) AS avg_sale_amount
    FROM sales_regions sr
    JOIN employees e ON sr.manager_id = e.employee_id
    LEFT JOIN sales s ON e.employee_id = s.employee_id
    GROUP BY sr.region_id, sr.region_name, e.employee_id, e.first_name, e.last_name
)
SELECT
    region_id,
    region_name,
    sales_rep,
    sale_count,
    total_sales,
    avg_sale_amount,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS percent_of_total,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    FIRST_VALUE(sales_rep) OVER (ORDER BY total_sales DESC) AS top_performer,
    total_sales - LAG(total_sales) OVER (ORDER BY total_sales DESC) AS diff_from_next
FROM region_sales
ORDER BY sales_rank;


WITH dept_financials AS (
    SELECT
        d.dept_id,
        d.dept_name,
        d.budget,
        COUNT(e.employee_id) AS employee_count,
        SUM(e.salary) AS total_salary,
        SUM(e.salary) * 1.3 AS estimated_total_cost-- Salary + benefitsFROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.dept_name, d.budget
)
SELECT
    dept_id,
    dept_name,
    budget,
    employee_count,
    total_salary,
    estimated_total_cost,
    ROUND(estimated_total_cost * 100.0 / NULLIF(budget, 0), 2) AS budget_utilization_pct,
    CASE
        WHEN estimated_total_cost > budget THEN 'Over Budget'
        WHEN estimated_total_cost * 1.1 > budget THEN 'Near Budget Limit'
        ELSE 'Within Budget'
    END AS budget_status,
    RANK() OVER (ORDER BY ROUND(estimated_total_cost * 100.0 / NULLIF(budget, 0), 2) DESC) AS utilization_rank
FROM dept_financials
ORDER BY budget_utilization_pct DESC;

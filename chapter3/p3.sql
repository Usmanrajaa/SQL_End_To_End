USE sql_pract;
SELECT * FROM sales;
-- AGGREGATION 
SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT region) FROM sales;
SELECT region,COUNT(region) FROM sales
GROUP BY region;

SELECT region,SUM(amount) AS total_amount
FROM sales
GROUP BY region
HAVING SUM(amount)>20000;

SELECT region,AVG(amount) AS total_amount
FROM sales
GROUP BY region
HAVING AVG(amount)>10000;

SELECT region,MAX(amount) AS total_amount
FROM sales
GROUP BY region;

SELECT region,MIN(amount) AS total_amount
FROM sales
GROUP BY region;

SELECT
CASE 
WHEN amount<10000 THEN 'low'
WHEN amount BETWEEN 10000 AND 20000 THEN 'medium'
ELSE 'high'
END AS salary_label,
COUNT(*) AS COUNT
FROM sales
GROUP BY salary_label;


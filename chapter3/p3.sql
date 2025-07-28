USE sql_pract;
SELECT * FROM sales;
-- AGGREGATION 
SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT region) FROM sales;
SELECT region,COUNT(region) FROM sales
GROUP BY region;

SELECT region,SUM(amount) AS total_amount
FROM sales
GROUP BY region;

SELECT region,AVG(amount) AS total_amount
FROM sales
GROUP BY region;

SELECT region,MAX(amount) AS total_amount
FROM sales
GROUP BY region;

SELECT region,MIN(amount) AS total_amount
FROM sales
GROUP BY region;

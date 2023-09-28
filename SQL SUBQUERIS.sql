/*SUB-QUERIES*/

/*
Find the average number of events for each day for each channel.
*/

SELECT channel,AVG(num_events) AS avg_events
FROM
	(SELECT channel, FORMAT(occurred_at,'yyyy-mm-dd') AS day, COUNT(*) AS num_events
	FROM web_events
	GROUP BY channel, FORMAT(occurred_at,'yyyy-mm-dd')) AS events_table
GROUP BY channel
ORDER BY avg_events;

/*
Write an SQL query using a subquery to find customers who have made orders above the average order value
*/
/* A query used to calculate the average order value */
SELECT ROUND(SUM(total_amt_usd) / SUM(total),2) AS overall_average_order_value
	FROM orders

SELECT a.name,
	   o.total_amt_usd,
	   o.total,
	   (o.total_amt_usd) + (o.total) AS average_order_value
FROM accounts a 
INNER JOIN orders o
ON a.id = o.account_id
WHERE (o.total_amt_usd) / NULLIF((o.total),0) >
	(SELECT ROUND(SUM(total_amt_usd) / SUM(total),2) AS overall_average_order_value
	FROM orders)
ORDER BY average_order_value;

/*
Find only the orders that took place in the same month and year as the first order,
and then pull the average for each type of paper 'qty' in this month.
*/

SELECT AVG(standard_qty) AS avg_std_qty,
AVG(poster_qty) AS avg_post_qty, AVG(gloss_qty) AS avg_gloss_qty
FROM orders
WHERE FORMAT(occurred_at, 'yyyy-mm') =
(SELECT FORMAT (MIN(occurred_at),'yyy-mm') AS year_month
FROM orders);

/*
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
*/

SELECT AVG(total_spent) AS avg_top_ten_customer
FROM
	(SELECT TOP 10 a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
	FROM orders o
	INNER JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY total_spent DESC) top_ten_customer;


/*
What is the lifetime average amount spent in terms of total_amt_usd, including
only the companies that spent more per order, on average, than the average of all orders.
*/

SELECT AVG(avg_amt) AS avg_amt
FROM
	(SELECT account_id, AVG(total_amt_usd) AS avg_amt
	FROM orders
	GROUP BY account_id
	HAVING AVG(total_amt_usd) >
		(SELECT AVG(total_amt_usd) AS avg_all
		FROM orders)
	) AS above_avg_amt;


/*
Provide the name of the sales rep in each region with the largest sales amount.
*/

SELECT all_region_sales.sales_rep, all_region_sales.region, all_region_sales.total_amt
FROM
	(SELECT region, MAX(total_amt) AS max_amt
	FROM
		(SELECT s.name AS sales_rep, r.name AS region, SUM(total_amt_usd) AS total_amt
		FROM  orders o
		INNER JOIN accounts a
		ON o.account_id = a.id
		INNER JOIN sales_reps s
		ON a.sales_rep_id = s.id
		INNER JOIN region r
		ON r.id = s.region_id
		GROUP BY s.name, r.name) AS all_orders
	GROUP BY region) AS regions_sales
JOIN
	(SELECT s.name AS sales_rep, r.name AS region, SUM(total_amt_usd) AS total_amt
		FROM  orders o
		INNER JOIN accounts a
		ON o.account_id = a.id
		INNER JOIN sales_reps s
		ON a.sales_rep_id = s.id
		INNER JOIN region r
		ON r.id = s.region_id
		GROUP BY s.name, r.name) AS all_region_sales
ON regions_sales.region = all_region_sales.region AND regions_sales.max_amt = all_region_sales.total_amt;


/*
For the region with the largest sales total_amt_usd, how many total orders were placed?
*/

SELECT r.name AS region, COUNT(*) AS order_count
		FROM orders o
		INNER JOIN accounts a
		ON a.id = o.account_id
		INNER JOIN sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN region r
		ON r.id = s.region_id
		GROUP BY r.name
HAVING SUM(o.total_amt_usd) =
	(SELECT MAX(total_amt) AS max_amt
	FROM
		(SELECT r.name AS region, SUM(o.total_amt_usd) AS total_amt
		FROM orders o
		INNER JOIN accounts a
		ON a.id = o.account_id
		INNER JOIN sales_reps s
		ON s.id = a.sales_rep_id
		INNER JOIN region r
		ON r.id = s.region_id
		GROUP BY r.name) AS region_sales);
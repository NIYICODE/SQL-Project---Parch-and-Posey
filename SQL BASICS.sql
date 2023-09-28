/* SQL BASICS */
/* SELECT ALL COLUMNS IN ORDERS TABLE */
SELECT *
FROM orders;
-- There are 6912 rows and 11 columns in the order table --

/* SELECT ALL COLUMNS IN WEB EVENTS TABLE */
SELECT *
FROM web_events;
-- There are 9073 rows and 4 columns in the web_events table --

/* SELECT ALL COLUMNS IN SALES REPS TABLE */
SELECT *
FROM sales_reps;
-- There are 50 rows and 3 columns in the sales_reps table --

/* SELECT ALL COLUMNS IN THE REGION TABLE */
SELECT *
FROM region;
-- There are 4 rows and 2 columns in the region table --

/* SELECT ALL COLUMNS IN THE ACCOUNTS TABLE */
SELECT *
FROM accounts;

/* SORTING DATA
It is important to note that quite a number of SQL statements may be used to filter data, 
this aspect focuses on the Top statement to select minimum number of records.
NB: This is peculiar to the type of SQL flavor in use, for example, MYSQL and PostgreSQL uses LIMIT clause to perform this function
*/

/* WRITE A QUERY THAT DISPLAYS THE FIRST 10 ROWS IN THE web_events table, without the id column */

SELECT TOP 10 account_id, occurred_at, channel
FROM web_events;

/* WRITE A QUERY TO RETRIEVE THE DISTINCT CHANNELS IN THE web_events table */
SELECT DISTINCT channel
FROM web_events;
-- There are six distinct channels in the web events table

/* USING THE ORDER BY CLAUSE */

/* WRITE A QUERY TO RETURN THE 10 LATEST ORDERS IN THE ORDERS TABLE. INCLUDE THE ID, TIME AND TOTAL AMOUNT */
SELECT TOP 10 id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at DESC;

/* WRITE A QUERY TO RETURN THE TOP 10 ORDERS IN TERMS OF THE LARGEST TOTAL AMOUNT. INCLUDE THE ID, ACCOUNT_ID AND TOTAL AMOUNT */
SELECT TOP 10 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC;

/* WRITE A QUERY TO RETURN THE LOWEST 20 ORDERS IN TERMS OF TOTAL AMOUNT. INCLUDE THE ID, ACCOUNT_ID AND TOTAL AMOUNT */
SELECT TOP 20 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd;

/* WRITE A QUERY TO RETURN ALL COLUMNS EXCEPT ID IN THE ORDER TABLE, SORTED FIRST BY ACCOUNT_ID (IN ASCENDING ORDER)
AND TOTAL AMOUNT (IN DESCENDING ORDER) */
SELECT account_id, standard_qty, occurred_at, total_amt_usd
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC;

/* WRITE AN SQL QUERY TO RETRIEVE CUSTOMER NAMES IN ALPHABETICAL ORDER */
SELECT name 
FROM accounts 
ORDER BY name ASC;

/* FILTERING DATA
USING THE WHERE CLAUSE */

/* WRITE A QUERY TO RETRIEVE ORDERS MADE BY CUSTOMER WITH ACCOUNT_ID: 1001 */
SELECT *
FROM orders
WHERE account_id = 1001;

/* Write a query that returns the first 5 rows and all columns from the orders 
table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/

SELECT TOP 5 *
FROM orders
WHERE gloss_amt_usd >= 1000;

/*
Write a query that returns the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
*/
SELECT TOP 10 *
FROM orders
WHERE total_amt_usd <= 500;

/*
Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the 
Exxon Mobil Company in the accounts table.
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

/* USING ARITHMETIC OPERATORS */

/*
Create a column that divides the gloss_amount_usd by the gloss_quantity to find the unit price for the standard paper
paper for each order. Limit the results to the first 10 orders, and include the id and the account_id field.
*/

SELECT TOP 10 id, account_id, (gloss_amt_usd / gloss_qty) AS unit_price
FROM orders;

/*
Write a query that finds the percentage of revenue that comes from poster paper for each other.You will need to use only the
columns that ends with _usd. (Try to do this without using the total column). Display the id and the account_id_fields also.
*/

SELECT id, account_id,(poster_amt_usd/NULLIF(standard_amt_usd+gloss_amt_usd+poster_amt_usd,0))*100 AS poster_revenue
FROM orders;

/* USING the LIKE operator */

/*
Write a query that returns all the companies whose name starts with 'C'.
*/

SELECT *
FROM accounts
WHERE name LIKE 'C%';
-- Result shows 37 companies have their names begin with letter C --

/*
Write a query that returns all companies whose names contain the string 'one' somewhere in the name.
*/

SELECT *
FROM accounts
WHERE name LIKE '%one%';
-- Results show 5 companies have "one" somewhere in their name --

/*
Write a query that returns all companies whose names end with 's'.
*/

SELECT *
FROM accounts
WHERE name LIKE '%s';
-- Results show 81 companies have their names end with 's' --

/* USING THE IN operator */

/*
Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

/*
Use web_events table to find all information regarding all individuals who were contacted via organic or adwords channel
*/

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');
--Results show that 1858 individuals were contacted via organic or adwords channel--

/* USING NOT operator */

/*
Use web_events table to find all information regarding all individuals who were
contacted via any method except using organic or adwords methods.
*/

SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');
--Results show 7215 individuals were contacted via other means aside organic & adwords--

/* Use the accounts table to find:
all the companies whose name do not start with 'c'. */

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';
--Results show that 314 companies have their names begin with other letters other than c

/*all the companies whose names do not contain the string 'one'. */

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';
--Results show that 346 companies do not have 'one' anywhere in their name--

/* USING AND and BETWEEN operators */

/*
Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
*/

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;
--Results show 2 orders fall into this category--

/*
Using the accounts table, find all the companies whose names do not start with 'c' but end with 's'.
*/

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';
--Results show 69 companies whose names do not start with 'c' but ends with 's'--

/*
Write a query that displays the order date and gloss_qty data for all orders where gloss_qty data is between 24 and 29.
*/

SELECT occurred_at,gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;
-- Results show that 484 orders fall into the category where gloss_qty data is between 24 and 29. --


/*
Use the web_events table to find all the information regarding all individuals who were contacted via the organic
or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.
*/

SELECT *
FROM web_events
WHERE channel IN ('organic','adwords')
AND occurred_at BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY occurred_at DESC;
-- Results show that 1022 individuals were contacted via the organic or adwords channels, and started their account at any point in 2016 --

/* USING the OR operator */

/*
Find the list of order_ids where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table.
*/

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

/*
Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
*/

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty >1000);

/*
Find all company names that start with a 'C' or 'W', and the primary contact contains 'ana, or 'Ana', but it doesn't contain 'eana'.
*/

SELECT *
FROM accounts
WHERE name LIKE 'C%' OR name LIKE 'W%'
AND primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%'
AND primary_poc NOT LIKE '%eana%';
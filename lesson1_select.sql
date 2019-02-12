/*
ALL STATEMENTS HAVE TO BE IN THE RIGHT ORDER OR ELSE SQL WILL RETURN AN ERROR
*/

/*
The following selects three columns from the web_events table and looks at the first
15 rows of the table
*/

SELECT occured_at, account_id, channel
FROM web_events
LIMIT 15;

/*
Using ORDER BY as in below is only temporary for the query, is you want to change
the defaullt from ascending to descending you can use ORDER BY DESC
*/

SELECT occured_at, account_id, channel
FROM web_events
ORDER BY occured_at DESC
LIMIT 15;

/*
Using ORDER BY to sort using 2 columns. it will first sort the first column 
and then sort the second. this is useful if for example you have id numbers (column 1)and
want to see the data asscoaited with each id number in order (column 2)
*/

SELECT occured_at, account_id, channel
FROM web_events
ORDER BY account_id, occured_at DESC
LIMIT 5

/*
Using WHERE you can display subsets of tables based on conditions (filtering data)
>, <, <=, >=, =, !=
*/

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
you need to use a string for non numeric values for where. YOU MUST USE SINGLE
QUOTES!!
*/

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

/*
you can derive new columsn using operators on old columns and the statement AS
SQL follows order of operations so use perenthesis where necessary 
*/

SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price 
FROM orders
LIMIT 20

SELECT id, account_id, poster_amt_usd/(total_amt_usd) AS post_per
FROM orders
LIMIT 10;

/*
LIKE, IN, NOT, AND & BETWEEN, OR are all operators you can use in sql
*/

/* finds all companies whose name starts with C */

SELECT *
FROM accounts
WHERE name LIKE 'C%'

/*IN can be used to search for multiple = conditions as shown below with the 
different company names*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

/* the following pulls all companies that are not listed in the where statement */

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

/* The AND operator is used within a WHERE statement to consider more 
than one logical clause at a time */

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

/*using BETWEEN includes end points so in the below the data shown will include 24
and 29*/

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

/* or works like AND and can be used together as show below*/

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
           AND primary_poc NOT LIKE '%eana%');

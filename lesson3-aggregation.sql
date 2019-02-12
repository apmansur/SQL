/*COUNT SUM MIN MAX AVG all functions down columns not across rows*/
/*NULL are different than 0 becase zero is an value where as NULL means no value
when writing you use WHERE x IS NULL or WHERE x IS NOT NULL, you need this because null 
is not a value (no = )*/

/* returns count of all none NULL rows*/

SELECT COUNT(*)
FROM accounts;

SELECT COUNT(accounts.id)
FROM accounts;

SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

/*to aggreagte accross rows just use regualr math*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/* finding the MEDIAN is very difficult and usually asked as an interview question 
If you want to count NULLs as zero, you will need to use SUM and COUNT
*/


SELECT MIN(occurred_at)
FROM orders;

/* MIN without aggregation */

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

SELECT MAX(occurred_at)
FROM web_events;

/*without aggregation*/

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(o.standard_amt_usd) AS std_avg,
	   AVG(o.gloss_amt_usd) AS glo_avg,
	   AVG(o.poster_amt_usd) AS pos_avg,
	   AVG(o.standard_qty) AS stdq_avg,
	   AVG(o.gloss_qty) AS gloq_avg,
	   AVG(o.poster_qty) AS posq_avg
FROM orders o;


SELECT COUNT(total_amt_usd) AS num_rows, total_amt_usd
FROM orders
ORDER BY total_amt_usd ;

/*GRUP BY  can be used to aggregate data within subsets of the data. 
For example, grouping for different accounts, different regions, or 
different sales representative, goes between where and order by clause*/

/*SQL does aggregations before LIMIT clause*/

SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1

/* with aggregation the above is done as follows */

SELECT a.name, MIN(o.occurred_at) as date
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY date
LIMIT 1

/* the following shows the total amt USD for all orders for each account by name */

SELECT a.name, SUM(o.total_amt_usd)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name


SELECT MIN(w.occurred_at) as date , a.name
FROM web_events w
JOIN accounts a 
ON w.account_id = a.id
GROUP BY a.name
ORDER BY date
LIMIT 1

SELECT MIN(w.occurred_at) as date ,a.primary_poc
FROM web_events w
JOIN accounts a 
ON w.account_id = a.id
GROUP BY a.primary_poc
ORDER BY date
LIMIT 1

SELECT MIN(o.total_amt_usd) total_usd, a.name
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_usd

SELECT r.name region, COUNT(s.id) num_reps
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
GROUP BY r.name
ORDER BY num_reps

/* GROUP BY can have multiple inputs and the order doesnt matter, when you have
multiple inputsthough you should use ORDER BY to sort them. here order does matter
as it will be done from left to right*/

SELECT a.name,
	   AVG(o.poster_qty) posterAVG,
	   AVG(o.standard_qty) stdAVG,
       AVG(o.gloss_qty) gloAVG
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name


SELECT a.name,
	   AVG(o.poster_amt_usd) posterAVG,
	   AVG(o.standard_amt_usd) stdAVG,
       AVG(o.gloss_amt_usd) gloAVG
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name

SELECT s.name rep, COUNT(w.channel), w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY count DESC

SELECT r.name region, COUNT(w.channel), w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY count DESC

/*DISTINCT can be used once in the select statement and would retur the unique rows
across all columns included, it slows quereies down though */

SELECT a.name account, r.name region
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r 
ON r.id = s.region_id
ORDER BY a.name

/* here you can use the above and below results count to check that each account
is associated with just one region*/

SELECT DISTINCT id, name
FROM accounts;

/*to filter on aggregate columns you cant use WHERE, you ahev to use HAVING*/
/*the following shows all representaives that have more than 5 acccounts */

SELECT COUNT(a.name) accounts, s.name rep
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.name) > 5

SELECT COUNT(o.id), a.name
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.id) > 20

SELECT COUNT(o.id) count, a.name
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY count DESC
LIMIT 1

SELECT a.name account, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000

SELECT a.name account, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name 
ORDER BY total DESC

SELECT a.name account, COUNT(w.channel) facebook
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(w.channel) > 6
ORDER BY facebook

SELECT a.name account, COUNT(w.channel), w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.name, w.channel
ORDER BY count DESC


/*DATE_TRUNC*/

DATE_TRUNC('second', 2017-04-01 12:15:01) /*2017-04-01 12:15:01*/
DATE_TRUNC('day', 2017-04-01 12:1501) /*2017-04-01 00:00:00	*/
DATE_TRUNC('month', 2017-04-01 12:1501)/*2017-04-01 00:00:00*/
DATE_TRUNC('year', 2017-04-01 12:1501)/*2017-01-01 00:00:00*/

/*DATE_PART used with the above just pulls out the one part 'second' 'dow' (day of week)
etc*/

 SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

 SELECT DATE_PART('month', occurred_at) ord_month,  COUNT(*) total_orders
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*CASE goes in SELECT clause, if then logic. WHEN condiition THEN do this END
like if statements, these are read top to bottom so you need to avoid overlapping 
or at least go from narrow to broad*/

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

/* the above becomes the below */

SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

SELECT o.id,o.account_id,o.total_amt_usd,
	   CASE WHEN o.total_amt_usd >= 3000 THEN 'Large'
	   		ELSE 'Small' END AS order_level
FROM orders o

SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

SELECT s.name rep,  COUNT(o.id) orders, CASE WHEN COUNT(o.id) > 200 THEN 'Top' ELSE 'Not' END AS rank
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY s.name

SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;

# in order to add together groups created by case, it is good to use 0 and 1 

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;






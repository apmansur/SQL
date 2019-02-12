/*subqueries, inner query runs first and outer query will run 
acorss the reulst set created by the inner query*/

SELECT channel, AVG(count) avg_events
FROM
(SELECT w.channel,COUNT(*) count, DATE_TRUNC('day', w.occurred_at) AS day
FROM web_events w
GROUP BY 3,1) sub /*you can put whatever here this is just the sub table name*/
GROUP BY 1

/*make sure your formatting is easy to read */

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;

/*Note that you should not include an alias when you write a subquery 
in a conditional statement. This is because the subquery is treated as an 
individual value (or set of values in the IN case) rather than as a table.*/

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1 /*gives total amount for each rep and given region for rep*/
     GROUP BY 1) t2 /*gives the region name and the max earned by rep but no rep name*/
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3 /*joins the names of the reps to the final table*/
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =(SELECT id
                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC
                           LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;

/*WITH statement is called a Common Table Expression or CTE break your queries
into sperate companants makig it wasier to read*/

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;


WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC), 
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;


WITH table1 AS (
				SELECT r.name region, SUM(o.total_amt_usd) total, COUNT(o.total_amt_usd) orders
				FROM region r
				JOIN sales_reps s
				ON s.region_id = r.id
				JOIN accounts a
				ON a.sales_rep_id = s.id
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY 1)
SELECT region, MAX(orders)
FROM table1
GROUP BY 1
ORDER BY MAX DESC
LIMIT 1

WITH table1 AS (
				SELECT a.name account, SUM(o.standard_qty) standard_qty, SUM(o.total) total_qty
				FROM accounts a
				JOIN orders o
				ON o.account_id = a.id
				GROUP BY 1
				ORDER BY standard_qty DESC
				LIMIT 1
				),
	table2 AS (
				  SELECT a.name
				  FROM orders o
				  JOIN accounts a
				  ON a.id = o.account_id
				  GROUP BY 1
				  HAVING SUM(o.total) > (SELECT total_qty FROM table1)
		)
SELECT COUNT(*)
FROM table2;

WITH table1 AS (
				SELECT a.id id, a.name , SUM(o.total_amt_usd) total
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY 1, 2
				ORDER BY 3 DESC
				LIMIT 1
				)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT id FROM table1)
GROUP BY 1,2
ORDER BY 3 

WITH table1 AS (
	SELECT a.name, SUM(o.total_amt_usd) total
	FROM accounts a
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 10)

SELECT AVG(total)
FROM table1

WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;












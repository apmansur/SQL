#a window function performs a calculation across 
#a set of table rows that are somehow related to the current row
#OVER
#PARTITION BY
#You can’t use window functions and standard aggregations in the same query. 
#More specifically, you can’t include window functions in a GROUP BY clause.

SELECT standard_amt_usd,
	   SUM(standard_amt_usd) OVER (ORDER BY occurred_at ) AS SUM_TIME
FROM orders 

WITH table1 AS(
		SELECT standard_amt_usd,
		       DATE_TRUNC('year', occurred_at) as year,
		       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
		FROM orders
		)
SELECT t1.year,
	   MAX(running_total)
FROM table1 t1
GROUP BY t1.year
ORDER BY 1

#RANK() :Returns the rank of each row within the partition of a result set. 
#The rank of a row is one plus the number of ranks that come before the row in question.


SELECT o.id, o.account_id, o.total,
RANK() OVER (PARTITION BY o.account_id ORDER BY total DESC) AS total_rank
FROM orders o

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

#he ORDER and PARTITION define what is referred to as the “window”—the ordered subset of data over 
#which calculations are made. Removing ORDER BY just leaves an unordered 
#leaving the ORDER BY out is equivalent to "ordering" in a way that all rows in the partition are "equal" to 
#each other. Indeed, you can get the same effect by explicitly adding the ORDER BY clause like this: ORDER BY 0 
#(or "order by" any constant expression), or even, more emphatically, ORDER BY NULL

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders

#using WINDOW function is basically saving a certain window of data as a variable 
#that you can use instead of constantly repeating the same partition
# so the following turns into

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders

#now with WINDOW clause


SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders 
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

#LAG :It returns the value from a previous row to the current row in the table.
#LEAD :Return the value from the row following the current row in the table.



WITH table1 AS (
	SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  	FROM orders 
 	GROUP BY 1
)

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM table1


#NTILE(*# of buckets*)
#when you use a NTILE function but the number of rows in the partition is less 
#than the NTILE(number of groups), then NTILE will divide the rows into as many 
#groups as there are members (rows) in the set but then stop short of the 
#requested number of groups

SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC

 SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders 
 ORDER BY account_id DESC

 SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
  FROM orders 
 ORDER BY account_id DESC


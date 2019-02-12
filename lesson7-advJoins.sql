#FULL OUTER JOIN

SELECT *
  FROM accounts
 FULL OUTER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
 WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL

#INEQUALITY JOIN
#filtering in the join clause will eliminate rows before they are joined, 
#while filtering in the WHERE clause will leave those rows in and produce some nulls.


#here the inequaity join makes it so that the the primary poc comes before the rep
#name alphebetically
#in SQL SERVER and MySQL case is be defualt insensitive
#this works on strings and numbers because of char value
SELECT s.id, a.primary_poc, 
		s.name rep, 
		a.name account
FROM accounts a
LEFT JOIN sales_reps s
	ON a.sales_rep_id = s.id 
	AND a.primary_poc < s.name


#SELF JOIN :One of the most common use cases for self JOINs is in 
#cases where two events occurred, one after another

SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at

#UNION :use to merge two tables, UNION just merges distinct entries, UNION ALL merges all
#Both tables must have the same number of columns.
#Those columns must have the same data types in the same order as the first table.

WITH table1 AS(
		SELECT *
		FROM accounts
		WHERE name = 'Walmart'

		UNION ALL

		SELECT *
		FROM accounts
		WHERE name = 'Disney'
		)

SELECT COUNT(*)
FROM table1;

WITH double_accounts AS(
	SELECT *
	FROM accounts

	UNION ALL

	SELECT *
	FROM accounts)
SELECT name, COUNT(*)
FROM double_accounts
GROUP BY 1
ORDER BY 2





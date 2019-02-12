/* When setting up a database it is important to consider database normalization 
in which you decide what data should be stored together. This decision has to do
with data accesibility and how many changes in a single location can be made vs 
in several tables
/*

/*
Use inner join to add another table to the query. Then use on to specify the relationship 
between the tables. here the query is only pulling from the orders table because that
is what is in the select statemnet. Just like in regular programming you use 
dot noation to reference table properties(columns) 
*/


SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT orders.standard_qty, orders.gloss_qty, 
       orders.poster_qty,  accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Each table has a unique column called the primary key (PK). It is common for this column t
to be the first columb but not always. a foreign key(FK) is a column in one table
that is the primary key in aonther table. This combination links tables together. 
A table can have multiple foreign keys but only one primary key
*/

/*
SQL query has the two tables we would like to join - one in the FROM and the other in the JOIN. 
Then in the ON, we will ALWAYs have the PK equal to the FK
*/

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

/*
Joining 3 tables
*/

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

/*you can give a table name an alias and a column name an alias*/

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

/*or*/

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename t1
JOIN tablename2 t2

/*more examples*/

SELECT web_events.channel, web_events.occurred_at,accounts.primary_poc, accounts.name
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
WHERE name = 'Walmart';


SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

SELECT r.name region, a.name account, 
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

/*Left, Right and Full outer Joins
can also be LEFT OUTER JOIN
FULL OUTER JOIN
Left and Right Join: think of a venn diagram where the table in the FROM statement is the left 
table and the table in the LEFT JOIN statement is the table on the right. The table 
formed will show the over lapping information in the middle and the info from
the left table that did not match. The reverse is true for a right join. Both are
interchangable so most people use just LEFT JOIN
*/

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;


SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100
ORDER BY unit_price;

SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

SELECT a.name account, w.channel channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.id = 1001

SELECT o.occurred_at, a.name account, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;



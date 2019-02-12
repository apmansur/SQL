#table size is a huge factor
#aggregations slow down calculations
#joins slow down calcualtions
#different databases are designed/optimized to perform better in certain areas
#if other people are running queries concurrently with yours then that also
#slows you down

#TIPS
#for times sensitive data, limit timeframe
#to explore data limit your outputs and then put your final correct
#query on the full data set
#aggreations are performed before the limit so limiting outputs with agreagtions
#doesnt really save time
#in order to limit aggregation youll have to make a sub querry or use a with statemnet 
#to make a new table with just the limited rows you want


#for joins you can also make tables smmaller before you run the join
# you can use EXPLAIN to see the querry plant

EXPLAIN 
SELECT *
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE a.name = 'Walmart'

#gives
QUERY PLAN
Hash Join (cost=16.15..160.57 rows=49 width=232) #higher numbers for cost mean itll take longer
Hash Cond: (o.account_id = a.id)
-> Seq Scan on orders o (cost=0.00..125.40 rows=4940 width=96)
-> Hash (cost=16.12..16.12 rows=2 width=136)
-> Seq Scan on accounts a (cost=0.00..16.12 rows=2 width=136)
Filter: (name = 'Walmart'::bpchar) 

#you can keep testing your query by modifying and running explain to see if you 
#are reducing the cost

#its better to run aggregatiosn on subquereies and then join the two, this
#reduces runtime for the query

#FULL JOIN and COUNT above actually runs pretty fast—it’s the COUNT(DISTINCT) that takes forever.
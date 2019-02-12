# LEFT pulls a specified number of characters for each row in a specified column starting
#at the beggining
# RIGHT same as left but from the end
# LENGTH


SELECT RIGHT(a.website, 3) AS extension,
       COUNT(*) count
FROM accounts a
GROUP BY 1

SELECT LEFT(a.name, 1) AS first_letter,
       COUNT(*) count
FROM accounts a
GROUP BY 1
ORDER BY 1


#POSITION: finds the index of a character, sql begins with 1 ex: POSITION('1' IN 'column_name')
#STRPOS: same as position STRPOS(city_state, ',')
#both tthe above are case sensitive
#LOWER changes case of string to lowercase
#UPPER changes case of string o uppercase

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

# this does the same as the below except its sales reps names and position instead

SELECT LEFT(s.name, POSITION(' 'IN s.name) -1 ) first_name, 
RIGHT(s.name, LENGTH(s.name) - POSITION(' ' IN s.name)) last_name
FROM sales_reps s;

#concat and || do the same thing

WITH table1 AS (
		SELECT a.name, 
		a.primary_poc, 
		LEFT(a.primary_poc, STRPOS(a.primary_poc, ' ')- 1) first_name,
		RIGHT(a.primary_poc, LENGTH(a.primary_poc) - STRPOS(a.primary_poc, ' ')) last_name
		FROM accounts a
		)
SELECT name, 
	   primary_poc, 
	   first_name || '.' || last_name || '@' || name || '.com'
FROM table1 



WITH table1 AS (
		SELECT a.name, 
		a.primary_poc, 
		LEFT(a.primary_poc, STRPOS(a.primary_poc, ' ')- 1) first_name,
		RIGHT(a.primary_poc, LENGTH(a.primary_poc) - STRPOS(a.primary_poc, ' ')) last_name
		FROM accounts a
		)
SELECT name, 
	   primary_poc, 
	   LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1)|| RIGHT(LOWER(last_name), 1) || 
	   LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM table1 

#TO_DATE
#CAST
# Casting with :: most useful for turning strings in to numbers or dates
# dates in sql are logged as yyyy-mm-dd

# how to approach new dataset, first look at first ten rows to see data type etc

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

#COALESCE 
#agrregations do not incude NULL values so depending on the data set you might
#want to use coalesce to chnage null values, NULL for sql mean there is nothing
#its not zero

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COUNT(a.id),
	   COUNT(COALESCE(a.id, a.id)) modified
FROM accounts a





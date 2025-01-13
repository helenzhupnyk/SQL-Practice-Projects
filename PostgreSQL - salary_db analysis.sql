SELECT * FROM salaries LIMIT 10;

-- #1. Display salaries of ML Engineer in 2023, add sorting in ascending order.

SELECT
	year
	, job_title
	, salary_in_usd AS salary
FROM salaries
WHERE 
	year = 2023
	AND job_title = 'ML Engineer'
ORDER BY salary_in_usd ASC;


-- #2. Name the country (company_location) with the lowest salary for a Data Scientist in 2023

SELECT 
	comp_location
	, salary_in_usd
	, job_title
	, year
FROM salaries
WHERE 
	year = 2023
	AND job_title = 'Data Scientist'
ORDER BY 2 ASC
LIMIT 1;


-- #3. Display the top 5 salaries among all specialists who work completely remotely (remote_ratio = 100)


SELECT
	salary_in_usd
	, remote_ratio
FROM salaries
WHERE
	remote_ratio = 100
ORDER BY salary_in_usd DESC
LIMIT 5;


-- #4. Output unique values for a column (categorical)


SELECT
	DISTINCT comp_location
FROM salaries;


-- #5. Output count of unique values for a column


SELECT
	COUNT(DISTINCT comp_location)
FROM salaries;

-- #6. Output the average, minimum and maximum salary for 2023.

SELECT
	ROUND(AVG(salary_in_usd),2) AS salary_avg
	, MIN(salary_in_usd) as salary_min
	, MAX(salary_in_usd) as salary_max
FROM salaries
WHERE year = '2023';


-- #7. Display the 5 highest salaries in 2023 for representatives of the ML Engineer specialty. Transfer wages to CAD.


SELECT
	salary_in_usd
	, salary_in_usd * 1.45 AS salary_in_cad
	, job_title
	, year
FROM salaries
WHERE
	year = 2023
	AND job_title = 'ML Engineer'
ORDER BY salary_in_usd DESC
LIMIT 5;


-- #8. Output Unique values of remote_ratio column, data format must be fractional with two decimal places

-- Example: "50" should be displayed as "0.50"


SELECT
	DISTINCT ROUND((remote_ratio/100.0), 2) AS remote_frac
FROM salaries;


-- #9. Output the table data by adding the column 'exp_level_full' with the full name of the employee experience levels according to the column eхp_level


SELECT *
	, CASE 
		WHEN exp_level = 'EN'
		THEN 'Entry-level-level'
		WHEN exp_level = 'SE'
		THEN 'Senior'
		WHEN exp_level = 'MI'
		THEN 'Mid-level'
		ELSE 'Executive-level' END AS full_exp_level
FROM salaries
LIMIT 10;

--Example with salary colomn

SELECT *
	, CASE 
		WHEN salary_in_usd < 50000
		THEN 'Category 1'
		WHEN salary_in_usd < 100000
		THEN 'Category 2'
		WHEN salary_in_usd < 150000
		THEN 'Category 3'
		ELSE 'Category 4' END AS salary_level
FROM salaries
LIMIT 10;


-- #10. Examine all columns for missing values


SELECT COUNT(*) - COUNT(salary_in_usd) AS missing_values
FROM salaries;


/*
#11. For each profession and corresponding experience level:
- number in the table
- average salary
*/


SELECT 
	job_title
	, exp_level
	, COUNT(*) AS job_nmb
	, ROUND(AVG(salary_in_usd*1.45), 2) AS salary_avg_in_cad
FROM salaries
WHERE year =2023
GROUP BY job_title, exp_level 
ORDER BY 1,2;


-- #12. For professions that occur only once, indicate the salary


SELECT -- step 4
	job_title
--	, COUNT(*) AS job_nmb
	, ROUND(AVG(salary_in_usd*1.45), 2) AS salary_avg_in_cad
FROM salaries--step 1
WHERE year =2023 --2 
GROUP BY job_title --3
HAVING COUNT(*) = 1 --job title which is ocurs once
ORDER BY 2; --5 order by second column


-- #13. Display all specialists whose salaries are above the average in the table


SELECT *	
FROM salaries
WHERE salary_in_usd > 
(	
	SELECT AVG(salary_in_usd)
	FROM salaries
)
	AND year = 2023;


-- #14.Display all specialists who live in countries where the average salary is higher than the average among all countries.
-- 1) avg salary 
-- 2) avg salary for each country
-- 3) compare them and show list of countries
-- 4) job title that live and work in that countries


SELECT 
	comp_location
FROM salaries
WHERE year = 2023
GROUP BY 1
HAVING AVG(salary_in_usd) >
(
	SELECT AVG(salary_in_usd)
	FROM salaries
	WHERE year = 2023
);
--

SELECT * 
FROM salaries
WHERE emp_location IN (SELECT 
	comp_location
FROM salaries
WHERE year = 2023
GROUP BY 1
HAVING AVG(salary_in_usd) >
(
	SELECT AVG(salary_in_usd)
	FROM salaries
	WHERE year = 2023
));


-- #15. Find the minimum wage among the maximum wages countries
-- 1 part


SELECT 
	comp_location
	, MAX(salary_in_usd)
FROM salaries
GROUP BY 1;

-- final part inner query 
SELECT MIN(t.salary_in_usd)
FROM 
(	SELECT 
		comp_location
		, MAX(salary_in_usd) as salary_in_usd
	FROM salaries
	GROUP BY 1
) AS t
;


--another simple way 
SELECT 
	comp_location
	, MAX(salary_in_usd) as salary_in_usd
FROM salaries
GROUP BY 1
ORDER BY 2 ASC
LIMIT 1;


-- #16. For each profession, derive the difference between the average wage and salary
--the maximum salary of all specialists
-- step 1: max salary
-- step 2: table job_title and avg salary
-- step 3: result difference between them


SELECT MAX(salary_in_usd)
FROM salaries;

SELECT 
	job_title
	, AVG(salary_in_usd) -
(	
		SELECT MAX(salary_in_usd)
		FROM salaries
) AS diff
FROM salaries
GROUP BY 1;


-- #17. Display data on an employee who receives the second largest salary in


SELECT *
FROM 
(
	SELECT *
	FROM salaries
	ORDER BY salary_in_usd DESC
	LIMIT 2
) AS t
ORDER BY salary_in_usd ASC
LIMIT 1;

-- other way 

SELECT *
FROM salaries
ORDER BY salary_in_usd DESC
LIMIT 1 OFFSET 1;


-- #Data Research:


SELECT * 
FROM salaries
LIMIT 10;


SELECT COUNT(*)
FROM salaries;


SELECT COUNT(*)
	, COUNT(*) - COUNT(salary_in_usd) AS missing_values
FROM salaries;


SELECT
	job_title
	, COUNT(*)
FROM salaries
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;


-- #Descriptive Statistics


SELECT
	job_title
	, exp_level
	, MIN(salary_in_usd)
	, MAX(salary_in_usd)
	, ROUND(AVG(salary_in_usd),2) AS avg
	, ROUND(stddev(salary_in_usd),2) as std
FROM salaries
GROUP BY 1,2 


-- #Distribution of Values


SELECT 
	CASE
		WHEN salary_in_usd <= 10000 THEN 'A'
		WHEN salary_in_usd <= 20000 THEN 'B'
		WHEN salary_in_usd <= 50000 THEN 'C'
		WHEN salary_in_usd <= 100000 THEN 'D'
		WHEN salary_in_usd <= 200000 THEN 'E'
		ELSE 'F' END AS salary_category
	, COUNT(*)
FROM salaries
GROUP BY 1;


-- #Correlation of Values


SELECT 
	corr(remote_ratio, salary_in_usd)
FROM salaries;

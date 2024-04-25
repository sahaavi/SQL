-- show year, month, monthly revenue, and percent of current year
SELECT	*
FROM	adoptions;

SELECT	DATEPART (year, adoption_date) AS year,
		DATEPART (month, adoption_date) AS month,
		SUM (adoption_fee) AS month_total
FROM	adoptions
GROUP BY	DATEPART (year, adoption_date),
			DATEPART (month, adoption_date)
ORDER BY	year ASC,
			month ASC;


		
SELECT 	DATEPART (year, adoption_date) AS year,
		DATEPART (month, adoption_date) AS month,
		SUM (adoption_fee) AS month_total,
		CAST (100 * SUM (adoption_fee) 
					/	SUM (adoption_fee) 
						OVER (PARTITION BY DATEPART (year, adoption_date))
			 AS DECIMAL (5, 2)
			 ) AS annual_percent
FROM 	adoptions
GROUP BY 	DATEPART (year, adoption_date), 
			DATEPART (month, adoption_date)
ORDER BY 	year ASC,
			month ASC;

SELECT 	DATEPART (year, adoption_date) AS year,
		DATEPART (month, adoption_date) AS month,
		SUM (adoption_fee) AS month_total,
		CAST	(100 *  SUM (adoption_fee) 
						/	SUM ( SUM (adoption_fee)) 
							OVER (PARTITION BY DATEPART (year, adoption_date)) 
			AS DECIMAL (5, 2)
			) AS annual_percent
FROM 	adoptions
GROUP BY 	DATEPART (year, adoption_date), 
			DATEPART (month, adoption_date)
ORDER BY 	year ASC,
			month ASC;

WITH monthly_grouped_adoptions
AS
(
SELECT 	DATEPART (year, adoption_date) AS year,
		DATEPART (month, adoption_date) AS month,
		SUM (adoption_fee) AS month_total
FROM 	adoptions
GROUP BY 	DATEPART (year, adoption_date), 
			DATEPART (month, adoption_date)
)
SELECT 	*,
		CAST 	(100 * month_total 
				 / 	SUM (month_total) 
					OVER (PARTITION BY year) 
				AS DECIMAL (5, 2)
				) AS annual_percent
FROM 	monthly_grouped_adoptions
ORDER BY 	year ASC,
			month ASC;




/* 
----------------------------------------------------
-- Warm up challenge - Annual vaccinations report --
----------------------------------------------------

Write a query that returns all years in which animals were vaccinated, and the total number of vaccinations given that year.
In addition, the following two columns should be included in the results:
1. The average number of vaccinations given in the previous two years.
2. The percent difference between the current year's number of vaccinations, and the average of the previous two years.
For the first year, return a NULL for both additional columns.

Hint: Cast averages and division expressions to DECIMAL (5, 2)

Expected result sorted by year ASC:
---------------------------------------------------------------------------------------------
|	year	|	number_of_vaccinations	|	previous_2_years_average	|	percent_change	|
|-----------|---------------------------|-------------------------------|-------------------|
|	2,016	|					11		|					[NULL]		|		[NULL]		|
|	2,017	|					23		|					11.00		|		209.09		|
|	2,018	|					32		|					17.00		|		188.24		|
|	2,019	|					29		|					27.50		|		105.45		|
---------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Extra challenge: Try to find an alternative solution and post it in the Q&A section. ----------------------
-- Solutions that either perform better, are simpler, or highly creative, will receive an honorary mention. --
--------------------------------------------------------------------------------------------------------------
*/


WITH annual_vaccinations
AS
(
SELECT	CAST (DATEPART (year, vaccination_time) AS INT) AS year,
		COUNT (*) AS number_of_vaccinations
FROM 	vaccinations
GROUP BY DATEPART (year, vaccination_time)
)
-- SELECT * FROM annual_vaccinations ORDER BY year; -- Uncomment to execute preceding CTE
,annual_vaccinations_with_previous_2_year_average
AS
(
SELECT 	*,
		CAST (AVG (number_of_vaccinations) 
			   OVER (ORDER BY year ASC
					 RANGE BETWEEN 2 PRECEDING AND 1 PRECEDING 
					 -- Watch out for frame type...
					) 
			AS DECIMAL (5, 2)
			 )
		AS previous_2_years_average
FROM 	annual_vaccinations
-- WHERE year <> 2018 -- remove comment to check difference between ROWS and RANGE above
)
-- SELECT * FROM annual_vaccinations_with_previous_2_year_average ORDER BY year;
SELECT 	*,
		CAST ((100 * number_of_vaccinations / previous_2_years_average) 
			 AS DECIMAL (5, 2)
			 ) AS percent_change
FROM 	annual_vaccinations_with_previous_2_year_average
ORDER BY year ASC;

--------------------------------------------------------------------------------------------------------------
-- Extra challenge: Try to find an alternative solution and post it in the Q&A section. ----------------------
-- Solutions that either perform better, are simpler, or highly creative, will receive an honorary mention. --
--------------------------------------------------------------------------------------------------------------
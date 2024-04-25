/*
   ______                       _                _____      __      
  / ____/________  __  ______  (_)___  ____ _   / ___/___  / /______
 / / __/ ___/ __ \/ / / / __ \/ / __ \/ __ `/   \__ \/ _ \/ __/ ___/
/ /_/ / /  / /_/ / /_/ / /_/ / / / / / /_/ /   ___/ /  __/ /_(__  ) 
\____/_/   \____/\__,_/ .___/_/_/ /_/\__, /   /____/\___/\__/____/  
                     /_/            /____/                          
*/

-- Multi level aggregates
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date);

SELECT	YEAR(Adoption_Date) AS Year,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date);

SELECT	COUNT(*) AS Total_Adoptions
FROM	Adoptions
GROUP BY ();

-- Add UNION ALL... no good
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
UNION ALL
SELECT	YEAR(Adoption_Date) AS Year,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date)
UNION ALL
SELECT	COUNT(*) AS Total_Adoptions
FROM	Adoptions
GROUP BY ();

-- Try string placeholders... no good
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
UNION ALL
SELECT	YEAR(Adoption_Date) AS Year,
		'All Months' AS Month,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date)
UNION ALL
SELECT	'All Years' AS Year,	
		'All Months' AS Month,
		COUNT(*) AS Total_Adoptions
FROM	Adoptions
GROUP BY ()
ORDER BY Year, Month;

-- Use NULL placeholders... very good!
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
UNION ALL
SELECT	YEAR(Adoption_Date) AS Year,
		NULL AS Month,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date)
UNION ALL
SELECT	NULL AS Year,	
		NULL AS Month,
		COUNT(*) AS Total_Adoptions
FROM	Adoptions
GROUP BY ()
ORDER BY Year, Month;

-- Reuse lowest granularity aggregate in WITH clause
WITH Aggregated_Adoptions
AS
(
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
)
SELECT	*
FROM	Aggregated_Adoptions
UNION ALL
SELECT	Year,
		NULL,
		COUNT(*)
FROM	Aggregated_Adoptions
GROUP BY Year
UNION ALL
SELECT	NULL,
		NULL,
		COUNT(*)
FROM	Aggregated_Adoptions
GROUP BY ();


/* PostgreSQL
-- Reuse lowest granularity aggregate in WITH clause
WITH Aggregated_Adoptions
AS
(
SELECT	EXTRACT(year FROM Adoption_Date) AS Year,
		EXTRACT(month FROM Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY EXTRACT(year FROM Adoption_Date) , EXTRACT(month FROM Adoption_Date)
)
SELECT	*
FROM	Aggregated_Adoptions
UNION ALL
SELECT	Year,
		NULL,
		COUNT(*)
FROM	Aggregated_Adoptions
GROUP BY Year
UNION ALL
SELECT	NULL,
		NULL,
		COUNT(*)
FROM	Aggregated_Adoptions
GROUP BY ();
*/

-- GROUPING SETS
-- Equivalent to no GROUP BY
SELECT	COUNT(*) AS Total_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			()
		);

-- Equivalent to GROUP BY YEAR(Adoption_Date)
SELECT	YEAR(Adoption_Date) AS Year,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			YEAR(Adoption_Date)
		)
ORDER BY Year;

-- Equivalent to GROUP BY YEAR(Adoption_Date), MONTH(Adoption_Date)
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			(
				YEAR(Adoption_Date), MONTH(Adoption_Date)
			)
		)
ORDER BY Year, Month;

-- Be careful with the parentheses!
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			YEAR(Adoption_Date), MONTH(Adoption_Date)
		)
ORDER BY Year, Month;

-- All in one...
SELECT	YEAR(Adoption_Date) AS Year,
		MONTH(Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			(YEAR(Adoption_Date), MONTH(Adoption_Date)),
			YEAR(Adoption_Date),
			()
		)
ORDER BY Year, Month;

/* PostgreSQL
-- All in one...
SELECT	EXTRACT(year FROM Adoption_Date) AS Year,
		EXTRACT(month FROM Adoption_Date) AS Month,
		COUNT(*) AS Monthly_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			(EXTRACT(year FROM Adoption_Date), extract(month FROM Adoption_Date)),
			EXTRACT(year FROM Adoption_Date),
			()
		)
ORDER BY Year, Month;
*/

-- Non hierarchical grouping sets
SELECT	YEAR(Adoption_Date) AS Year,
		Adopter_Email,
		COUNT(*) AS Annual_Adoptions
FROM	Adoptions
GROUP BY GROUPING SETS	
		(
			YEAR(Adoption_Date),
			Adopter_Email
		);

-- Handling NULLs
SELECT	COALESCE(Species, 'All') AS Species,
		CASE 
			WHEN GROUPING(Breed) = 1
			THEN 'All'
			ELSE Breed
		END AS Breed,
		GROUPING(Breed) AS Is_This_All_Breeds,
		COUNT(*) AS Number_Of_Animals
FROM	Animals
GROUP BY GROUPING SETS 
		(
			Species,
			Breed,
			()
		)
ORDER BY Species, Breed;






/*
   ________          ____                    
  / ____/ /_  ____ _/ / /__  ____  ____ ____ 
 / /   / __ \/ __ `/ / / _ \/ __ \/ __ `/ _ \
/ /___/ / / / /_/ / / /  __/ / / / /_/ /  __/
\____/_/ /_/\__,_/_/_/\___/_/ /_/\__, /\___/ 
                                /____/       

Your last challenge is to write a query that returns a statistical report of vaccinations.
The report should include the total number of vaccinations for several dimensions:
🢂 Annual
🢂 Per species
🢂 For each species per year
🢂 By each staff member
🢂 By each staff member per species
And to make it interesting, let’s throw in the latest vaccination year for each of these groups.

Expected results:

┌───────────┬───────────────┬───────────────────────────────────┬───────────┬───────────┬───────────────────────┬───────────────────────┐
│Year		│Species		│Email								│First_Name	│Last_Name	│Number_Of_Vaccinations	│Latest_Vaccination_Year│
├───────────┼───────────────┼───────────────────────────────────┼───────────┼───────────┼───────────────────────┼───────────────────────┤
│2016		│All Species	│All Staff							│			│			│11						│2016					│
│2016		│Cat			│All Staff							│			│			│2						│2016					│
│2016		│Dog			│All Staff							│			│			│7						│2016					│
│2016		│Rabbit			│All Staff							│			│			│2						│2016					│
│2017		│All Species	│All Staff							│			│			│23						│2017					│
│2017		│Cat			│All Staff							│			│			│7						│2017					│
│2017		│Dog			│All Staff							│			│			│15						│2017					│
│2017		│Rabbit			│All Staff							│			│			│1						│2017					│
│2018		│All Species	│All Staff							│			│			│32						│2018					│
│2018		│Cat			│All Staff							│			│			│9						│2018					│
│2018		│Dog			│All Staff							│			│			│18						│2018					│
│2018		│Rabbit			│All Staff							│			│			│5						│2018					│
│2019		│All Species	│All Staff							│			│			│29						│2019					│
│2019		│Cat			│All Staff							│			│			│10						│2019					│
│2019		│Dog			│All Staff							│			│			│17						│2019					│
│2019		│Rabbit			│All Staff							│			│			│2						│2019					│
│All Years	│All Species	│All Staff							│			│			│95						│2019					│
│All Years	│All Species	│ashley.flores@animalshelter.com	│Ashley		│Flores		│34						│2019					│
│All Years	│All Species	│dennis.hill@animalshelter.com		│Dennis		│Hill		│5						│2019					│
│All Years	│All Species	│gerald.reyes@animalshelter.com		│Gerald		│Reyes		│10						│2019					│
│All Years	│All Species	│robin.murphy@animalshelter.com		│Robin		│Murphy		│11						│2019					│
│All Years	│All Species	│wanda.myers@animalshelter.com		│Wanda		│Myers		│28						│2019					│
│All Years	│All Species	│wayne.carter@animalshelter.com		│Wayne		│Carter		│7						│2019					│
│All Years	│Cat			│All Staff							│			│			│28						│2019					│
│All Years	│Cat			│ashley.flores@animalshelter.com	│Ashley		│Flores		│10						│2018					│
│All Years	│Cat			│dennis.hill@animalshelter.com		│Dennis		│Hill		│2						│2019					│
│All Years	│Cat			│gerald.reyes@animalshelter.com		│Gerald		│Reyes		│4						│2019					│
│All Years	│Cat			│robin.murphy@animalshelter.com		│Robin		│Murphy		│2						│2019					│
│All Years	│Cat			│wanda.myers@animalshelter.com		│Wanda		│Myers		│9						│2019					│
│All Years	│Cat			│wayne.carter@animalshelter.com		│Wayne		│Carter		│1						│2019					│
│All Years	│Dog			│All Staff							│			│			│57						│2019					│
│All Years	│Dog			│ashley.flores@animalshelter.com	│Ashley		│Flores		│23						│2019					│
│All Years	│Dog			│dennis.hill@animalshelter.com		│Dennis		│Hill		│2						│2019					│
│All Years	│Dog			│gerald.reyes@animalshelter.com		│Gerald		│Reyes		│3						│2019					│
│All Years	│Dog			│robin.murphy@animalshelter.com		│Robin		│Murphy		│7						│2019					│
│All Years	│Dog			│wanda.myers@animalshelter.com		│Wanda		│Myers		│16						│2019					│
│All Years	│Dog			│wayne.carter@animalshelter.com		│Wayne		│Carter		│6						│2019					│
│All Years	│Rabbit			│All Staff							│			│			│10						│2019					│
│All Years	│Rabbit			│ashley.flores@animalshelter.com	│Ashley		│Flores		│1						│2019					│
│All Years	│Rabbit			│dennis.hill@animalshelter.com		│Dennis		│Hill		│1						│2018					│
│All Years	│Rabbit			│gerald.reyes@animalshelter.com		│Gerald		│Reyes		│3						│2019					│
│All Years	│Rabbit			│robin.murphy@animalshelter.com		│Robin		│Murphy		│2						│2018					│
│All Years	│Rabbit			│wanda.myers@animalshelter.com		│Wanda		│Myers		│3						│2017					│
└───────────┴───────────────┴───────────────────────────────────┴───────────┴───────────┴───────────────────────┴───────────────────────┘

Guidelines:

🢂 	ORDER BY Year, Species, First_Name, Last_Name and be careful with the order by aliases...

*/


-- Start with a simple join
SELECT	*
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email;

-- Add grouping sets and required columns (doesn't work yet)
SELECT	YEAR(V.Vaccination_Time) AS Year,
		V.Species,
		V.Email,
		P.First_Name,
		P.Last_Name,
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year -- yes, this is legit!
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							YEAR(V.Vaccination_Time),
							V.Species,
							(YEAR(V.Vaccination_Time), V.Species),
							V.Email,
							(V.Email, V.Species)
						);

-- Try to add dummy aggregates for first name and last name
SELECT	YEAR(V.Vaccination_Time) AS Year,
		V.Species,
		V.Email,
		MAX(P.First_Name) AS First_Name, -- Dummy aggregate
		MAX(P.Last_Name) AS Last_Name, -- Dummy aggregate
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							YEAR(V.Vaccination_Time),
							V.Species,
							(YEAR(V.Vaccination_Time), V.Species),
							(V.Email),
							(V.Email, V.Species)
						);

-- Add NULL replacement with COALESCE, but what's wrong with first name and last name???
SELECT	COALESCE(CAST(YEAR(V.Vaccination_Time) AS VARCHAR(10)), 'All Years') AS Year,
		COALESCE(V.Species, 'All Species') AS Species,
		COALESCE(V.Email, 'All Staff') AS Email,
		COALESCE(MAX(P.First_Name), '') AS First_Name, -- Dummy aggregate
		COALESCE(MAX(P.Last_Name), '') AS Last_Name, -- Dummy aggregate
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							YEAR(V.Vaccination_Time),
							V.Species,
							(YEAR(V.Vaccination_Time), V.Species),
							(V.Email),
							(V.Email, V.Species)
						);

-- Must use the GROUPING function to distinguish "All staff" from individuals
SELECT	COALESCE(CAST(YEAR(V.Vaccination_Time) AS VARCHAR(10)), 'All Years') AS Year,
		COALESCE(V.Species, 'All Species') AS Species,
		COALESCE(V.Email, 'All Staff') AS Email,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.First_Name) -- Dummy aggregate
			ELSE ''
			END AS First_Name,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.Last_Name) -- Dummy aggregate
			ELSE ''
			END AS Last_Name,
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(YEAR(V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							YEAR(V.Vaccination_Time),
							V.Species,
							(YEAR(V.Vaccination_Time), V.Species),
							(V.Email),
							(V.Email, V.Species)
						)
ORDER BY Year, Species, First_Name, Last_Name;

/* PostgreSQL
SELECT	COALESCE(CAST(EXTRACT(YEAR FROM V.Vaccination_Time) AS VARCHAR(10)), 'All Years') AS Year,
		COALESCE(V.Species, 'All Species') AS Species,
		COALESCE(V.Email, 'All Staff') AS Email,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.First_Name) -- Dummy aggregate
			ELSE ' '
			END AS First_Name,
		CASE WHEN GROUPING(V.Email) = 0
			THEN MAX(P.Last_Name) -- Dummy aggregate
			ELSE ' '
			END AS Last_Name,
		COUNT(*) AS Number_Of_Vaccinations,
		MAX(EXTRACT(YEAR FROM V.Vaccination_Time)) AS Latest_Vaccination_Year
FROM	Vaccinations AS V
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
GROUP BY GROUPING SETS	(
							(),
							EXTRACT(YEAR FROM V.Vaccination_Time),
							V.Species,
							(EXTRACT(YEAR FROM V.Vaccination_Time), V.Species),
							(V.Email),
							(V.Email, V.Species)
						)
ORDER BY Year, V.Species NULLS FIRST, First_Name, Last_Name;
*/
USE Animal_Shelter; -- For SQL Server
-- Granular detail rows
SELECT	*
FROM	Adoptions;

-- How many were adopted?
SELECT	COUNT(*)	AS Number_Of_Adoptions
FROM	Adoptions;

-- But - beware!
SELECT	Name,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions;

-- Granular detail rows
SELECT	*
FROM	Vaccinations;

SELECT		Species,
			COUNT(*)	AS Number_Of_Vaccinations
FROM		Vaccinations
GROUP BY	Species;

-- Number of vaccinations per animal
SELECT		Name,
			Species,
			COUNT(*)	AS Number_Of_Vaccinations
FROM		Vaccinations
GROUP BY	Name,
			Species;

-- Beware!
SELECT		Name,
			Species,
			Vaccine,
			COUNT(*)	AS Number_Of_Vaccinations
FROM		Vaccinations
GROUP BY	Name,
			Species;


-- Dealing with NULLs
SELECT	Species, 
		Breed, 
		COUNT(*) AS Number_Of_Animals
FROM	Animals
GROUP BY Species, Breed;

SELECT	YEAR(Birth_Date) AS Year_Born, 
		COUNT(*) AS Number_Of_Persons
FROM	Persons
GROUP BY YEAR(Birth_Date);

SELECT	YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date) AS Age, 
		COUNT(*) AS Number_Of_Persons
FROM	Persons
GROUP BY YEAR(Birth_Date);

SELECT	City,
		MIN(YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date)) AS Oldest_Person,
		MAX(YEAR(CURRENT_TIMESTAMP) - YEAR(Birth_Date)) AS Youngest_Person,
		COUNT(*) AS Number_Of_Persons
FROM	Persons
GROUP BY City;

-- Eliminating duplicates
SELECT	Species, 
		Name
FROM	Vaccinations;

SELECT	Species, 
		Name
FROM	Vaccinations
GROUP BY Species, Name;

SELECT	DISTINCT 
		Species, 
		Name
FROM	Vaccinations;

SELECT	DISTINCT Species, 
		Name,
		COUNT(*) AS  Number_Of_Vaccines
FROM	Vaccinations;

SELECT	Species,
		--Name,
		COUNT(*) AS Number_Of_Vaccines
FROM	Vaccinations
GROUP BY Species, Name
ORDER BY Species, Number_Of_Vaccines;

SELECT	DISTINCT 
		Species, 
		--Name,
		COUNT(*) AS Number_Of_Vaccines
FROM	Vaccinations
GROUP BY Species, Name
ORDER BY Species, Number_Of_Vaccines;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
GROUP BY Adopter_Email
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
WHERE	COUNT(*) > 1
GROUP BY Adopter_Email
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
GROUP BY Adopter_Email
HAVING	COUNT(*) > 1
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
GROUP BY Adopter_Email
HAVING	COUNT(*) > 1 
		AND	
		Adopter_Email NOT LIKE '%gmail.com'
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
WHERE	Adopter_Email NOT LIKE '%gmail.com'
GROUP BY Adopter_Email
HAVING	COUNT(*) > 1
ORDER BY Number_Of_Adoptions DESC;

SELECT	Adopter_Email,
		COUNT(*) AS Number_Of_Adoptions
FROM	Adoptions
WHERE	Adopter_Email NOT LIKE '%gmail.com'
GROUP BY Adopter_Email
HAVING	COUNT(*) > 1
		AND 
		YEAR(Adoption_Date) = 2019
ORDER BY Number_Of_Adoptions DESC;

/*
Animal vaccination report
--------------------------

Write a query to report the number of vaccinations each animal has received.
Include animals that were never adopted.
Exclude all rabbits.
Exclude all Rabies vaccinations.
Exclude all animals that were last vaccinated on or after October first, 2019.

The report should return the following attributes:
Animals Name, Species, Primary Color, Breed,
and the number of vaccinations this animal has received,

-- Guidelines
Use the correct logical join types and force order if needed.
Use the  correct logical group by expressions.
*/

SELECT A.Name, A.Species, Primary_Color, Breed, count(V.Vaccine) AS Num_of_Vaccinations
FROM Animals AS A LEFT OUTER JOIN Vaccinations 
		AS V ON A.Name = V.Name AND A.Species = V.Species
WHERE A.Species <> 'Rabbit' AND
		(V.Vaccine <> 'Rabies' OR V.Vaccine IS NULL)
GROUP BY A.Species, A.Name, Primary_Color, Breed
HAVING	MAX(V.Vaccination_Time) <= '20191001' 
		OR
		MAX(V.Vaccination_Time) IS NULL
ORDER BY	A.Species,
			A.Name;

-- Solution from instructor
USE Animal_Shelter; -- For SQL Server

SELECT	AN.Name,
		AN.Species,
		MAX(AN.Primary_Color) AS Primary_Color, -- Dummy aggregate, functionally dependent.
		MAX(AN.Breed) AS Breed, -- Dummy aggregate, functionally dependent.
		COUNT(V.Vaccine) AS Number_Of_Vaccines
FROM	Animals AS AN
		LEFT OUTER JOIN 
		Vaccinations AS V
			ON	V.Name = AN.Name 
				AND 
				V.Species = AN.Species
WHERE	AN.Species <> 'Rabbit'
		AND
		(V.Vaccine <> 'Rabies' OR V.Vaccine IS NULL)
GROUP BY	AN.Species,
			AN.Name
HAVING	MAX(V.Vaccination_Time) < '20191001' 
		OR
		MAX(V.Vaccination_Time) IS NULL
ORDER BY	AN.Species,
			AN.Name;
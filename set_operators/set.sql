-- Animals that were not adopted
-- Using OUTER JOIN
SELECT	DISTINCT AN.Name, AN.Species
FROM	Animals AS AN
		LEFT OUTER JOIN
		Adoptions AS AD
			ON AD.Name = AN.Name AND AD.Species = AN.Species
WHERE	AD.Name IS NULL;

-- Using NOT EXISTS
SELECT	AN.Name, AN.Species
FROM	Animals AS AN
WHERE	NOT EXISTS	(
						SELECT	NULL
						FROM	Adoptions AS AD
						WHERE	AD.Name = AN.Name
								AND 
								AD.Species = AN.Species
					);
-- Row expressions
/* PostgreSQL row expressions
SELECT	Name, Species
FROM	Animals 
WHERE	(Name, Species) NOT IN (SELECT Name, Species FROM Adoptions);
*/

-- SQL Server "mimic row expressions" - Don't try this at home!
SELECT	Name, Species
FROM	Animals 
WHERE	CONCAT(Name, '|||', Species) 
			NOT IN 
			(SELECT CONCAT(Name, '|||', Species) FROM Adoptions);

-- The right way - Set Operators
SELECT	Name, Species
FROM	Animals
EXCEPT	
SELECT	Name, Species
FROM	Adoptions;

-- Animals that were adopted and vaccinated at least twice
SELECT	Name, Species
FROM	Adoptions
INTERSECT
SELECT	Name, Species
FROM	Vaccinations
GROUP BY Name, Species
HAVING	COUNT(*) > 1;



/*
Write a query to show which breeds were never adopted.

Expected results:

┌───────────┬───────────────┐
│Species	│Breed			│
├───────────┼───────────────┤
│Cat		│Turkish Angora	│
└───────────┴───────────────┘

Guidelines:

🢂 	Breeds that were never adopted are not the same logical question as animals that were never adopted.
	Breed is not an identifier of an animal.
	Breed may be NULL.
🢂	We have non-breed dogs and non-breed cats so remember to consider species. Breed alone isn’t enough.
🢂	Try the techniques we used to find animals that were never adopted: OUTER JOIN, NOT IN, and NOT EXISTS. 
	See if they work or not and why.
*/

-- Preview of the required tables
SELECT * FROM Animals --  100 rows
SELECT * FROM Adoptions -- 70 rows


SELECT DISTINCT Breed
FROM Animals
EXCEPT (SELECT DISTINCT Breed
FROM Animals An INNER JOIN Adoptions Ad
	ON An.Name = Ad.Name AND An.Species = Ad.Species)

-- Try the OUTER JOIN approach (doesn't work...)
SELECT	DISTINCT --	AN.Name,
					AN.Species, 
					AN.Breed 
FROM	Animals AS AN
		LEFT OUTER JOIN
		Adoptions AS AD
		ON	AN.Species = AD.Species
			AND
			AN.Name = AD.Name
WHERE	AD.Species IS NULL;

-- Do we have non breed animals that were adopted?
SELECT	*
FROM	Animals AS AN
		INNER JOIN 
		Adoptions AS AD
		ON	AD.Name = AN.Name 
			AND
			AD.Species = AN.Species
WHERE	AN.Breed IS NULL;

-- Try the NOT EXISTS approach (doesn't work...)
SELECT	DISTINCT Species, Breed
FROM	Animals AS AN
WHERE	NOT EXISTS	(
						SELECT	NULL
						FROM	Adoptions AS AD
						WHERE	AD.Name = AN.Name
								AND 
								AD.Species = AN.Species
					);

/* PostgreSQL
-- The NOT IN approach (doesn't work...)
SELECT	DISTINCT Species, Breed 
FROM	Animals AS AN1
WHERE	(Species, Breed) NOT IN (	SELECT	AN2.Species, AN2.Breed 
									FROM	Animals AS AN2
											INNER JOIN
											Adoptions AS AD
											ON	AN2.Species = AD.Species
												AND
												AN2.Name = AD.Name
								);

-- Remove NULLs from subquery (Does it work?)
SELECT	DISTINCT Species, Breed 
FROM	Animals AS AN1
WHERE	(Species, Breed) NOT IN (	SELECT	AN2.Species, AN2.Breed 
									FROM	Animals AS AN2
											INNER JOIN
											Adoptions AS AD
											ON	AN2.Species = AD.Species
												AND
												AN2.Name = AD.Name
									WHERE	AN2.Breed IS NOT NULL 
								);

-- Add Ferris, the non breed ferret that wasn't adopted
INSERT INTO Animals
(Name, Species, Primary_Color, Implant_Chip_ID, Breed, Gender, Birth_Date, Pattern, Admission_Date)
VALUES ('Ferris', 'Ferret', 'White', 'A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11', NULL, 'F', '20161122', 'Solid', '20171221');

-- Try again
SELECT	DISTINCT Species, Breed 
FROM	Animals AS AN1
WHERE	(Species, Breed) NOT IN (	SELECT	AN2.Species, AN2.Breed 
									FROM	Animals AS AN2
											INNER JOIN
											Adoptions AS AD
											ON	AN2.Species = AD.Species
												AND
												AN2.Name = AD.Name
									WHERE	AN2.Breed IS NOT NULL 
								);

-- Check what happens for NOT IN and an empty set subquery
SELECT	'Works'
WHERE	1 NOT IN (SELECT 1 WHERE FALSE);

-- Cleanup
DELETE FROM Animals WHERE name = 'Ferris' AND Species = 'Ferret';								
*/

-- The elegant solution
SELECT	Species, Breed
FROM	Animals
EXCEPT	
SELECT	AN.Species, AN.Breed 
FROM	Animals AS AN
		INNER JOIN
		Adoptions AS AD
		ON	AN.Species = AD.Species
			AND
			AN.Name = AD.Name;

/* PostgreSQL
-- Bonus solution using a different approach.
SELECT	DISTINCT Species, Breed
FROM	Animals AS AN1
WHERE	NOT EXISTS (
						SELECT	NULL
						FROM	Animals AS AN2
						WHERE	EXISTS (
											SELECT	NULL
											FROM	Adoptions AS AD
											WHERE	AD.Name = AN2.Name
													AND
													AD.Species = AN2.Species
													AND	
													AD.Species = AN1.Species
													AND
													AN1.Breed IS NOT DISTINCT FROM AN2.Breed
													)
					);										
*/


/*
    __          __                  __       __      _           
   / /   ____ _/ /____  _________ _/ /      / /___  (_)___  _____
  / /   / __ `/ __/ _ \/ ___/ __ `/ /  __  / / __ \/ / __ \/ ___/
 / /___/ /_/ / /_/  __/ /  / /_/ / /  / /_/ / /_/ / / / / (__  ) 
/_____/\__,_/\__/\___/_/   \__,_/_/   \____/\____/_/_/ /_/____/  
                                                                 
*/

-- Get animals' most recent vaccination
-- Using correlated subquery
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		(
			SELECT	Vaccine
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY
		) AS Last_Vaccine
FROM	Animals AS A
ORDER BY A.Name, Last_Vaccine;

-- Can't get vaccination time as well
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		(
			SELECT	Vaccine, V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY
		) AS Last_Vaccine
FROM	Animals AS A
ORDER BY 	A.Name, 
			Last_Vaccine;

-- Must repeat entire subquery...
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		(
			SELECT	Vaccine
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY
		) AS Last_Vaccine,
		(
			SELECT	V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY
		) AS Last_Vaccine_Time
FROM	Animals AS A
ORDER BY 	A.Name, 
			Last_Vaccine;

-- Can't get more than one vaccination...
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		(
			SELECT	Vaccine
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
		) AS Last_Vaccine
FROM	Animals AS A
ORDER BY 	A.Name, 
			Last_Vaccine;

-- This is what we logically need, but it doesn't work
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		CROSS JOIN 
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;

/* PostgreSQL:
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		CROSS JOIN LATERAL
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			LIMIT 3 OFFSET 0
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;


SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		LEFT OUTER JOIN LATERAL
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			LIMIT 3 OFFSET 0
		) AS Last_Vaccinations
			ON TRUE
ORDER BY 	A.Name, 
			Vaccination_Time;
*/

-- CROSS APPLY
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		CROSS APPLY
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;

-- OUTER APPLY
SELECT	A.Name,
		A.Species,
		A.Primary_Color,
		A.Breed,
		Last_Vaccinations.*
FROM	Animals AS A
		OUTER APPLY
		(
			SELECT	V.Vaccine, 
					V.Vaccination_Time
			FROM	Vaccinations AS V
			WHERE	V.Name = A.Name
					AND
					V.Species = A.species
			ORDER BY V.Vaccination_Time DESC
			OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY
		) AS Last_Vaccinations
ORDER BY 	A.Name, 
			Vaccination_Time;

-- Invocation wisdom
-- PostgreSQL
/*
SELECT	* 
FROM	Staff AS S 
		CROSS JOIN LATERAL 
		(SELECT random() AS Y) AS B;

SELECT	* 
FROM	Staff AS S 
		CROSS JOIN LATERAL 
		(SELECT random() AS Y WHERE S.Email IS NOT NULL) AS B;

SELECT	*, random()
FROM	Staff;
*/

-- SQL Server
SELECT	* 
FROM	Staff AS S
		CROSS APPLY
		(SELECT RAND() AS Y WHERE S.Email IS NOT NULL) AS B;

SELECT	RAND() AS 'Random???'
FROM	Staff;

SELECT	* 
FROM	Staff AS S 
		CROSS APPLY
		(SELECT NEWID() AS Y) AS B;

/*
  ________  ________   _______   ______ 
 /_  __/ / / / ____/  / ____/ | / / __ \
  / / / /_/ / __/    / __/ /  |/ / / / /
 / / / __  / /___   / /___/ /|  / /_/ / 
/_/ /_/ /_/_____/  /_____/_/ |_/_____/  
                                        
*/

/*
   ________          ____                    
  / ____/ /_  ____ _/ / /__  ____  ____ ____ 
 / /   / __ \/ __ `/ / / _ \/ __ \/ __ `/ _ \
/ /___/ / / / /_/ / / /  __/ / / / /_/ /  __/
\____/_/ /_/\__,_/_/_/\___/_/ /_/\__, /\___/ 
                                /____/       

Our shelter has been experiencing financial difficulties.
!!! PLEASE consider donating to your local animal shelter !!!
The board of directors decided to explore additional revenue sources and came up with an idea.
Instead of spaying and neutering all animals, the shelter should consider responsible breeding of purebred animals.
!!!	This is a hypothetical question – ALWAYS spay and neuter your pets !!! 

Your challenge is to figure out which animals are breeding candidates.

Expected result:

┌───────────┬───────────────┬───────────┬───────────┐
│Species	│Breed			│Male		│Female		│
├───────────┼───────────────┼───────────┼───────────┤
│Cat		│Sphynx			│Salem		│Nova		│
│Cat		│Turkish Angora	│Tigger		│Ivy		│
│Dog		│Bullmastiff	│Toby		│Penelope	│
│Dog		│Bullmastiff	│Toby		│Skye		│
│Dog		│Bullmastiff	│Jake		│Penelope	│
│Dog		│Bullmastiff	│Jake		│Skye       │
│Dog		│English setter	│Frankie	│Callie     │
│Dog		│English setter	│Frankie	│Nala       │
│Dog		│English setter	│Gus		│Callie     │
│Dog		│English setter	│Gus		│Nala       │
│Dog		│English setter	│Benji		│Callie     │
│Dog		│English setter	│Benji		│Nala       │
│Dog		│English setter	│Mac		│Callie     │
│Dog		│English setter	│Mac		│Nala       │
│Dog		│Schnauzer		│Boomer		│Emma       │
│Dog		│Schnauzer		│Boomer		│Lily       │
│Dog		│Schnauzer		│Brody		│Emma       │
│Dog		│Schnauzer		│Brody		│Lily       │
│Dog		│Weimaraner		│Brutus		│Lucy       │
│Dog		│Weimaraner		│Brutus		│Poppy      │
│Dog		│Weimaraner		│Brutus		│Roxy       │
│Dog		│Weimaraner		│Jax		│Lucy       │
│Dog		│Weimaraner		│Jax		│Poppy      │
│Dog		│Weimaraner		│Jax		│Roxy       │
└───────────┴───────────────┴───────────┴───────────┘    

Guidelines:

🢂 	Candidates should be male and female of the same species and breed.
🢂 	You may use any database you wish.
🢂 	Results are ordered by species and breed
                                                      
*/



-- In case you forgot to cleanup the previous demos...
DELETE FROM Adoptions WHERE Name = 'Duplicate';
DELETE FROM Animals WHERE Name IN ('Duplicate', 'Ferris');

-- 1. Start with a simple CROSS JOIN
SELECT	*
FROM	Animals AS A1
		CROSS JOIN
		Animals AS A2;

-- 2. Filter for same species and breed
SELECT	*
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
			ON	A1.Species = A2.Species
				AND
				A1.Breed = A2.Breed;

-- 3. Replace * with required column names
SELECT	A1.Species,
		A1.Breed AS Breed,
		A1.Name AS Male,
		A2.Name AS Female
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
			ON	A1.Species = A2.Species
				AND
				A1.Breed = A2.Breed
ORDER BY 	A1.Species, 
			A1.Breed;

-- 4. Add predicate or comment for future developers
SELECT	A1.Species,
		A1.Breed AS Breed,
		A1.Name AS Male,
		A2.Name AS Female
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
			ON	A1.Species = A2.Species
				AND
				A1.Breed = A2.Breed -- Removes NULL breeds
				-- AND 
				-- A1.Breed IS NOT NULL -- 
ORDER BY 	A1.Species, 
			A1.Breed;

-- 5. Don't match animals with themselves.
SELECT	A1.Species,
		A1.Breed AS Breed,
		A1.Name AS Male,
		A2.Name AS Female
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
			ON	A1.Species = A2.Species
				AND
				A1.Breed = A2.Breed -- Removes NULL breeds
				AND
				A1.Name <> A2.Name
ORDER BY 	A1.Species, 
			A1.Breed;

-- 6. Solution
SELECT	A1.Species,
		A1.Breed AS Breed,
		A1.Name AS Male,
		A2.Name AS Female
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
		ON	A1.Species = A2.Species
			AND
			A1.Breed = A2.Breed -- Removes NULL breeds
			AND
			A1.Name <> A2.Name
			AND
			A1.Gender = 'M'
			AND 
			A2.Gender = 'F'
ORDER BY 	A1.Species, 
			A1.Breed;

-- 7. Solution with > shortcut 
-- 	  !!! Only works if collation is dictionary based, and if case insensitive or casing is consistent !!!
SELECT	A1.Species,
		A1.Breed AS Breed,
		A1.Name AS Male,
		A2.Name AS Female
FROM	Animals AS A1
		INNER JOIN
		Animals AS A2
		ON	A1.Species = A2.Species
			AND
			A1.Breed = A2.Breed -- Removes NULL breeds
			AND
			A1.Name <> A2.Name
			AND
			A1.Gender > A2.Gender
ORDER BY 	A1.Species, 
			A1.Breed;

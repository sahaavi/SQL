-- String aggregate
/*
 Name and species are expressions from the same row, but there's potentially more than 
 one row per each date group. And to concatenate all rows within a group, we need to use a 
 function like SUM but one that works for strings. And string aggregate is our friend. 
 Unlike SUM, which didn't care about any order, now, the order has significance, 
 hence, it's called an ordered set function (indistinct).
*/
SELECT	Adoption_Date,
		SUM(Adoption_Fee) AS Total_Fee,
		STRING_AGG(CONCAT(Name, ' the ',  Species), ', ') 
		WITHIN GROUP (ORDER BY Species, Name) AS Adopted_Animals
FROM	Adoptions
GROUP BY Adoption_Date
HAVING	COUNT(*) > 1;

/* PostgreSQL STRING_AGG is not an ordered set function as there is no order...
SELECT	Adoption_Date,
		SUM(Adoption_Fee) AS Total_Fee,
		STRING_AGG(CONCAT(Name, ' the ',  Species), ', ') AS Adopted_Animals
FROM	Adoptions
GROUP BY Adoption_Date
HAVING	COUNT(*) > 1;
*/

-- Beware of NULL concatenation
SELECT	'X' + NULL, 
		CONCAT('X', NULL);

/* PotgreSQL
-- Beware of NULL concatenation
SELECT	'X' || NULL, 
		CONCAT('X', NULL);
*/

-- Add breed to animal's string description
SELECT	Adoption_Date,
		SUM(Adoption_Fee) AS Total_Fee,
		STRING_AGG(CONCAT(AN.Name, ' the ',  AN.Breed, ' ', AN.Species), ', ')
		WITHIN GROUP (ORDER BY AN.Species, AN.Breed, AN.Name) AS Using_CONCAT,
		STRING_AGG(AN.Name + ' the ' +  AN.Breed + ' ' + AN.Species, ', ')
		WITHIN GROUP (ORDER BY AN.Species, AN.Breed, AN.Name) AS Using_Plus
FROM	Adoptions AS AD
		INNER JOIN
		Animals AS AN
			ON 	AN.Name = AD.Name 
				AND 
				AN.Species = AD.Species
GROUP BY Adoption_Date
HAVING	COUNT(*) > 1;

-- Hypothetical set and inverse distribution functions
/* PostgreSQL
WITH Vaccination_Ranking
AS
(
SELECT	Name, 
		Species,
		COUNT(*) AS Number_Of_Vaccinations
FROM	Vaccinations
GROUP BY Name, Species
)
SELECT  Species,
        MAX(Number_Of_Vaccinations) AS MAX_Vaccinations,
        MIN(Number_Of_Vaccinations) AS MIN_Vaccinations,
        CAST(AVG(Number_Of_Vaccinations) AS DECIMAL(9,2)) AS AVG_Vaccinations,
        DENSE_RANK(5)	
		WITHIN GROUP (ORDER BY Number_Of_Vaccinations DESC) AS How_Would_X_Rank,
        PERCENT_RANK(5) 
		WITHIN GROUP (ORDER BY Number_Of_Vaccinations DESC) AS How_Would_X_Rank_Percent_Wise,
        PERCENTILE_CONT(0.333) 
		WITHIN GROUP (ORDER BY Number_Of_Vaccinations DESC) AS Inverse_Continous,
        PERCENTILE_DISC(0.333) 
		WITHIN GROUP (ORDER BY Number_Of_Vaccinations DESC) AS Inverse_Discrete
FROM    Vaccination_Ranking
GROUP BY Species;
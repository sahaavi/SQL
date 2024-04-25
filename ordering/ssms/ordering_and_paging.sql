USE Animal_Shelter; -- For SQL Server

-- Using ordinal positions
SELECT	*
FROM	Animals
ORDER BY 2, 5, 1;

/* PostgreSQL

-- https://dbfiddle.uk/?rdbms=postgres_12&fiddle=1661d82a3969780042b28b139b2bb293&hide=2

SELECT	Species, COUNT(*)
FROM	Animals
GROUP BY 1
ORDER BY 2 DESC;
*/

-- Order by
SELECT	Adoption_Date, 
		Species, 
		Name
FROM	Adoptions
ORDER BY Adoption_Date DESC;

SELECT	Species, 
		Name
FROM	Adoptions
ORDER BY Adoption_Date DESC;

-- DISTINCT and ORDER BY
SELECT 	DISTINCT 
		Species, 
		Name
FROM	Adoptions
ORDER BY Adoption_Date DESC;

-- Tie breakers
SELECT	*
FROM	Animals
ORDER BY Species;

SELECT	*
FROM	Animals
ORDER BY Species, Name;

SELECT	*
FROM	Animals
ORDER BY Implant_Chip_ID;

-- NULL sorting goodies
SELECT	*
FROM	Animals
ORDER BY Breed;

SELECT	*
FROM	Animals
ORDER BY Breed DESC;

/* PostgreSQL and Oracle 

-- https://dbfiddle.uk/?rdbms=postgres_12&fiddle=62953002b268c424daa2f5d15838c36d&hide=2

SELECT	*
FROM	Animals
ORDER BY Breed NULLS LAST;
*/

USE Animal_Shelter; -- For SQL Server

-- Paging
SELECT TOP(3) *
FROM Animals;

SELECT	TOP(3) *
FROM	Animals
ORDER BY Primary_Color;

SELECT	*
FROM	Animals
ORDER BY Admission_Date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


/* Most other DBMS

-- https://dbfiddle.uk/?rdbms=postgres_12&fiddle=f5a70243501d9d1146feabd907b95c77&hide=2

SELECT	*
FROM	Animals
ORDER BY Admission_Date DESC
LIMIT 3 OFFSET 0;
*/

-- Only one order by for presentation and paging
/* Nice to have, doesn't exist (yet)

SELECT	*
FROM	Animals
ORDER BY Species, Breed DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY USING Admission_Date DESC;
*/

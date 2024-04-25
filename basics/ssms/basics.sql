USE Animal_Shelter; -- For SQL Server

-- Single table source
SELECT	* 
FROM	Staff;

SELECT	'SQL is Fun!' AS fact
FROM	Staff;

SELECT	*, 'SQL is Fun!' AS fact
FROM	Staff;

-- Preview of tables
-- SELECT * FROM Staff_Roles
-- SELECT * FROM Staff_Assignments
-- SELECT * FROM Adoptions


/*
Task: Write a query that returns all dogs except bull mastiffs. 
*/
SELECT	*
FROM	Animals 
WHERE	Species = 'Dog'	
		AND 
		Breed <> 'Bullmastiff';
/*
If we execute this we won't see any null values in Breed!!!
The reason is that a NULL for breed represents a non-applicable attribute. 
But the developers of SQL shows to treat NULLs for the most part as if they were of 
the applicable but missing type for which this behavior makes sense. If we're looking
for persons whose birth date is not January 1st, 2000, we probably don't want to include 
those with a NULL birthdate. Why? Because this is an applicable but missing value. 
It may be equal, it may not, we just don't know. Here, it makes sense not to return 
the rows with NULL for birthdate. But for breed, we know for sure that a dog with a NULL breed 
is not a bull mastiff. Here, it would make sense for the rows with a NULL breed to be returned. 
And now you can begin to understand why Dr. Codd wanted to implement two types of NULLs with different semantics. 
*/

SELECT	*
FROM	Persons
WHERE	Birth_Date <> '20000101';



/*
Details: - https://app.gitbook.com/o/h2Cva5KssbNBSnQANdlS/s/Z6zrq5CMONjd0JOZfwaj/~/changes/3/sql-basics/missing-information-and-ternary-logic/dealing-with-ternary-logic
*/


SELECT	*
FROM	Animals
WHERE	Breed = NULL;

SELECT	*
FROM	Animals
WHERE	Breed != NULL;

SELECT	*
FROM	Animals
WHERE	Breed = NULL 
		OR 
		Breed != NULL;

SELECT	*
FROM	Animals
WHERE	Breed = 'Bullmastiff' 
		OR 
		Breed != 'Bullmastiff';

SELECT	*
FROM	Animals
WHERE	Breed IS NULL;

SELECT	*
FROM	Animals
WHERE	Breed IS NOT NULL;

SELECT	*
FROM	Animals
WHERE	Breed != 'Bullmastiff';

SELECT	*
FROM	Animals
WHERE	Breed != 'Bullmastiff'
		OR 
		Breed IS NULL;
		
SELECT 	*
FROM 	Animals
WHERE 	ISNULL(Breed, 'Some value') != 'Bullmastiff';

/* PostgreSQL

-- https://dbfiddle.uk/?rdbms=postgres_12&fiddle=604141955f380c713f4ffce0bcdda1a7&hide=2

SELECT	*
FROM	Animals
WHERE	Breed IS DISTINCT FROM 'Bullmastiff';

SELECT	*
FROM	Animals
WHERE	(Breed = 'Bullmastiff') IS NOT TRUE;
*/



/*

Task: Write a query that uses a scalar subquery to identify orders whose Order Total  
is higher than the average total price of all other orders.

*/

-- Preview data if necessary 
-- select top (5) * FROM [Red30Tech].[dbo].[OnlineRetailSales$]

-- Write query
SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]
WHERE [Order Total] >= 
					(SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$])

-- OR-- 

-- Write query with the subquery in the select statement
SELECT *,  (SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$]) as AVG_TOTAL
FROM [Red30Tech].[dbo].[OnlineRetailSales$]
WHERE [Order Total] >= 
					(SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$])



/*
Task: Two Trees Olive Oil wants to know the session name, start date, end date, and room 
that their employees will be delivering their presentations in. Write a query that uses a 
multiple-row subquery to extract this information.
*/

-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[SessionInfo$]
-- SELECT * FROM [Red30Tech].[dbo].[SpeakerInfo$]

SELECT [Speaker Name], [Session Name], [Start Date], [End Date], [Room Name]
FROM [Red30Tech].[dbo].[SessionInfo$]
WHERE [Speaker Name] in
				(SELECT [Name] FROM [Red30Tech].[dbo].[SpeakerInfo$]
				WHERE [Organization]='Two Trees Olive Oil')
-- OR -- 

SELECT [Speaker Name], [Session Name], [Start Date], [End Date], [Room Name]
FROM [Red30Tech].[dbo].[SessionInfo$] as ses
INNER JOIN (SELECT [Name] FROM [Red30Tech].[dbo].[SpeakerInfo$] 
				WHERE [Organization]='Two Trees Olive Oil') as speak
on ses.[Speaker Name] = speak.[Name]


/*
Task: Write a query that outputs the first and last name, state, email address, 
and phone number of conference attendees who come from states that have no 
Online Retail Sales.
*/

-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]
-- SELECT * FROM [Red30Tech].[dbo].[ConventionAttendees$]

SELECT [First Name], [Last Name], [State], [Email], [Phone Number] 
FROM [Red30Tech].[dbo].[ConventionAttendees$] as c
WHERE NOT EXISTS 
				(SELECT [CustState] FROM [Red30Tech].[dbo].[OnlineRetailSales$] as o
				 WHERE c.[State] = o.[CustState])


/*
Task: Use the Inventory table to write a query that uses a subquery to return the ProdCategory, ProdNumber, ProdName, 
and In Stock of items that have less than the average amount of products left in stock to 
help the business know which products they are running low on.
*/

SELECT [ProdCategory], [ProdNumber], [ProdName]
FROM [Red30Tech].[dbo].[Inventory$]
WHERE [In Stock] <
					(SELECT AVG([In Stock]) FROM [Red30Tech].[dbo].[Inventory$])






USE Animal_Shelter;

-- Get MAX adoption fee
SELECT	MAX(Adoption_Fee)
FROM	Adoptions;

-- Non correlated expression subquery
SELECT	*,
		(	SELECT	MAX(Adoption_Fee)
			FROM	Adoptions
		) AS Max_Fee
FROM	Adoptions;

-- Must repeat entire subquery for each instance
SELECT	*,
		(SELECT MAX(Adoption_Fee) FROM Adoptions) AS Max_Fee,
		(((SELECT MAX(Adoption_Fee) FROM Adoptions) - Adoption_Fee) * 100)
			/ (SELECT MAX(Adoption_Fee) FROM Adoptions) AS Discount_Percent
FROM	Adoptions;

-- calculate max fee for each species 
-- correlated expression subquery
SELECT *,
		(
			SELECT MAX(Adoption_Fee)
			FROM Adoptions A2
			WHERE A2.Species = A1.Species
		) AS Max_Fee
FROM Adoptions AS A1;

-- people who adopted at least one animal
SELECT DISTINCT P.*
FROM Persons P INNER JOIN Adoptions A
	ON P.Email = A.Adopter_Email
-- OR
--- be careful even though the subquery isn't correct here but the total query
-- will run!!!
SELECT *
FROM Persons
WHERE Email IN (SELECT Email FROM Adoptions)
-- in adoptions table there's no email table the table is Adopter_Email
-- When evaluating column references of a sub query, the database first tries 
-- to match aliases in the scope of the sub query. If it can't find a match, it will assume 
-- that this is a correlation to a column from the outer query, and will try to match it there. 
-- What happened here is that when email was not found in adoptions, the email from persons was used. 


-- exists
-- as all rows evaluated to true in the query below it doesnt make any sense to use exists without correlated query
SELECT *
FROM Persons
WHERE EXISTS (
	SELECT NULL
	FROM Adoptions
	WHERE Species = 'Dog'
)

-- return all person who at least adopted one pet using exists
SELECT *
FROM Persons P
WHERE EXISTS (
	SELECT NULL -- the select here doesn;t return anything so you can use anything you want this is only for syntax purpose to make the query valid
	FROM Adoptions A
	WHERE P.Email = A.Adopter_Email
	)


-- Shorten with WITH clause
WITH Adoptions_and_Max_Fee
AS
(
SELECT	*,
		(SELECT MAX(Adoption_Fee) FROM Adoptions) AS Max_Fee
FROM	Adoptions
)
SELECT	*, 
		Max_Fee,
		(((Max_Fee - Adoption_Fee) * 100) / Max_Fee) AS Discount_Percent
FROM	Adoptions_and_Max_Fee;

-- Use variables
DECLARE @Max_Fee INT = (SELECT MAX(Adoption_Fee) FROM Adoptions);

SELECT	*,
		@Max_Fee,
		(((@Max_Fee - Adoption_Fee) * 100) / @Max_Fee) AS Discount_Percent
FROM Adoptions;

/* PostgreSQL variables...
DROP FUNCTION demo();
CREATE FUNCTION demo() 
RETURNS TABLE	(	
					Name VARCHAR(20), 
					Species VARCHAR(10), 
					Adoption_Date DATE, 
					Adoption_Fee SMALLINT, 
					Max_Adoption_Fee INT, 
					Discount_Percent INT
				)
AS $$
DECLARE Max_Fee INT;
BEGIN
	SELECT MAX(adoptions.Adoption_Fee) INTO Max_Fee FROM adoptions;
	RETURN QUERY 
	SELECT 	a.Name, 
			a.Species, 
			a.Adoption_Date, 
			a.Adoption_Fee, 
			Max_Fee, 
			(((Max_Fee - a.Adoption_Fee) * 100) / Max_Fee)
	FROM adoptions AS a;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Demo();

*/

-- Get MAX adoption fee per species
SELECT	Species, 
		MAX(Adoption_Fee) AS Max_Species_Fee 
FROM	Adoptions 
GROUP BY Species;

-- Don't try this at home!
SELECT	*,
		(	SELECT	MAX(Adoption_Fee) 
			FROM	Adoptions
			WHERE	Species = 'Dog'
		) AS Max_Dog_Fee,
		(	SELECT	MAX(Adoption_Fee) 
			FROM	Adoptions
			WHERE	Species = 'Cat'
		) AS Max_Cat_Fee,
		(	SELECT	MAX(Adoption_Fee) 
			FROM	Adoptions
			WHERE	Species = 'Rabbit'
		) AS Max_Rabbit_Fee
FROM	Adoptions;

-- Correlated expression subquery
SELECT	*,
		(	SELECT	MAX(Adoption_Fee) 
			FROM	Adoptions AS A2 
			WHERE	A1.species = A2.Species
		) AS Max_Fee
FROM	Adoptions AS A1;

-- Better solution, get MAX fee only once per species...
SELECT	A.*,
		M.Max_Species_Fee
FROM	Adoptions AS A
		INNER JOIN
		(
			SELECT	Species, 
					MAX(Adoption_Fee) AS Max_Species_Fee
			FROM	Adoptions 
			GROUP BY Species
		) AS M
			ON A.Species = M.Species;

-- Number of Persons and adoptions
SELECT	COUNT(*)
FROM	Persons;

SELECT	COUNT(*)
FROM	Adoptions;

-- Use JOIN
SELECT	DISTINCT P.*
FROM	Persons AS P
		INNER JOIN
		Adoptions AS A
			ON A.Adopter_Email = P.Email;

-- Use IN = where is the bug?
SELECT	*
FROM	Persons
WHERE	Email IN (SELECT Email FROM Adoptions);

-- Be careful with subquery aliases!
SELECT	*
FROM	Persons
WHERE	Email IN (SELECT Adopter_Email FROM Adoptions);

-- True row expression
/* PostgreSQL
SELECT	*
FROM	Animals
WHERE	(Name, Species) = ROW('Abby', 'Dog');
*/

-- Non correlated EXISTS - Don't try this at home!
SELECT	*
FROM	Persons
WHERE	EXISTS	(	
				SELECT	NULL
				FROM	Adoptions
				WHERE	species = 'Dog' -- 'Elephant'
				);

-- Correlated EXISTS is the way to go!
SELECT	*
FROM	Persons AS P
WHERE	EXISTS	(
				SELECT	NULL
				FROM	Adoptions AS A
				WHERE	A.Adopter_Email = P.Email
				);

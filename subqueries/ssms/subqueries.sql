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

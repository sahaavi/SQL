/*
Task: Re-write the query from video 01_02 that uses a CTE instead of a subquery to yield the same results.
The query identifies orders whose Order Total is higher than the average total price of all other orders.
*/

-- Write query with subquery
SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]
WHERE [Order Total] >= 
					(SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$])

-- OR-- 

-- Write query with the subquery in the select statement
SELECT *,  (SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$]) as AVG_TOTAL
FROM [Red30Tech].[dbo].[OnlineRetailSales$]
WHERE [Order Total] >= 
					(SELECT AVG([Order Total]) from [Red30Tech].[dbo].[OnlineRetailSales$])

-- Write a CTE
WITH AVGTOTAL (AVG_TOTAL) AS -- here the cte name is AVGTOTAL and AVG_TOTAL is the column that we want to extract
(
	SELECT AVG([Order Total]) AS AVG_TOTAL 
	FROM [Red30Tech].[dbo].[OnlineRetailSales$]
)

SELECT * 
FROM [Red30Tech].[dbo].[OnlineRetailSales$], AVGTOTAL
WHERE [Order Total] >= AVG_TOTAL

/* The above is an example of non recursive CTE. These are the ctes that do not reference 
themselves within the expression like we did here.
*/

-- The following is an exmaple of a Recursive CTE.

/*
Task: Write a query that uses a Recursive CTE to return the count of direct reports 
that Grant Nguyen has.
*/

-- Preview data if necessary 
-- select top (5) * FROM [Red30Tech].[dbo].[EmployeeDirectory$]


/*
Anchor member - The base result set for the query
Recursive member - Rerecnes the CTE itself, building on the base result set returned by
the anchor member.
Anchor and recursive member are seperated by operators like union all or except
*/
WITH DirectReports AS (
    SELECT [EmployeeID], [First Name], [Last Name], [Manager]
    FROM [Red30Tech].[dbo].[EmployeeDirectory$]
    WHERE [EmployeeID] = 42  -- Change this to the ID of the manager you want to query
    UNION ALL
	/*
	UNION: only keeps unique records. UNION ALL: keeps all records, including duplicates
	*/
    SELECT e.[EmployeeID], e.[First Name], e.[Last Name], e.[Manager]
    FROM [Red30Tech].[dbo].[EmployeeDirectory$] as e
    INNER JOIN DirectReports as d ON e.[Manager] = d.[EmployeeID]
)

SELECT COUNT(*) as Direct_Reports 
FROM DirectReports as d
WHERE d.[EmployeeID] != 42 --- exclude Grant himself from the final count

/*
Although this query type is less common, if you work in industries like human resources 
or social media that frequently deal with hierarchical relationships or network graphs, 
you may run into this concept more often. To summarize, remember that the recursive member
builds upon the results returned by the anchor member by going through a recursive process 
to output the final results set. 
*/


/*
Task: Use the Inventory table to write a query that uses a CTE to return the ProdCategory, ProdNumber, ProdName, 
and In Stock of items that have less than the average amount of products left in stock to 
help the business know which products they are running low on.
*/

WITH AVGPROD (AVG_PROD) AS
(
	SELECT AVG([In Stock]) FROM [Red30Tech].[dbo].[Inventory$]
)

SELECT [ProdCategory], [ProdNumber], [ProdName], [In Stock] 
FROM [Red30Tech].[dbo].[Inventory$], AVGPROD
WHERE [In Stock] < AVG_PROD
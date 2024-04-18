/*
The following is an exmaple of a query using LAG() and LEAD()
Task: Write a query using LAG() and LEAD() to show the Session Name 
and Start Time of the previous Red30 Tech session conducted in Room 102,
as well as what the next session will be.
*/

-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[SessionInfo$]
-- WHERE [Room Name] = 'Room 102' 
-- ORDER BY [Start Date] ASC

-- Use LAG() and LEAD() to get the Session Name and Start Time of the previous and next session
SELECT [Start Date], [End Date], [Session Name],

-- LAG() gets info from previous session
-- used 1 because we want the immediate last result
-- if we'd use 2 it will give us immediate last 2 results
-- this value is called offset if we dont specify offset value, the by default value is 1
/*
The next part of this query is the partition by statement. Here, since we're interested 
in returning the results by room number, I could put the room number here as one way of 
solving the problem, but because later on, I'll add the room number to the where statement, 
it's not really necessary here. So we're going to skip the partition by clause in this 
function because remember, not all components of a Windows function are required depending 
on your use case and the specific Windows function that you're using. 
*/
LAG([Session Name],1) OVER (ORDER BY [Start Date] ASC) AS PreviousSession,
LAG([Start Date],1) OVER (ORDER BY [Start Date] ASC) AS PreviousSessionStartTime,

-- LEAD() gets info from next session
LEAD([Session Name],1) OVER (ORDER BY [Start Date] ASC) AS NextSession,
LEAD([Start Date],1) OVER (ORDER BY [Start Date] ASC) AS NextSessionStartTime

FROM [Red30Tech].[dbo].[SessionInfo$]
WHERE [Room Name] = 'Room 102' 


/*
Task: Write a query using LAG() or LEAD() that returns the Quantity of 
Drones ordered on the previous 5 order dates from the OnlineRetailSales table.
*/

-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]
-- WHERE ProdCategory = 'Drones'

-- LAG() Solution:
WITH ORDER_BY_DAYS AS (
					SELECT ORDERDATE, SUM(QUANTITY) AS QUANTITY_BY_DAY
					FROM [Red30Tech].[dbo].[OnlineRetailSales$]
					WHERE ProdCategory = 'Drones'
					GROUP BY ORDERDATE
)


SELECT ORDERDATE, QUANTITY_BY_DAY,
LAG([QUANTITY_BY_DAY],1) OVER (ORDER BY [ORDERDATE] ASC) AS LastDATEQuantity_1,
LAG([QUANTITY_BY_DAY],2) OVER (ORDER BY [ORDERDATE] ASC) AS LastDATEQuantity_2,
LAG([QUANTITY_BY_DAY],3) OVER (ORDER BY [ORDERDATE] ASC) AS LastDATEQuantity_3,
LAG([QUANTITY_BY_DAY],4) OVER (ORDER BY [ORDERDATE] ASC) AS LastDATEQuantity_4,
LAG([QUANTITY_BY_DAY],5) OVER (ORDER BY [ORDERDATE] ASC) AS LastDATEQuantity_5

FROM ORDER_BY_DAYS

---------------------------------------------------------------------------------------------------

-- LEAD() Solution:
WITH ORDERS_BY_DAYS AS(
					SELECT ORDERDATE, SUM(QUANTITY) AS QUANTITY_BY_DAY
					FROM [Red30Tech].[dbo].[OnlineRetailSales$]
					WHERE ProdCategory = 'Drones'
					GROUP BY ORDERDATE
					)

SELECT ORDERDATE, QUANTITY_BY_DAY,

LEAD([QUANTITY_BY_DAY],1) OVER (ORDER BY [ORDERDATE] DESC) AS LastDATEQuantity_1,
LEAD([QUANTITY_BY_DAY],2) OVER (ORDER BY [ORDERDATE] DESC) AS LastDATEQuantity_2,
LEAD([QUANTITY_BY_DAY],3) OVER (ORDER BY [ORDERDATE] DESC) AS LastDATEQuantity_3,
LEAD([QUANTITY_BY_DAY],4) OVER (ORDER BY [ORDERDATE] DESC) AS LastDATEQuantity_4,
LEAD([QUANTITY_BY_DAY],5) OVER (ORDER BY [ORDERDATE] DESC) AS LastDATEQuantity_5

FROM ORDERS_BY_DAYS
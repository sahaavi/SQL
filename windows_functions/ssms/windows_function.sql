/*
The following is an exmaple of a query using ROW_NUMBER, to return each customer's recent order.
Task: Write a query using ROW_NUMBER to return each customer's most recent order.
*/

-- Preview data if necessary
--SELECT * FROM [Red30Tech].[dbo].[OnlineRetailSales$]

-- Demonstrate that there are many customers with multiple orders
SELECT CUSTNAME, COUNT(DISTINCT OrderNum) 
FROM  [Red30Tech].[dbo].[OnlineRetailSales$] 
GROUP BY CUSTNAME

-- Write a query using ROW_NUMBER to number each customer's orders based on the order date 
/*
The row-number() window function will assign a number to the rows 
to the windows (which are similar to groups) selected in partition by 
One thing that's important to point out about the row number function is 
that if there are ties or maybe even duplicates between your criteria and no 
clear tie breakers, in this example, it would be like a customer placing two 
separate orders on the same day, then row number will continue to numerate
each row in the results set without skipping values. 
*/
SELECT [OrderNum], [OrderDate], [CustName], [ProdName], [Quantity], 
ROW_NUMBER() OVER(PARTITION BY [CustName] ORDER BY OrderDate DESC) as ROW_NUM
FROM  [Red30Tech].[dbo].[OnlineRetailSales$] 

-- Take the query above and modify it to return only the most recent order (ROW_NUMBER = 1)
-- Write a query using ROW_NUMBER to number each customer's orders based on the order date 

-- You cannot filter on the column created by the windows function in the WHERE clause
SELECT [OrderNum], [OrderDate], [CustName], [ProdName], [Quantity], 
ROW_NUMBER() OVER(PARTITION BY [CustName] ORDER BY OrderDate DESC) as ROW_NUM
FROM  [Red30Tech].[dbo].[OnlineRetailSales$] 
WHERE ROW_NUM=1 --- this does NOT work!

-- Wrap the query in a CTE (or subquery!), then you will be able to filter where ROW_NUM = 1
-- Bonus info: In other SQL dialects like PostgresSQL, the QUALIFY keyword lets you
-- filter on a ROW_NUMBER column like you would in a WHERE clause. You would type QUALIFY ROW_NUM = 1

WITH ROW_NUMBERS as (
					SELECT [OrderNum], [OrderDate], [CustName], [ProdName], [Quantity],
					ROW_NUMBER() OVER(PARTITION BY [CustName] ORDER BY OrderDate DESC) as ROW_NUM
					FROM  [Red30Tech].[dbo].[OnlineRetailSales$] 
					)

SELECT * FROM ROW_NUMBERS WHERE ROW_NUM =1


/*
Task: Write a query using ROW_NUMBER() that returns the OrderNum, OrderDate, CustName, 
ProdCategory, ProdName, and Order Total of the top 3 orders that have the highest 
Order Total from each ProdCategory purchased by Boehm Inc.
*/

WITH ROW_NUMBERS AS (
	SELECT [OrderNum], [OrderDate], [CustName], [ProdCategory], [ProdName], [Order Total],
	ROW_NUMBER() OVER(PARTITION BY [CustName], [ProdCategory] ORDER BY [Order Total] DESC) as ROW_NUM
	FROM  [Red30Tech].[dbo].[OnlineRetailSales$] 
	)
SELECT * FROM ROW_NUMBERS WHERE ROW_NUM <= 3 AND [CustName] = 'Boehm Inc.'

-- solution by kendall
WITH ROW_NUMBERS as (
					SELECT OrderNum, OrderDate, CustName, ProdCategory, ProdName, [Order Total],
					ROW_NUMBER() OVER(PARTITION BY [ProdCategory] ORDER BY [Order Total] DESC) as ROW_NUM
					FROM  [Red30Tech].[dbo].[OnlineRetailSales$]
					where CustName = 'Boehm Inc.'
					)

SELECT OrderNum, OrderDate, CustName, ProdCategory, ProdName, [Order Total] FROM ROW_NUMBERS 
WHERE ROW_NUM in (1,2,3)
ORDER BY [ProdCategory],[Order Total] DESC
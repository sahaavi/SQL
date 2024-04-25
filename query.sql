SELECT  e.firstname AS E_FirstName, 
        e.lastName AS E_LastName, 
        m.firstName AS M_FirstName,
        m.lastName AS M_LastName
FROM employee m join employee e
  ON m.employeeId = e.managerId
WHERE e.managerId IS NOT NULL

SELECT *
FROM sales

-- Get a list of salespeople with zero sales
SELECT *
FROM employee
WHERE employeeId NOT IN 
        (
          SELECT employeeId
          FROM sales
        )

SELECT e.employeeId, e.firstName
FROM employee e LEFT JOIN sales s
  ON e.employeeId = s.employeeId
WHERE e.title = 'Sales Person' AND
s.salesId IS NULL

SELECT employeeId, COUNT(*) AS Total_Cars
FROM sales
GROUP BY employeeId
ORDER BY Total_Cars DESC

SELECT e.employeeId,e.firstName, e.lastName,
        count(*) as Total_Cars
FROM sales s INNER JOIN employee e
  ON s.employeeId = e.employeeId
GROUP BY e.employeeId, e.firstName, e.lastName
ORDER BY Total_Cars DESC

-- Produce a report that lists the least and most
-- expensive car sold by each employee this year

SELECT e.employeeId, e.firstName, e.lastName

FROM sales s
INNER JOIN employee e
ON s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = strftime('%Y', 'now');

-- Create a report showing total sales per year
WITH sales_year AS 
        (SELECT  strftime('%Y', soldDate) AS year, 
        COUNT(*) AS NumOfSales,
        SUM(salesAmount) AS TotalSales
FROM sales
GROUP BY year)

SELECT *
FROM sales_year
ORDER BY year DESC

-- amount of sales per employee for each month in 2021
SELECT  e.employeeId,
        e.firstName, 
        e.lastName,
        strftime('%m', soldDate) AS month,
        SUM(s.salesAmount) AS sales
FROM employee e INNER JOIN sales s
    ON e.employeeId = s.employeeId
  WHERE strftime('%Y', s.soldDate) = '2021'
  GROUP BY s.employeeId, month

-- let's shift each month into the column for above query
SELECT  e.employeeId,
        e.firstName, 
        e.lastName,
        SUM(CASE 
          WHEN strftime('%m', soldDate) = '01' 
          THEN salesAmount END) AS JanSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '02' 
              THEN salesAmount END) AS FebSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '03' 
              THEN salesAmount END) AS MarSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '04' 
              THEN salesAmount END) AS AprSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '05' 
              THEN salesAmount END) AS MaySales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '06' 
              THEN salesAmount END) AS JunSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '07' 
              THEN salesAmount END) AS JulSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '08' 
              THEN salesAmount END) AS AugSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '09' 
              THEN salesAmount END) AS SepSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '10' 
              THEN salesAmount END) AS OctSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '11' 
              THEN salesAmount END) AS NovSales,
        SUM(CASE 
              WHEN strftime('%m', soldDate) = '12' 
              THEN salesAmount END) AS DecSales
FROM employee e INNER JOIN sales s
    ON e.employeeId = s.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
GROUP BY s.employeeId
ORDER BY e.lastName, e.firstName


-- find all sales where the car purchased was electric

SELECT s.salesId, s.soldDate
      
FROM sales s INNER JOIN inventory i
  ON s.inventoryId = i.inventoryId
WHERE i.modelId IN (
                SELECT modelId
                FROM model
                WHERE EngineType = 'Electric'
                )

-- get a list of sales people and
-- rank the car models they've sold most of

SELECT e.firstName, e.lastName, m.model,
  COUNT(m.model) AS NumofModelSold,
  RANK() OVER (
                PARTITION BY e.employeeId
                ORDER BY COUNT(m.model) DESC 
                ) AS Rank
FROM employee e INNER JOIN sales s 
  ON e.employeeId = s.employeeId
INNER JOIN inventory i
  ON s.inventoryId = i.inventoryId
INNER JOIN model m
  ON i.modelId = m.modelId
WHERE e.title = 'Sales Person'
GROUP BY e.employeeId, m.model

-- generate a sales report showing total sales permonth
-- and an annual running total

with cte_sales as(
  SELECT  strftime('%Y', soldDate) as soldYear,
          strftime('%m', soldDate) as soldMonth,
          sum(salesAmount) as salesAmount
  FROM sales
  GROUP BY soldYear, soldMonth
)
SELECT  soldYear, soldMonth, salesAmount,
        sum(salesAmount) over (
                              PARTITION BY soldYear
                              order by soldYear, soldMonth)
        AS AnnualSalesRunningTotal
FROM cte_sales
order by soldYear, soldMonth

-- create a report showing the number of cars sold this month and last month
SELECT strftime('%Y-%m', soldDate) AS MonthSold,
  COUNT(*) AS NumberCarsSold,
  LAG(COUNT(*), 1, 0) OVER calMonth AS LastMonthCarsSold
FROM sales
GROUP BY MonthSold
WINDOW calMonth AS (ORDER BY strftime('%Y-%m', soldDate))
ORDER BY MonthSold
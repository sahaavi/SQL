/*
The following is an example of a query using RANK() and DENSE_RANK().
Task: Write a query using RANK() and DENSE_RANK() that ranks employees 
in alphabetical order by their last name.
*/

-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[EmployeeDirectory$]

SELECT * ,
RANK() OVER (ORDER BY [Last Name]) as RANK_,
DENSE_RANK() OVER (ORDER BY [Last Name]) as DENSE_RANK_
FROM [Red30Tech].[dbo].[EmployeeDirectory$]


-- Preview data if necessary
-- SELECT * FROM [Red30Tech].[dbo].[ConventionAttendees$]

WITH RANKTABLE AS (
					SELECT *,
					DENSE_RANK() OVER (PARTITION BY [State] ORDER BY [Registration Date]) as DENSE_RANK_
					FROM [Red30Tech].[dbo].[ConventionAttendees$]
)
SELECT *
FROM RANKTABLE WHERE DENSE_RANK_ <= 3


--- SOLUTION WITH RANK
-- Notice solution has 171 rows!
-- because it skips the position.. so instead of 3 it will go to 4 as it has two 2 and we
-- are filtering here 1 to 3.
WITH RANKS AS (
				SELECT * ,
				RANK() OVER (PARTITION BY [State] ORDER BY [Registration Date]) as RANK_
				FROM [Red30Tech].[dbo].[ConventionAttendees$]
	)

SELECT * FROM RANKS WHERE RANK_ in (1,2,3)
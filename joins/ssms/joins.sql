USE Animal_Shelter; -- For SQL Server

/* 
Task: Write a query that can generate all possible combinations
of roles for each staff member.
*/

-- CROSS JOIN
/*
Select star from staff cross join staff roles will return a Cartesian product
with every possible combination of each staff member and role. 
We rarely use explicit Cartesian products, although logically, 
they are the first processing step for all types of joints.
*/

SELECT	* 
FROM	Staff 
		CROSS JOIN 
		Staff_Roles; 

-- INNER JOIN
/*
Quiz time, what do you think will happen if we replace the cross join with 
an inner join but use the qualification predicate one equals one. 
Stop the video for a minute and try to see if you can guess the result. 
If you followed joint processing order, you got it right. 
So, let me hammer it in one more time. The first step of every join is a Cartesian product. 
Then every row from the Cartesian product is evaluated using the qualification predicate. 
Only rows for which the predicate evaluates to true get to see another clause. 
In here, all rows from the Cartesian product evaluated to true as the predicate is always true. 
Therefore, this innocent-looking inner join is in fact a well disguised cross join. 
*/
SELECT	* 
FROM	Staff 
		INNER JOIN 
		Staff_Roles
		ON 1 = 1;
/*
Task: We need to write a query for the animal adoption report including the animals breed and implant chip ID. 
*/

SELECT	*
FROM	Animals AS A
		CROSS JOIN 
		Adoptions AS AD;

SELECT	AD.*, A.Breed, A.Implant_Chip_ID
FROM	Animals AS A
		INNER JOIN 
		Adoptions AS AD
		ON	AD.Name = A.Name 
			AND 
			AD.Species = A.Species;

-- also want to include animals those haven't been adopted
-- here some name and species will be null because we'll see
-- all the info from Animal table(which is in the left)
-- and some animal weren't adopted that's why only the chip_id is visible from animals table

SELECT	AD.*, A.Breed, A.Implant_Chip_ID
FROM	Animals AS A
		LEFT OUTER JOIN 
		Adoptions AS AD
		ON	AD.Name = A.Name 
			AND 
			AD.Species = A.Species;

SELECT	AD.Adopter_Email, AD.Adoption_Date, 
		A.*
FROM	Animals AS A
		LEFT OUTER JOIN 
		Adoptions AS AD
		ON	AD.Name = A.Name 
			AND 
			AD.Species = A.Species;

/*
Task: write a SQL query for animal adoptions and include information about their adopters.
*/

SELECT	*
FROM	Animals AS AN
		INNER JOIN 
		Adoptions AS AD
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species
		INNER JOIN 
		Persons AS P 
			ON	AD.Adopter_Email = P.Email;

-- now want see include the animal those haven't adopted yet as well, in the list
-- 100 Rows in Animals table
-- 70 Rows in Adoptions table
-- 120 Rows in Persons table

-- if you see carefully while we're joining the persons table
-- we're using the adopter email and persons email
-- and the animals haven't adopted yet definitely their adopter email will be null from the previous join
-- after that when it comes to this inner join it couldn't qualify as null can't be matched with. that's why
-- it backs 70 rows 
SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
		Adoptions AS AD
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species
		INNER JOIN 
		Persons AS P
			ON P.Email = AD.Adopter_Email;

SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
		Adoptions AS AD
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species
/*		INNER JOIN 
		Persons AS P
			ON P.Email = AD.Adopter_Email */;

-- thoug the solution below will work but it's suboptimal. it makes the query harder to understand.
-- and it may also have nasty performance penalty
-- much better to keep the joins logically correct and to force the join explicitly to match our requirement

SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
		Adoptions AS AD
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species
		LEFT OUTER JOIN 
		Persons AS P
			ON P.Email = AD.Adopter_Email;

SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
		(Adoptions AS AD
			ON AD.Name = AN.Name -- because of this the query will give error, as we're now only trying to join the adoptions and persons first
			AND 
			AD.Species = AN.Species
		INNER JOIN 
		Persons AS P
			ON P.Email = AD.Adopter_Email);

SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
			(
				Adoptions AS AD
				INNER JOIN 
				Persons AS P 
					ON	AD.Adopter_Email = P.Email
			)
			ON AD.Name = AN.Name 
			AND 
			AD.Species = AN.Species;

SELECT	*
FROM	Animals AS AN
		LEFT OUTER JOIN 
			Adoptions AS AD
			INNER JOIN 
			Persons AS P 
				ON	AD.Adopter_Email = P.Email
			ON 	AD.Name = AN.Name 
				AND 
				AD.Species = AN.Species;


/*
Animal vaccinations report.
---------------------------
Write a query to report all animals and their vaccinations.
Animals that have not been vaccinated should be included.
The report should include the following attributes:
Animal's name, species, breed, and primary color,
vaccination time and the vaccine name,
the staff member's first name, last name, and role.

Guidelines:
-----------
Use the minimal number of tables required.
Use the correct logical join types and force join order as needed.
*/

SELECT A.Name, A.Species, A.Breed, A.Primary_Color, V.Vaccination_Time, V.Vaccine, P.First_Name, P.Last_Name, S.Role
FROM Animals AS A
	LEFT OUTER JOIN
	(
		Vaccinations AS V
		INNER JOIN
		Staff_Assignments AS S
			ON S.Email = V.Email
		INNER JOIN
		Persons AS P
			ON P.Email = V.Email
	)
	ON V.Name = A.Name AND V.Species = A.Species


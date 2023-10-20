SELECT DISTINCT subscriber
	FROM (
		SELECT subscriber
		FROM full_year
		WHERE INSTR(newspaper, 'Daily') > 0
		/* This condition checks whether the string "Daily" is found anywhere in the "newspaper" column.
INSTR() is a function that returns the position of a substring within a string, or 0 if the substring is not found. */
		UNION
		SELECT subscriber
		FROM half_year
		WHERE INSTR(newspaper, 'Daily') > 0
	) AS total_sub
	ORDER BY SUBSTRING_INDEX(subscriber, ' ', 1);
	/*
	subscriber is the column that contains the string you want to process.
' ' is the delimiter you want to use to split the string.
1 specifies that you want to extract the portion of the string before the first occurrence of the delimiter (in this case, the first word before the first space).
	 */
# Grouping

In a properly designed relational database, every table represents a single relation or a thing in the real world, and every row represents an instance of that thing. Animals, persons, staff and vaccines, all hold the granular attributes or facts about each one of these things. The from clause processed one or more of these sources and passed them to the where clause. The where clause evaluated each row using predicates. In both clauses, processing was of the individual rows but sometimes it's not these details that we're after. Instead we need to answer higher level questions for which grouping comes in handy.

<figure><img src="../.gitbook/assets/image (19) (1).png" alt=""><figcaption></figcaption></figure>

First, the Animals table gets evaluated in the from clause. It is then passed on to the next clause, the group by. The group by looks at all rows and marks them for grouping based on the grouping expression, in this case species. At this point, something interesting happens. This set is transformed from its normal table-like shape into this hybrid grouped structure, where each group of unique specie values corresponds to a single output row. The only value that is guaranteed to be the same for all rows within a group is the value of the group by expressions. Instead of nine source rows we are now dealing with three row groups, and this funny-looking set is now passed on to the select clause. All select expressions are evaluated like before but instead of being evaluated per row, now they are evaluated per group. We got three rows with the correct counts but without the group identifier they won't make much sense.

<figure><img src="../.gitbook/assets/image (20) (1).png" alt=""><figcaption></figcaption></figure>

So let's add it back to the select list, and now it makes more sense. We can see the species, the group identifier alongside the animal count, the aggregate function of the group. It only made sense because species is the group by expression.

<figure><img src="../.gitbook/assets/image (21) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (22) (1).png" alt=""><figcaption></figcaption></figure>

Grouping of nullable expressions treats all nulls as a single group. And if you find this confusing you're in very good company. Just in the previous chapter I told you that one null is never equal to another null. So how come they are treated in a single group? Well, it wouldn't be very useful to create a group for each row with a null. Therefore grouping is based on values that are distinct from each other, not ones that are mathematically equal. Remember that even though nulls are not equal a null is not distinct from another.

<figure><img src="../.gitbook/assets/image (23) (1).png" alt=""><figcaption></figcaption></figure>

With a few exceptions aggregate functions ignore nulls altogether. And this makes sense as the aggregate can only rely on known values when reporting max, min, sum, and even count of an explicit expression. Count star is a special aggregate function that counts the number of rows per group. It doesn't reference or cares about any specific expression value. Therefore nulls are irrelevant to it. There are other expressions such as JSON array aggregate functions which need to maintain the null representation and each database has its own. So again, check the documentation for your database of choice.



why we cannot use aggregate functions with distinct. And yet again the reason is query processing order. The distinct takes place after all select expressions have been evaluated. And aggragations don't make sense if the source rows are not grouped beforehand. for example the query below won't work

<figure><img src="../.gitbook/assets/image (25) (1).png" alt=""><figcaption></figcaption></figure>

If you realized that due to the count star the database treats the entire set as a single group you are correct. If the whole table is a single group which is the only way that the count star makes sense in this context, then species and name without an aggregate function are invalid expressions.

<figure><img src="../.gitbook/assets/image (26).png" alt=""><figcaption></figcaption></figure>

After the GROUP BY had its way, the group set is passed on to the HAVING clause. HAVING is very similar to the WHERE clause in the sense that both consist of logical predicates, and both discard elements for which the predicate does not evaluate to true. The difference between WHERE and HAVING is their location in query processing order. When they take place, and consequently the type of elements they can filter. The WHERE filter was applied right after the FROM clause, so is only had access to the source rows. The HAVING clause is processed after the GROUP BY, so it can no longer refer to individual rows, only to row groups. So HAVING can use aggregate functions for its predicate, something we couldn't do in the WHERE clause before the groups were formed.

# SQL Basics

<figure><img src="../.gitbook/assets/image (13) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (14) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (15) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (16) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (12) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

&#x20;Every query begins with a FROM clause, which constructs the query's dataset. This is the only data that will be available for the rest of the query. After the FROM clause produces a single dataset, it is passed on to the WHERE clause as a virtual table and the WHERE clause uses binary and ternary logical predicates to filter out individual rows. The filtered set is then passed on to the GROUP BY clause where it is grouped and from there to the HAVING clause where entire groups can be filtered. The grouped and filtered set is then passed on to the SELECT clause, which evaluates every expression for each row. Then, it is passed on to the ORDER BY clause to apply presentation ordering and finally, the OFFSET FETCH clause, also known as LIMIT OFFSET, determines which and how many rows will be returned.

&#x20;Some databases, including SQL Server, PostgreSQL, MySQL and others, also support a SELECT without a FROM clause. You can think of a FROM-less SELECT as if it was using a hypothetical FROM clause that consists of a Dummy table containing one row, one column with some arbitrary value. Other databases force us to include an explicit FROM clause, even when it's not really used except as syntactic sugar.

<pre class="language-sql"><code class="lang-sql">SELECT "Hello World"
<strong>-- FROM Dummy/DUAL
</strong></code></pre>

<figure><img src="../.gitbook/assets/image (13) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

[ ](https://www.linkedin.com/learning/advanced-sql-logical-query-processing-part-1/single-data-source-queries?autoSkip=true\&contextUrn=urn%3Ali%3AlyndaLearningPath%3A5ee163f0498efe0ef0dfd87c\&resume=false)SQL is a composable language. It allows the FROM clause to use data sets from any source as long as it complies with these rules. We can use a table, a view, a function, or a subquery derived table. The processing of a FROM with just one source is straightforward. The entire source data set is evaluated. The result is then gift wrapped as a virtual table and delivered to the next phase for further processing. This fundamental process will be the same whether our source is a single table or a 500 rows long nightmare with 20-level deep nested tables, views, functions, and subqueries.

<figure><img src="../.gitbook/assets/image (14) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

This query adding an extra column with same values in each row.

[ ](https://www.linkedin.com/learning/advanced-sql-logical-query-processing-part-1/single-data-source-queries?autoSkip=true\&contextUrn=urn%3Ali%3AlyndaLearningPath%3A5ee163f0498efe0ef0dfd87c\&resume=false)Always follow processing order. First the source data set gets evaluated in the FROM clause. This means that the Staff table gets wrapped in a gift package and handed over to the SELECT clause. The SELECT then evaluates all expressions for each and every row. And this is true whether we use a source column, but it's also true for the string literal SQL IS FUN. Both are evaluated per row of the Staff table.


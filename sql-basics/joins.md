# joins

<figure><img src="../.gitbook/assets/image (67).png" alt=""><figcaption></figcaption></figure>

Every join no matter type, color, gender or race always begins with a Cartesian product. In a Cartesian product, each row from one set is paired with each row from the other. The result set consists of all columns from both sources.

<figure><img src="../.gitbook/assets/image (68).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (69).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (70).png" alt=""><figcaption></figcaption></figure>

If the specified join type is a cross join, processing stops at this point and the Cartesian product is passed on to the next clause. For all other join types, processing continues to the next step qualification. Inner and outer join are called qualified joins. The qualification predicate is specified using the on keyword. The qualification process evaluates each row from the Cartesian product using the predicate. Only rows for which the predicate evaluates to true will live to see another clause. All other rows are eliminated from the set. If the requested join type is an inner join, join processing stops at this point and only the qualified rows are passed on to the next clause. If the requested join type is an outer join, the qualified rows move on to the next step, reservation. Outer joins designate one or both source sets as reserved. Reserved sets get to have all of the rows added to the join results even those that did in past qualification in the previous step. A left outer join reserves the set on the left side of the join. Here it is set a so all its rows that failed to qualify are reintroduced back into the join result. Since these rows had no match in set B, there is no value to show for it and in no indicator is used for this inapplicable data. A right outer join reserved the set on the right instead of the one on the left. Here rows from set B that failed qualification will get reintroduced back into the join result. A full outer join simply reserves both sets.

<figure><img src="../.gitbook/assets/image (71).png" alt=""><figcaption></figcaption></figure>

also can write

<figure><img src="../.gitbook/assets/image (72).png" alt=""><figcaption></figcaption></figure>

A natural join allows us to omit the qualification predicates altogether. It assumes the predicate consists of all columns that have the same exposed aliases in both sets and it will construct an equality qualification predicate including each and every one. Avoid using natural join like the plague. It makes the query less readable and less portable but that's not the issue. I have witnessed applications failing miserably with devastating consequences when additional columns were added to the underlying tables and some happened to have the same name. The most common cases had to do with tracking attributes such as modified on, modified by and various Boolean flags such as is deleted, is active, et cetera. These columns were added to the natural join predicate and you can imagine what that did to the query result. So, consider yourself warned.

<figure><img src="../.gitbook/assets/image (5) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (6) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (7) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

Every join begins with a Cartesian product where every element from the blue set is matched with every element from the orange set. Cross joins end here.&#x20;

<figure><img src="../.gitbook/assets/image (19) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (20) (1) (1).png" alt=""><figcaption></figcaption></figure>

All other join types proceed to a qualification phase where each row of the Cartesian product is evaluated using the qualification predicate. And this is true, regardless what qualification predicate we use. It can be an equality operator and non equality, or even a constant Boolean expression. If the qualification predicate uses an equality operator, only the row with a two twos qualifies.&#x20;

<figure><img src="../.gitbook/assets/image (21) (1) (1).png" alt=""><figcaption></figcaption></figure>

For a different than operator, all the rows except the previous one qualify, and for a larger than operator, only the row with a blue three and orange two qualifies.

<figure><img src="../.gitbook/assets/image (22) (1).png" alt=""><figcaption></figcaption></figure>

![](<../.gitbook/assets/image (23) (1).png>)One of the limitation of joins is that each table expression that's being joined must stand alone and be independent of any other. So this query is valid. Each table expression is complete and independent.

<figure><img src="../.gitbook/assets/image (24) (1).png" alt=""><figcaption></figcaption></figure>

But if we introduce a correlation between the two, we're going to get an error. F1 Bar is an unknown expression. And the reason is that it does not exist in the context of the sub query.



<figure><img src="../.gitbook/assets/image (31).png" alt=""><figcaption></figcaption></figure>

Now, in general, the query builder will choose the optimal join method, and we use the directives that we've used here to compare the cost between different join methods. Now, if you believe the builder is not choosing the best method, you can use the explain plans to understand why, so, for example, you might expect the builder to use an index scan, but it uses a full table scan. That's a clue that your index may be missing, so my only suggestion with regards to using directives and hints is to use them with extreme caution. They're very useful when learning things like the structure of a query plan and what a mergejoin operation actually looks like. However, when you're running code in production, the query plan builder makes use of statistics about the data in your database and the distribution of that data to figure out what's the best way to join a table, so use things like directives and hints with caution because, especially because even if they work well now, and you found an optimal solution right now that the query plan builder didn't find, over time, your data distribution's going to change, and that may no longer be the case, so definitely use directives and hints for a learning perspective, but use them in production with caution.

<figure><img src="../.gitbook/assets/image (32).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (33).png" alt=""><figcaption></figcaption></figure>

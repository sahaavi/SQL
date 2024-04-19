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

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>
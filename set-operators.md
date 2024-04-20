# SET Operators

<figure><img src=".gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

The ANSI SQL standard defines three Set operators; UNION, EXCEPT and INTERSECT.

Each of these has two variants; ALL and DISTINCT. Many of you have used or at least heard of UNION and UNION ALL, but did you know that UNION is just a shortcut for UNION DISTINCT? And how about EXCEPT or INTERSECT ALL? All means that the result may contain duplicates. The default is DISTINCT, which groups or eliminates duplicates.

Sub queries were processed in the context of a parent query. Set operators work differently. They stand between two independent queries that are processed prior to the Set operator itself. Set operators result in a table expression that can be either a Set or a Multiset based on the data, queries and the operator that we use. The result can be used with additional Set operators as a derived table and a FROM clause, or anywhere else where a table expression is allowed. It's important not to confuse Set operators with Joins. Joins combine two table expressions horizontally. The result rows depend on the type of Join, but may contain attributes from one or both sources. This isn't the case with Set operators. Set operators combine two table expressions vertically. The result consists of the matching attributes from both sets, and typically these are the same attributes.

<figure><img src=".gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (11).png" alt=""><figcaption></figcaption></figure>

INTERSECT DISTINCT and INTERSECT both are same

<figure><img src=".gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (14).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (15).png" alt=""><figcaption></figcaption></figure>

Out of all the operators except is the only directional set

<figure><img src=".gitbook/assets/image (16).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (17).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (18).png" alt=""><figcaption></figcaption></figure>

Same is true for Union and Intersect in case of NULL


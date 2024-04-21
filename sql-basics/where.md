# Where

<figure><img src="../.gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>

After the row set got evaluated and finalized in the from clause, it is passed on to the where clause. The where clause evaluates every row using the logical predicates. Only rows for which the predicate evaluates to true will live to see another clause. Rows that do not evaluate to true are discarded.

<figure><img src="../.gitbook/assets/image (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (2) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (3) (1) (1).png" alt=""><figcaption></figcaption></figure>

While the result of both the above queries are same but the their logical processing's are different.  These distinctions are critical. For outer joins these gets more interesting.

<figure><img src="../.gitbook/assets/image (4) (1) (1).png" alt=""><figcaption></figcaption></figure>

<img src="../.gitbook/assets/file.excalidraw (1).svg" alt="" class="gitbook-drawing">

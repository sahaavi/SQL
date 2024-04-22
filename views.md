# Views

<figure><img src=".gitbook/assets/image (58).png" alt=""><figcaption></figcaption></figure>

Materialized views combine some of the features of tables and views. Materialized views are used to store the results of pre-computed queries. For example, we may have to perform expensive joins and we want to minimize the number of times we need to run that query. By materializing or storing the results of a query, the query results can be used for other operations without performing an expensive query operation again. While materialized views can save time, they will also take up space. Materialized views duplicate data that is already stored in tables. Data in materialized views can change state, so we'll have to update or refresh materialized views to capture changes to the sources of those materialized views. This means there is a potential for inconsistencies between source tables and materialized views. If you can tolerate these potential problems, the materialized views can help reduce the time required to execute queries.

<figure><img src=".gitbook/assets/image (59).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (60).png" alt=""><figcaption></figcaption></figure>

It's important to remember that materialized views save data from the source tables into a new data structure. The data that was in the source tables at the time the materialized view are created. That's what's there in the materialized view even if the underlying table is updated.

Those update operations or those changes are not necessarily reflected in the materialized view until we actually force those updates to be included in the materialized view. And to do that we use a command called refresh materialized view.

<figure><img src=".gitbook/assets/image (61).png" alt=""><figcaption></figcaption></figure>

If you need the materialized view updated any time the source table is updated, you can consider using triggers on the source table to update the materialized view.

<figure><img src=".gitbook/assets/image (62).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (63).png" alt=""><figcaption></figcaption></figure>

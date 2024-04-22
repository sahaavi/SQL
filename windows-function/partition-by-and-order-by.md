# Partition BY and Order BY

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

Let's look at some ways we can change our data model implementation to improve query performance. One of the problems with large tables is that they can be difficult to query efficiently. Even with indexes, queries against large tables may not be performant enough. One way to deal with this is by splitting the large table into smaller sub-tables. This is called horizontal partitioning. And basically we treat each partition like a table. The benefit of horizontal partitioning is that we can sometimes limit scans to a small number of partitions. Because partitions are like tables, we can create indexes on columns in those partitions. This leads to smaller indexes than those that would exist in the full table. In addition, partitions can make bulk data operations like dropping old data even more efficient because we can drop an entire partition quickly. If we need to drop a subset of rows, that can also be faster because a smaller index is updated faster rather than a much larger index.

<figure><img src="../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

Partitions are used widely in several kinds of database applications, including data warehouses. They are often partitioned based on time because time is commonly used as a filter. Timeseries data is also a good candidate for partitioning because the latest data is the most likely to be queried. In other areas, there may be a natural partition strategy that doesn't involve time. For example, you may want to partition by geography or by product type.

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

Vertical partitioning separates the columns of a large table into multiple tables. Designers tend to keep columns that are frequently queried together in the same vertical partition. When using vertical partition, you'll use the same primary key across all of the partitions. Benefits of vertical partitioning include increasing the number of rows stored in a single data block. This means that more rows are returned with each block read. We can create global indexes on each partition. Because columns are separated, we can read less data to satisfy a query and this can reduce IO. Columnar data storage strategies can provide similar benefits as well.

<figure><img src="../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (18) (1).png" alt=""><figcaption></figcaption></figure>

The second filter we can place in front of our window is the partition by clause. To partition something, means to divide it into parts and this is exactly what partition by does. The partitioning expressions limit the function's visible window only to rows that share the same values as the current row.

<figure><img src="../.gitbook/assets/image (19) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (20) (1).png" alt=""><figcaption></figcaption></figure>

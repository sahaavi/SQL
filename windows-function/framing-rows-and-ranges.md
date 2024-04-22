# Framing Rows and ranges

<figure><img src="../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

Range Partitioning is a kind of horizontal partitioning. Partitions are created based on non-overlapping partition keys. Now, partition keys are often based on time but numeric ranges and alphabetic ranges are also used.

<figure><img src="../.gitbook/assets/image (42).png" alt=""><figcaption></figcaption></figure>

Partitions are bounded by minimum and maximum values on the partition key. Since the partitions are essentially separate tables, each partition can have its own indexes and constraints.

<figure><img src="../.gitbook/assets/image (45).png" alt=""><figcaption></figcaption></figure>

In this example, we're collecting measurements. Each measurement has a location, a date, temperature and relative humidity. The partition key is the date of the measurement.

<figure><img src="../.gitbook/assets/image (46).png" alt=""><figcaption></figcaption></figure>

Now, we can partition this table into week long partitions. Here we create one partition for each week. The range of values for the partition key span one week in each partition.

<figure><img src="../.gitbook/assets/image (47).png" alt=""><figcaption></figcaption></figure>

Partitioning by range works well in a number of cases, such as when we typically query the latest data or perform comparative queries between periods of time, such as a report on this month's sales compared to last year's sales in the same month. Range partitioning also works well when we query data within a single partition. If you drop data after a certain amount of time, partitioning can make the deleting operation more efficient because the entire partition can be deleted.

<figure><img src="../.gitbook/assets/image (48).png" alt=""><figcaption></figcaption></figure>

Partitioning by list is a type of horizontal partitioning. Data is divided among partitions, based on a partition key. In this case, the partition values are defined in a list of values.

<figure><img src="../.gitbook/assets/image (49).png" alt=""><figcaption></figcaption></figure>

Now, there is a partition key, which takes values from a list of partition values. The partition bounds, are the list of values allowed in the partition. And, like other forms of horizontal partitioning, each partition can have its own indexes, constraints, and defaults.

<figure><img src="../.gitbook/assets/image (51).png" alt=""><figcaption></figcaption></figure>

Here's a product catalog example. In this products table, we have an ID, name, short and long description, and a product category. And the partition key is the product category. Notice, that when we define the partition table, we have to list the values of the partition key, that will be allowed in that partition.&#x20;

<figure><img src="../.gitbook/assets/image (50).png" alt=""><figcaption></figcaption></figure>

We use list partitioning, when data logically groups into subgroups, based on the partition key values. For example, we could have a partition for clothing, and another for electronics. This works well when most queries are within a partition. For example, we might report on clothing or electronics individually, but rarely compare the two. List partitioning is a good option, when your data is not so time-oriented, that date-based partitioning would make more sense.

<figure><img src="../.gitbook/assets/image (52).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (53).png" alt=""><figcaption></figcaption></figure>

Hash partitioning is a type of horizontal partitioning. The partition key is used as input into a function that computes a value indicating which partition should store a row of data.

<figure><img src="../.gitbook/assets/image (54).png" alt=""><figcaption></figcaption></figure>

Consider a database tracking the way customers use a web application. We might want to track each URL the customer visits the time spent on that page, the order in which the customer navigated from one page to another. We could use the CI ID column as a partition key. If we want to keep customers interactions together we could use a customer ID or session ID to ensure that all rows with a customer ID or session ID are in the same partition.

<figure><img src="../.gitbook/assets/image (55).png" alt=""><figcaption></figcaption></figure>

Here, for example, we create a set of five partitions. The CI ID is divided by five using modular division which allows us to use the remainder as the partition key.&#x20;

We use hash partitions when the data does not logically group into subgroups, and we want to maintain a fairly even distribution across partitions. And there's no need for subgroup specific operations such as dropping a particular partition.

<figure><img src="../.gitbook/assets/image (56).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (57).png" alt=""><figcaption></figcaption></figure>

So with partitioning we have the option of using range partitioning list partitioning or hash partitioning. And each is really useful for a particular use case. So in this case hash partitions are really useful when we have say high cardinality values like a customer identifier that we want to work with. Lists is useful when we have very low cardinality sort of values that we want to use. And range partitioning is really useful when we have date time attributes that we want to partition on.

<figure><img src="../.gitbook/assets/image (76).png" alt=""><figcaption></figcaption></figure>

First we partitioned the windows by brown column. So the window function will see the rows in each partition separately.

Sometimes we need to further limit the scope of a window within each partition so that not all rows use the same window, and this is what framing is all about. To define a frame, we must introduce an order so that the terms first, last, next and previous make sense. There is no such thing as first or next without an order.

<figure><img src="../.gitbook/assets/image (77).png" alt=""><figcaption></figcaption></figure>

For example, a frame that begins at the current row and ends at the following one. For the first row, this frame covers one and two, The highlighted area that you see is what the window function sees instead of the whole partition. For the second row, our frame covers two and four, for the third, four and seven, and for the last row the frame will shrink as there is no next row, and the process repeats for each partition.

<figure><img src="../.gitbook/assets/image (78).png" alt=""><figcaption></figcaption></figure>

First, we define our sorting in the ORDER BY clause. Let's use a set similar to the previous one and focus just on one partition. And we're evaluating the third row, the one with a green four. Next we specify one of three frame types, ROWS, RANGE or GROUPS. ROWS is probably the most intuitive type, so let's start with it. ROWS frame boundaries are specified using row position count. one row, 20 row, a million rows or all the rows that either precede or follow the current one. Row frames don't care what values are in these rows, they just count rows.

Next we specify where the frame begins.

<figure><img src="../.gitbook/assets/image (80).png" alt=""><figcaption></figcaption></figure>

UNBOUNDED PRECEDING points to the beginning of the partition. N PRECEDING and N FOLLOWING, point to any number of rows before or after the current one. N must be a none-null positive integer.

<figure><img src="../.gitbook/assets/image (74).png" alt=""><figcaption></figcaption></figure>

One PRECEDING and one FOLLOWING, point to the next and previous immediate neighbor rows. CURRENT ROW. Current row doesn't always mean what you think it means.

<figure><img src="../.gitbook/assets/image (75).png" alt=""><figcaption></figcaption></figure>

The frame end is specified similarly. The difference is that UNBOUNDED PRECEDING is replaced with UNBOUNDED FOLLOWING. It doesn't make sense for a frame to start at the end of the partition nor to end at the beginning of it.

<figure><img src="../.gitbook/assets/image (81).png" alt=""><figcaption></figcaption></figure>

Now, start and end are relative terms and depend on the sorting direction. So if we use descending order instead of ascending, the frame boundaries will be reversed. UNBOUNDED FOLLOWING and UNBOUNDED PRECEDING work the same way with all frame types, but that is not the case with N PRECEDING, N FOLLOWING and CURRENT ROW.

<figure><img src="../.gitbook/assets/image (82).png" alt=""><figcaption></figcaption></figure>

RANGE frames are specified using value ranges that either precede or follow the current row regardless of how many rows they cover, and RANGE frames are data type dependent.

<figure><img src="../.gitbook/assets/image (83).png" alt=""><figcaption></figcaption></figure>

So an integer range of 10 represents all rows that have a sorting value which is plus or minus 10 from the current rows value. Value not position. Unlike ROWS and GROUPS, that can use multiple sorting expressions, RANGE is limited to only one.

<figure><img src="../.gitbook/assets/image (84).png" alt=""><figcaption></figcaption></figure>

For this set a RANGE frame of one PRECEDING and CURRENT ROW, evaluated for the highlighted row, covers only the current row, as the closest preceding neighbor is two integer values away. As long as our sorting expressions are unique within the partition, there is no confusion about what CURRENT ROW means because CURRENT ROW is also current value, but if the partition contains more than one row with the same sorting value, things get interesting. <mark style="background-color:orange;">**CURRENT ROW for RANGE frames doesn't refer to the current row's position like it did with the ROWS frame. For RANGE, it refers to the current row's value, and that includes all rows that share the same value.**</mark>

<figure><img src="../.gitbook/assets/image (85).png" alt=""><figcaption></figcaption></figure>

GROUPS frames are defined using the number of peer groups following or preceding the current row's group.

<figure><img src="../.gitbook/assets/image (86).png" alt=""><figcaption></figcaption></figure>

A peer group is a set of rows that share the same sorting values. So when evaluated for the second row in this partition, a group frame that begins with one PRECEDING and ends with one FOLLOWING, will cover all partition rows.

<figure><img src="../.gitbook/assets/image (87).png" alt=""><figcaption></figcaption></figure>

The reason is that I chose to use a MAX name function, together with a frame that is sorted also by name in ascending order. Therefore, any new row which is extended into the frame is guaranteed to have a larger sorting value than the previous one and will be picked up by the MAX.

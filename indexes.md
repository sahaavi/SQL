# Indexes

When it comes to developing efficient relational database applications, one of the most important tools we have to work with are indexes. So let's take a look at different kinds of indexes that we have available to us. So first I want to go over basic idea behind an index. <mark style="color:blue;">An index is a data structure and its purpose is to improve the time or to reduce the time it takes to access data that we're actually interested in.</mark> <mark style="color:orange;">You can think of indexes as a set of keys and values, where the key is an attribute of the row that we want to retrieve.</mark> So that could be a primary key, it could be an attribute like the name in a customer table or the product type in a product table. And then there's the value. The value, in this case, is a location as to where we can retrieve the data we're interested in. Now typically, that means where the location of the row is on a particular data block. Now I want to mention I will use terms like data block, or persistent storage. <mark style="color:red;">Databases often cache data, so even though there may be a read operation, so for example, after referencing an index, I need to go fetch a piece of data, and I might refer to it as fetching it from the disc, or from SSD. In fact, the database may actually have stored that in cache so there isn't a need to actually fetch from the disc. S</mark>o I just wanted to point that out. When we're looking up data, sometimes that data may already be in memory for us. So there's several kinds of indexes. Probably the most popular is the <mark style="background-color:orange;">B-tree, and this is a type of index that allows for order log and time to find an index entry, so the key values that we're interested in.</mark> <mark style="background-color:purple;">Hash indexes use a hashing function, and so it's a constant time to do a look up to get the value of a particular key that we're looking for.</mark> <mark style="background-color:yellow;">Bitmap indexes are particularly useful when dealing with retrieving large volumes of rows, so for example, in a data warehouse application or a business intelligent application. We won't use Bitmap indexes really much for transaction processing system,</mark> which is our focus here. And then also, some databases like postgres have specialized indexes for things like geolocation indexing. Now again, those are an interesting type of index, and I just want to point them out, but we won't be delving into them any further here.

One common technique for improving query time is to use indexes. With indexes, we can avoid costly full table scans. Let's create an index on the salary column in the staff table.

<figure><img src=".gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

If we run this there won't be anything in result.

Now, if we need to access all the rows in the table, the index won't be used. So for example, if we run the following query

<figure><img src=".gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>

And we see here the full table scan has performed

<figure><img src=".gitbook/assets/image (3).png" alt=""><figcaption></figcaption></figure>

But wait, it appears that the index is still not used. Why? The reason is, is that there are so many rows with a salary greater than 75,000 that the query execution builder determined it would be faster to simply scan the whole table instead of looking up those rows in the index and then reading the table. This is a case in which our where clause is not selective enough to warrant using an index.

<figure><img src=".gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

Let's try a different salary cutoff. Let's try 150,000, and we'll run that command. And here we'll see that the index is actually used. So even though we do have an index on a table, the index may not always be used. And again, the query plan builder is trying to build a plan which will take the least amount of time overall. So it'll take into consideration time to, for example, look up data that's in an index and then go look up additional data that's in a table. And so only when the conditions are highly selective are indexes used, when those conditions are so selective that they reduce the number of rows returned sufficiently so that it basically makes the query plan builder favor using an index rather than doing the brute force method of a fold table scan.

<figure><img src=".gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

The big advantage of indexes is that they reduce the need of full scans. Another factor that makes indexes so helpful for querying is that indexes tend to be smaller than their corresponding tables. This means that they're more likely to fit in memory. That's great news for querying, because reading data from memory is much faster than reading from hard disks, or even solid state drives, or SSDs.

<figure><img src=".gitbook/assets/image (6).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (7).png" alt=""><figcaption></figcaption></figure>

The tree is balanced because the root node is the index value that splits the range of values found in the index column. For example, if an index column has values from one to 100, then the root would be 50, or close to 50 if there isn't a 50 in the column. Each side of the tree has a subtree. The top node of the subtree splits the value of the index column so that the values less than the node value are stored to the left branch of the tree, and values greater than the value in the node are stored to the right. This pattern continues at each level of the tree until we reach the bottom.

<figure><img src=".gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

B-trees make for efficient lookups because we can always determine where in a tree a node is located by looking at a node value and branching to the left or to the right until we find a value in the tree. In this example, we're looking for the value 15, so we make three comparisons at 50, 25, and 13 nodes.



B-trees are the most commonly used type of index. <mark style="background-color:green;">It's used when there is a large number of distinct values in a column, this is called high cardinality.</mark> <mark style="background-color:yellow;">B-trees also rebalance as needed to keep the depth of the tree about the same for all paths.</mark> This prevents a lopsided tree that would be fast to search on one side and slower on the other. Anytime you look up a value in a B-tree index, you can expect it to take the time that is proportional to the log of the number of nodes in the tree.

To drop index

```
drop index index_name
```

#### Bitmap Index

These are well suited for low cardinality columns. Bitmap indexes store a series of bits for indexed values. The number of bits used is the same as the number of distinct values in a column.&#x20;

<figure><img src=".gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

For example, a column that has either a yes or no value would require two bits, one corresponding to the yes, and one corresponding to the no. We aren't restricted to Boolean or yes/no columns. We could have three or more values. For example, if we have a pay type which has three possible values, we could use three bits to represent the pay type. One of the advantages of bitmap indexes is that we can perform Boolean operations quickly. For example, anding two bitmaps is a fast operation, so we could use it to find all union members who have hourly pay rates.

<figure><img src=".gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

While bitwise operations are fast, updating bitmap indexes can be more time consuming than other indexes, so they tend to be used in read intensive use cases like data warehouses.

Now let's create an index on job title

```
create index idx_staff_job_title on staff(job_title)
```

Now if we run the query below

<figure><img src=".gitbook/assets/image (11).png" alt=""><figcaption></figcaption></figure>

![](<.gitbook/assets/image (12).png>)we created an index which, by default, is a B-tree index, but we're not using a B-tree index here. Instead, the query plan creates a bitmap index and performs a bitmap index scan. Now, Postgres uses those when an index scan would reach too much data, but a full table scan is not warranted. Also, notice the query plan uses a bitmap heap scan, which only visits data blocks that are needed and does not scan all the index blocks. So that's an example of a case where Postgres will create bitmaps on the fly and use those rather than the B-tree index that we actually created.

#### Hash Indexes

<figure><img src=".gitbook/assets/image (13).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (14).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (15).png" alt=""><figcaption></figcaption></figure>



<mark style="color:red;">They're only used for equality comparisons.</mark> <mark style="background-color:yellow;">Hash values won't help you if you want to filter on a range of values.</mark> Some recent improvements in Postgres have led to hash indexes that can be smaller than B-tree indexes, but still just as fast or faster, so this can be an advantage when you want to keep an entire hash index in memory. Also, because they're fast or as fast as B-tree indexes, the choice between hash indexes and B-tree, if given the choice, come down to the advantage of being able to store an entire index in memory, which is possible with some hash indexes.

Let's create a hash index on the email column of the staff table. The email column is a good candidate for hash indexing, since the email should be unique to each person and it's likely we want to be able to, say, look up a person's data using their email. Also, it's not likely that we'd want to perform a range scan query using email address.

<figure><img src=".gitbook/assets/image (16).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (17).png" alt=""><figcaption></figcaption></figure>

Now let's see what happens if we use B-Tree index

<figure><img src=".gitbook/assets/image (18).png" alt=""><figcaption></figcaption></figure>

There's a slight differece in computational unit used by B-Tree index but if the database is large enough we'll see significant difference in performance

#### Bloom Filter Indexes

Sometimes when we write queries, we want to filter out data and find like a very specific group of rows. For example, if we're working in, say, a retail industry and we want to analyze different customers and we group customers along different attributes, like what geographic region do they live in? How frequently do they shop at a store? What's the total amount of sales they might have used? And are they a loyalty card member? And so on, and so we might have a large number of sort of conditions that we want to satisfy because we want to find something very precise. And so in that way, it's kind of like finding a needle in a haystack. And one of the questions we have or we need to address when we're tuning queries like that is how do we index a table like that in such a way that, one, it's efficient we can efficiently query the data? But also we don't want to have a crazy large number of indexes that we need to maintain, because that takes up a lot of space and every time we insert a row we need to update all of those indexes. This really is a challenge and it's almost like an edge case in indexing, but it does come up frequently enough that there are particular solutions that seem to work well. Now you might think, "Well, we just organize our data." So, for example, if we have a large number of chunks of data, which we call partitions, and we're going to be discussing that shortly, we might organize our chunks of data or our partitions in a certain way.&#x20;

<figure><img src=".gitbook/assets/image (19).png" alt=""><figcaption></figcaption></figure>

Like, we might have a column and the column might have an integer value. And so anything with a column value of between one and 10 we put in one block, and 11 to 20 we put in another block, and so on. And that way if we know the value of the column, we can pretty quickly determine which block we should go retrieve. And that works really well. That actually is a great strategy in many cases. However, the constraint on using that is that strategy only works well when your lookup criteria is the same as your sort of organizing principle that you used for ordering the partitions. When you're looking for something or using some criteria that's different than your organizing principle for the data blocks and the partitions, then it doesn't really help so much.

<figure><img src=".gitbook/assets/image (20).png" alt=""><figcaption></figcaption></figure>

So, for example, we might arrange our data volumes by a particular kind of code, but we might want to look up by several different codes, but of different types of codes. So, in that case, a different strategy that works well is something called a bloom filter. Now a bloom filter is basically a way of filtering out, in this case, like blocks or rows, that definitely don't meet our criteria, but the bloom filter might return some results that actually don't meet our filter criteria, but somehow they kind of slip past that check. And so what a bloom filter does is it allows us to trade off things like keeping a large number of indexes and storing a large amount of data. So we trade that for a more probabilistic approach in which we get the results back and we can know for sure that the data we're looking for is in our results, but then we may also have some extra stuff that actually didn't quite fit the filter, and that is a trade-off. And the question is, is that a good trade-off for you to make from an indexing strategy perspective?

<figure><img src=".gitbook/assets/image (21).png" alt=""><figcaption></figcaption></figure>

Well, it depends. And it depends because a bloom filter index is probabilistic, which means it's not deterministic, we might get some results that aren't actually fitting our filter criteria. But it's really space efficient, highly space efficient. And the reason it is so space efficient is that we lose information. It's a lossy representation, unlike, say, a B-tree index where we don't lose information. So we're losing a little bit of information, but we're saving a lot on storage space. And because of this, when we get results back we may have some false positives. So if we can quickly filter through those false positives afterwards, then it may be useful to use a bloom filter. Now, typically, bloom filters are especially useful when we're querying arbitrary combinations or a large number of attributes. Now we might think, "Well, we could use B-tree indexes." And B-tree indexes in many cases are faster. But with B-tree indexes we would have to create an individual index for each column that is in the combination of columns that we're interested in querying on. That's not the case with a bloom filter.

<figure><img src=".gitbook/assets/image (22).png" alt=""><figcaption></figcaption></figure>

With a bloom filter index, we create a single index. So, in this case, I'm going to create a custom bloom index on a table called customer features. And I'm going to assume that in this customer features table I have a bunch of columns, and I'm particularly interested in C1, C2, and so on through C8. So I have eight columns that I'm interested in. And it could be any combination, I could have values for C2, C5, C8, or I could have combinations for C1, C4, C5, C6, C7. We could use this one index for any of those combinations. We wouldn't have to have a bunch of different indexes. So, one, it's helpful because we don't have to have as many indexes. And also it's helpful because the size of the index itself can be smaller because we control the size of the bloom filter index, how much data we use to store an entry in this index, and we specify it in terms of the length of the number of bits that we want to use to represent an index entry. In this case, I'm using 160 bits to represent eight different columns. Now one thing to know is that we can trade-off storage space for more certainty around false positives. So the longer the length of the index entry, the smaller the chance of false positives being included in the results when we use this index. Now bloom filter types of index work with integers and text data types. Now, because the bloom filter index is an extension, that is, it's not part of the Postgres core, if we want to use bloom filter indexes, the first thing we need to do in our database is to create the extension, if it doesn't already exist, by using the create extension if not exists bloom command. And we just need to do that once, you know, once a database is created, and then it will be available for us. And then, we can start creating bloom filter indexes as we see here in this example at the top of the screen.

#### PostgreSQL specific indexes

<figure><img src=".gitbook/assets/image (23).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (24).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (26).png" alt=""><figcaption></figcaption></figure>

But the builds can be slower than they are with GiST, and the indexes can be two to three times larger. So GIN versus GiST is an example of what we often face when we work with different kinds of algorithms, which is sometimes, we optimize for space, and sometimes, we optimize for time. And often, there's a tradeoff between the two.

<figure><img src=".gitbook/assets/image (27).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (28).png" alt=""><figcaption></figcaption></figure>

The solution to this challenge is to use a hash index. Now, the reason is that the sensor ID that we're going to be looking up on is high cardinality. That means there's many, many different values, and we're using equality conditions to filter the rows. And also, hash indexes provide essentially a constant time operation. So as the size of the table grows, the size of doing the lookup in the index does not grow, which is not the case when we're using BTREE indexes.

#### Covering indexes

Now we're going to turn our attention to something called a covering index. <mark style="background-color:purple;">Now a covering index is not a new type, like a B-tree or a hash index. Instead, a covering index is one that is created based on the values that are stored in the index.</mark> Now, let's think about what happens when we use an index. Basically it starts when the query plan builder determines which indexes to use to satisfy a query. The locations of the rows are retrieved from the index, and then the rows are retrieved either from cache or persistent storage and then we apply filtering, joining, functions, etc., and then we return the results, so that's the basic structure of an execution plan. Now, a covering index is an index in which all columns referenced in a query are in that index, and what that means is there's no need to retrieve data from the table and that saves a seek operation. So what we have is a series of steps in which we can remove one of the most expensive steps of that operation which is the retrieving in the rows from the cache or the persistent storage.&#x20;

<figure><img src=".gitbook/assets/image (89).png" alt=""><figcaption></figcaption></figure>

Let's take a look at our customer table. Here we have our customer information and it includes things like name and address. Now let's suppose we have a query that looks up by last name and state or province. We can create an index, and I'll call it IDX, L name, state, province, and I'll create that index on the customer table, and I will be using a B-tree index, and the index is basically the last name and the state or province. What that allows us to do is to have queries such as this where I'm selecting only the last name and the state or province and I'm filtering on a province and I have a particular list here. I'm looking at all states on the western coast of the continental United States. So again, a covering index is one that has all of the values that are referenced in a query, so covering indexes are relative to particular queries, and again, the key factor is that all values that are referenced in the select statement are available in the index and that saves us that extra operation of going from the index to actually seeking and looking up and retrieving data from rows on persistent disk or occasionally cache.

### Indexes and bulk data loading

Now we're going to shift gears and talk a little bit about some issues you might run into, in production. The first one I want to talk about, is bulk loading and indexing. Now, when we add data to a table, the data is actually inserted into the table and then, any indexes are updated. So, as we add a row to the table, we add an entry to the index. You can imagine the sequence, add a row to the table, add an entry to the index. Now, that kind of back and forth operation works well, when you're doing transaction processing, so you might have many different processes running to the database, because you have, for example, different customers placing different orders at different times. So this kind of back and forth and writing to the table and the index, in the same kind of operation, it makes a lot of sense. Now, when you're bulk loading data, for example, if you're loading up a bunch of data, maybe some historical records, or some new customer data, what we find is, we're inserting a large number of rows at once, and each time the row is inserted, the index is also updated. So we're alternating back and forth between the table, updating and the index updating. So let's look, an alternate way to do that though is to focus just on the table. So for example, in a bulk operation we would want to insert a row followed by another row, followed by another row and so on until we had the table full. And then, we just create the index, we immediately build the index rather than alternating back and forth. Now, the way we do this, is that we drop any indexes before we bulk load any data. Then we insert the data. Now, oftentimes databases, will have a bulk loading program and these are highly optimized. And after we insert the data, then we create the index. And this operation is much more efficient because that bulk loading program I referenced, can take advantage of the fact that it knows, for example, it doesn't have to update indexes, and so it can be much faster in terms of writing data to the desk. So, if you ever find that you're working with a production database and you need to do a bulk load and you want to do it as quickly as possible, drop all the indexes first, do the bulk load, and then recreate the indexes.

### Avoiding index locks

Now, another issue we can run into in production that's related to indexing, is something called an index Lock. Now, an index Lock can occur when we need to rebuild an index. Now you may wonder why we'd ever need to rebuild and index. Well in theory we shouldn't, however in practice sometimes there are errors in the index, like an index may become corrupted, because of a software bug or something that causes the data in the index to become invalid. And so it needs to be corrected and the most effective and reliable way to do that, is by rebuilding an index. But even if it's not an error, you may learn things about the, sort of the characteristics about how your database is being used, and you may decide after some period of time that you want to adjust maybe some of the storage parameters, in your create index clause. Well if that's the case you going to need to rebuild the index. Also there are some unusual access patterns that can lead to some, almost like fragmentation in the pages that are stored in b-trees. And so what we may end up with is a balanced tree index that has many pages with very few entries. So to correct with that, we need to rebuild the index. So those are times we might need to rebuild an index. But we need to keep in mind that during a rebuild on an index, PostgreSQL for example, will lock the table for Writes. So that means any Insert, Update or Delete is not going to finish, it's going to be blocked. Now PostgreSQL does allow reads. So for example, you can execute Select statements during an index rebuild. Those won't be blocked. So that pattern may be okay if you're working in a business intelligence application, such as a data warehousing or data Mart kind of environment, where there's bulk data loading going on, say off hours, and then users are running reports during the day. That kind of Select only read-only kind of operation wouldn't be impacted, but we're primarily talking about transaction processing applications, like the e-commerce application, where you might be reading about customer data or, and then writing new customer data at the same time, different processes doing both of those things. So we can't count on having read-only requests. And so we need to be able to figure out a way of rebuilding our index so that we don't get this index lock error while we're in production. So the way to do that is to use the Create Index Concurrently Command and what this does it's a relatively new feature in PostgreSQL that allows you to build a new index on a table without blocking rights. And it does this by basically building the new index while using the old index and then immediately switches over once the index is built. So again, this is sort of an issue that you may run into in production. So if you do need to rebuild an index in production, consider using the Create Index Concurrently Command.

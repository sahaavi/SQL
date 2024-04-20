# On Delete

<figure><img src="../.gitbook/assets/image (18) (1) (1).png" alt=""><figcaption></figcaption></figure>

Let's say we deleted manager whom id is 102. Now 102 is associated with branch table as well. So if we delete this employee what will happen to Branch table 2nd row where mgr\_id is 102.

That's why we use `ON DELETE SET NULL` it will keep the row but make the mgr\_id value null. But if we use `on delete set cascade` it will delete rows from other tables where mgr\_id 102 is linked.

in branch\_supplier table we used cascade in branch\_id foreign key becayse here branch\_id is part of primary key we can't make it null while any branch will be deleted. Primary key can't be null

wehere as mgr\_id is not a part of primary key in branch table that's why we used `on delete set null` as it is not crucial for branch table.

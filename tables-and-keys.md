# Tables & Keys

### Primary Key

Primary key is unique. This will be different for each row/record. It can be id, email etc.

<figure><img src=".gitbook/assets/image (7) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

Here employee id is a Primary key. We can also call it a surrogate key. Surrogate key is a type of primary key that doesn't have any mapping to the real world. Below we have the same employee table instead of having an employee id we have employee ssn.

<figure><img src=".gitbook/assets/image (8) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

SSN is a number that use for identify a citizen. Here we're using SSN to indentify an employee in the table. But SSN serves a purpose in the real world as well outside of this database. We call this type of primary key as Natural key.

### Foreign Key

This key maps a table to another table. Forign key is a primary key of another table.

<figure><img src=".gitbook/assets/image (10) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

<figure><img src=".gitbook/assets/image (9) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

### Composite Key

If any single column can't uniquely identify each row we can use a combination of another column. These two column combinedly serves as a primary key of the table.

![](<.gitbook/assets/image (11) (1) (1) (1).png>) &#x20;

In the image below both the columns of composite key are foreign keys

<figure><img src=".gitbook/assets/image (12) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

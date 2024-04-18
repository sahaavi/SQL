# Designing A ER Diagram

### Company Data Storage Requirements <a href="#company-data-storage-requirements" id="company-data-storage-requirements"></a>

The company is organized into branches. Each branch has a unique number, a name, and a particular employee who manages it.

<figure><img src="../.gitbook/assets/image (35).png" alt=""><figcaption></figcaption></figure>

The company makes it’s money by selling to clients. Each client has a name and a unique number to identify it.

<figure><img src="../.gitbook/assets/image (36).png" alt=""><figcaption></figcaption></figure>

The foundation of the company is it’s employees. Each employee has a name, birthday, sex, salary and a unique number.

<figure><img src="../.gitbook/assets/image (37).png" alt=""><figcaption></figcaption></figure>

An employee can work for one branch at a time, and each branch will be managed by one of the employees that work there. We’ll also want to keep track of when the current manager started as manager.

<figure><img src="../.gitbook/assets/image (38).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (39).png" alt=""><figcaption></figcaption></figure>

An employee can act as a supervisor for other employees at the branch, an employee may also act as the supervisor for employees at other branches. An employee can have at most one supervisor.

<figure><img src="../.gitbook/assets/image (40).png" alt=""><figcaption></figcaption></figure>

A branch may handle a number of clients, with each client having a name and a unique number to identify it. A single client may only be handled by one branch at a time.

<figure><img src="../.gitbook/assets/image (41).png" alt=""><figcaption></figcaption></figure>

Employees can work with clients controlled by their branch to sell them stuff. If nescessary multiple employees can work with the same client. We’ll want to keep track of how many dollars worth of stuff each employee sells to each client they work with.

<figure><img src="../.gitbook/assets/image (42).png" alt=""><figcaption></figcaption></figure>

Many branches will need to work with suppliers to buy inventory. For each supplier we’ll keep track of their name and the type of product they’re selling the branch. A single supplier may supply products to multiple branches.



<figure><img src="../.gitbook/assets/image (34).png" alt=""><figcaption></figcaption></figure>

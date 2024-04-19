# Missing information and ternary logic

Dr. Codd's level of expertise, that you should think of NULLs as being an indicator and not as a value. This distinction will help you tackle its complexities much easier. Zero is a concrete value. An empty string is a valid value. NULL is not a value, it is an indicator to the absence of one.

<figure><img src="../../.gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

Codd made a clear distinction between two types of missing data. A values and I values representing missing and applicable and missing but inapplicable, respectively. For example, we may not know exactly when our puppy was born. That doesn't mean he doesn't have a birth date. Obviously he does, we just don't know it. This is an applicable, but missing value. Our second puppy is a mongrel. For the mongrel, the breed attribute is inapplicable. It won't ever change, we will never find out its breed. Breed is an irrelevant attribute for this puppy. It's not that we don't know it, it just doesn't exist.

Chamberlin and Boyce, the original developers of SQL, decided not to implement this distinction, and so we ended up with only one type of NULL to represent both. With only one type of NULL, SQL implements three valued logic, also known as ternary logic. If they were to implement both types of NULLs as Codd suggested, it would have required a four value or quaternary logic. In our everyday lives, we deal with both binary and ternary logic. If I ask you, are you at work now? Your answer is either yes or no. This is the domain of binary logic where a predicate can evaluate to a logical state of either true or false. Ternary logic adds a third state, an unknown. Let's say you receive two packages, and before you open them, I ask you, is there a book in the small package? Your only honest answer is, I don't know.

The data regarding the content of the package is not available yet. There is something in the box, you hope, you just don't know what it is yet. This is missing, but applicable information. And comparing a known value, a book, to an unknown value, the content of the package is still unknown. Next, I ask you, what's the gender of the large package? You still can't answer this question, but this time for a different reason. The gender attribute is inapplicable to packages, at least to those that I am aware of. This is the missing and inapplicable type of unknown.

<figure><img src="../../.gitbook/assets/image (10).png" alt=""><figcaption></figcaption></figure>

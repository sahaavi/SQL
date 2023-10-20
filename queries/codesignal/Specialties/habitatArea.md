As a young naturalist, you've been studying the inhabitants of the nearby woods for the past several months. You've just come across some footprints you've never seen before. To learn more about the habitat of the animal that left them, you marked the footprints locations on your map.

The information about the places where the animal left its footprints is stored in the table **places**. Here is its structure:

- x: the x-coordinate of the place;
- y: the y-coordinate of the place.

It is guaranteed that pairs (x, y) are unique.

Now you want to find the area of the animal's habitat. You decided that the convex hull of the marked points is a good first approximation of the habitat, so you want to find the area of this hull.

Given the places table, write a select statement which returns only one column area and consists of a single row: the area of the convex hull. It is guaranteed that the resulting area is greater than 0.


### Example

For the following table places

<table>
  <tbody><tr>
    <th>x</th>
    <th>y</th>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>1</td>
    <td>2</td>
  </tr>
  <tr>
    <td>2</td>
    <td>1</td>
  </tr>
  <tr>
    <td>5</td>
    <td>1</td>
  </tr>
  <tr>
    <td>5</td>
    <td>2</td>
  </tr>
</tbody></table>

the output should be

<table>
<tbody><tr>
<th>area</th>
</tr>
<tr>
<td>6.5</td>
</tr>
</tbody></table>

Here is an illustration of the given points and their convex hull:

<img src="https://codesignal.s3.amazonaws.com/uploads/1667243821871/example.png?raw=true" alt="" title="Example">

Note that you should return the exact answer without any trailing zeros.

### MySQL Query

```sql
SET @pts := (SELECT CONCAT("MULTIPOINT(", GROUP_CONCAT(x,' ',y, '') , ")") FROM places);

SELECT ST_AREA(ST_ConvexHull(ST_GeomFromText(@pts))) as area;
```

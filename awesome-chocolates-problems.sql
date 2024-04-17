# check all the tables first to make the relation viz 
select * from geo;
desc geo;

select * from people;
desc people;

select * from products;
desc products;

select * from sales;
desc sales;

-- INTERMEDIATE PROBLEMS

-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * 
from sales
where amount > 2000 and boxes < 100;

-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
select spid, count(*) as sales
from sales
where month(saledate) = 1 and year(saledate) = 2022
group by spid;

-- 3. Which product sells more boxes? Milk Bars or Eclairs?
select pid, sum(boxes) as 'total sales (box)'
from sales
where pid in (
	(
		select pid
		from products
		where product = 'Eclairs'
    ),
    (
		select pid
		from products
		where product = 'Milk Bars'
	)
)
group by pid;



-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

select pid, sum(boxes) as 'total sales (box)'
from sales
where pid in (
	(
		select pid
		from products
		where product = 'Eclairs'
    ),
    (
		select pid
		from products
		where product = 'Milk Bars'
	)
) and saledate >= '2022-01-01' and saledate <= '2022-01-07'
group by pid;

-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

select spid, saledate
from sales
where boxes < 100 and customers < 100 and weekday(saledate) = 3;

select *
from sales
where spid = 'SP08' and boxes < 100 and customers < 100;


-- HARD PROBLEMS

-- 1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?


-- 2. Which salespersons did not make any shipments in the first 7 days of January 2022?


-- 3. How many times we shipped more than 1,000 boxes in each month?


-- 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?


-- 5. India or Australia? Who buys more chocolate boxes on a monthly basis?


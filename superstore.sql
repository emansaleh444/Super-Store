create table superstore(
rowid int,
orderid char(50),
orderdate date,
shipdate date,
shipmode character varying (50),
customerid char(50),
customername character varying (50),
segment character varying (50),
country character varying (50),
city character varying (50),
state character varying (50) ,
postalcode char(50),
region character varying (50),
productid char(50),
category character varying (50),
subcategory character varying (50),
productname character varying (200),
sales numeric,
quantity integer,
discount numeric,
profit numeric
);
copy superstore from 'D:\superstore.csv'delimiter ',' csv header encoding 'windows-1251';

SELECT *
FROM superstore
LIMIT 5;
1/*What are total sales and total profits of each year?*/
SELECT DATE_TRUNC('year', orderdate) AS year, 
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM superstore
GROUP BY year
ORDER BY year ASC;
2/* What are the total profits and total sales per quarter?*/
SELECT date_part('year', orderdate)as year,
case
when date_part('month',orderdate) in (1,2,3) then 'Q1'
when date_part('month',orderdate) in (4,5,6) then 'Q2'
when date_part('month',orderdate) in (7,8,9) then 'Q3'
else 'Q4'
end as quarter,
sum(sales)as total_sales,
sum(profit)as total_profit
from superstore
group by year, quarter
order by year, quarter;
3/* What region generates the highest sales and profits ?*/
select region, sum(sales) as total_sales, sum(profit) as total_profits
from superstore 
group by region
order by total_profits desc;
---------------------------------------
select region, round((sum(profit)/sum(sales))*100, 2)as profit_margin
from superstore
group by region
order by profit_margin desc;
4/* What state and city brings in the highest sales and profits ?
 Let’s discover what states are the top 10 highest and lowest and then
 we will move on to the cities. For the states, it can be found with the following code:*/
select state, sum(sales) as total_sales, sum(profit) as total_profits, round((sum(profit)/sum(sales))*100,2) as profit_margin
from superstore
group by state
order by total_profits desc
limit 10;
-----------------
select state, sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by state
order by total_profits asc
limit 10;
---------------------
select city, sum(sales) as total_sales, sum(profit) as total_profits, round((sum(profit)/sum(sales))*100,2) as profit_margin
from superstore
group by city
order by total_profits desc
limit 10;
------------------
select city, sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by  city
order by total_profits asc
limit 10;

5/*  The relationship between discount and sales and the total discount per category?*/
-
select discount , avg(sales) as Avareg_sales
from superstore
group by discount
order by discount
-
select category, sum(discount) as total_discount
from superstore
group by category
order by total_discount desc;
-
select category,subcategory, sum(discount) as total_discount
from superstore
group by category, subcategory
order by total_discount desc;

6/*  What category generates the highest sales and profits in each region and state ?*/
/*  total sales and total profits of each category with their profit margins:*/
select category, sum(sales) as total_sales, sum(profit) as total_profits, round((sum(profit)/sum(sales))*100,2) as profit_margin
from superstore
group by category
order by total_profits desc
/* highest total sales and total profits per Category in each region:*/
select region, category,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by region, category
order by total_profits desc
/* highest total sales and total profits per Category in each state:*/
select state, category,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by state, category
order by total_profits desc
/* check the least profitable ones by just changing our ‘ORDER BY’ clause too ascending (ASC) */
select state, category,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by state, category
order by total_profits asc
------------------------------------------
7/*  What subcategory generates the highest sales and profits in each region and state ?*/
/*  total sales and total profits of each subcategory with their profit margins:*/
select subcategory, sum(sales) as total_sales, sum(profit) as total_profits, round((sum(profit)/sum(sales))*100,2) as profit_margin
from superstore
group by subcategory
order by total_profits desc
/* highest total sales and total profits per subcategory in each region:*/
select region, subcategory,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by region, subcategory
order by total_profits desc
/* highest total sales and total profits per subcategory in each state:*/
select state, subcategory,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by state,subcategory
order by total_profits desc
---------------------
8/* What are the names of the products that are the most and least profitable to us?*/
select productname,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by productname
order by total_profits desc
-----
select productname,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by productname
order by total_profits asc
9/* What segment makes the most of our profits and sales ?*/
 select segment,  sum(sales) as total_sales, sum(profit) as total_profits
from superstore
group by segment
order by total_profits desc
10/*How many customers do we have (unique customer IDs) in total and how much per region and state?*/
----
select count(distinct customerid) as total_customers
from superstore;
-----
select region, count(distinct customerid) as total_customers
from superstore
group by region
order by total_customers desc;
-----
select state, count(distinct customerid) as total_customers
from superstore
group by state
order by total_customers desc;

11/* Customer rewards program*/
select customerid, sum(sales) as total_sales,sum(profit) as total_profit
from superstore
group by customerid
order by  total_sales desc
limit 15;
12/*  Average shipping time per class and in total*/
select round(avg(shipdate - orderdate),1) as avg_shipping_time
from superstore

select shipmode,round(avg (shipdate - orderdate),1) as avg_shipping_time
from superstore
group by shipmode
order by avg_shipping_time

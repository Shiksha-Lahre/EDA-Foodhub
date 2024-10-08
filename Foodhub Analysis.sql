# creating and using a database Foodhub to store the table
create database Foodhub;
use Foodhub;
show tables;

# displaying all the data in the table
select * from food_order;

# displaying data type of each table
desc food_order;

set SQL_SAFE_UPDATES = 0;

#setting rating=0 where rating has not been given
update food_order set rating=0 where rating='Not given' and order_id is not null;

# showing total number of orders
select count(order_id) as `total orders` 
from food_order;

# total number of restaurant
select count(distinct restaurant_name) as `number of restaurants`
from food_order;

# showing different rating given by customers
select distinct(rating) from food_order;

# showing various food type
select distinct(cuisine_type) from food_order;

# minimal information about cost of the order
select min(cost_of_the_order) as `minimum order cost`,
max(cost_of_the_order) as `maximum order cost`, 
avg(cost_of_the_order) as `average order cost`
from food_order;

# minimal information about order time
select day_of_the_week,count(day_of_the_week) 
as `Number of orders` 
from food_order 
group by day_of_the_week;

# minimal information about food preparation time
select concat(min(food_preparation_time),' minutes') as `minimum prep time`,
concat(max(food_preparation_time),' minutes') as `maximum prep time`,
concat(round(avg(food_preparation_time),2),' minutes') as `average prep time` 
from food_order;

# minimal information about food delivery time
select concat(min(delivery_time),' minutes') as `minimum delivery time`,
concat(max(delivery_time),' minutes') as `maximum delivery time`,
concat(round(avg(delivery_time),2),' minutes') as `average delivery time` 
from food_order;

# Decreasing demand of cuisine type
select cuisine_type, count(cuisine_type) as `Number of customers liked`
from food_order
group by cuisine_type
order by `Number of customers liked` desc;

# Number of cuisines having cost 50% greater than average cost of each cuisine type
select cuisine_type,count(customer_id) as `Number of people ordered`,
count(cost_of_the_order) as `Number of orders`
from food_order
where cost_of_the_order >(
    select 1.5 * AVG(cost_of_the_order) from food_order
)
group by cuisine_type
order by `Number of orders`;

# Cuisine with higest and lowest price
select cuisine_type, max(cost_of_the_order), min(cost_of_the_order)
from food_order
group by cuisine_type
order by cuisine_type;

# Dish with highest and lowest price
select cuisine_type, cost_of_the_order
from food_order
where cost_of_the_order = (select MAX(cost_of_the_order) from food_order)
union all
select cuisine_type, cost_of_the_order
from food_order
where cost_of_the_order = (select MIN(cost_of_the_order) from food_order);

#Average Order Cost by Cuisine Type and Day of the Week
select cuisine_type, day_of_the_week, 
avg(cost_of_the_order) as avg_order_cost
from food_order
group by cuisine_type, day_of_the_week
order by avg_order_cost desc;

#Total Orders and Average Rating by Restaurant
select restaurant_name, 
count(order_id) as total_orders, 
round(avg(rating),2) as average_rating
from food_order
group by restaurant_name
order by total_orders desc, average_rating desc;

#Top 3 Restaurants with the Highest Average Cost on Weekends
select restaurant_name, 
avg(cost_of_the_order) as avg_weekend_cost
from food_order
where day_of_the_week = 'weekend'
group by restaurant_name
order by avg_weekend_cost desc
limit 3;

#Most Common Cuisine Type on Weekdays vs. Weekends
select  cuisine_type, 
day_of_the_week, 
count(order_id) as total_orders
from food_order
group by cuisine_type, day_of_the_week
order by total_orders desc;

#Restaurant Performance: Preparation Time vs. Delivery Time
select restaurant_name, 
avg(food_preparation_time) as avg_prep_time, 
avg(delivery_time) as avg_delivery_time
from food_order
group by restaurant_name
having avg(food_preparation_time) > avg(delivery_time)
order by avg_prep_time desc;

#Top 5 Restaurants with Highest Ratings and Fastest Delivery
select restaurant_name, 
avg(rating) as avg_rating, 
avg(delivery_time) as avg_delivery_time
from food_order
group by restaurant_name
having avg(rating) >= 4
order by avg_rating desc, avg_delivery_time asc
limit 5;

#Customer Spending Pattern by Weekdays vs. Weekends
select customer_id, 
day_of_the_week, 
round(sum(cost_of_the_order)) as total_spent
from food_order
group by customer_id, day_of_the_week
order by total_spent desc;















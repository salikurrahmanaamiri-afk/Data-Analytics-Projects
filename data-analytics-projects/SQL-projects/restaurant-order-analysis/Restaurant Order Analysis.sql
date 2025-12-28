DROP SCHEMA IF EXISTS restaurant_db;
CREATE SCHEMA restaurant_db;
USE restaurant_db;

-- Table structure for table `order_details`
CREATE TABLE order_details (
  order_details_id SMALLINT NOT NULL,
  order_id SMALLINT NOT NULL,
  order_date DATE,
  order_time TIME,
  item_id SMALLINT,
  PRIMARY KEY (order_details_id)
);

-- Table structure for table `menu_items`
CREATE TABLE menu_items (
  menu_item_id SMALLINT NOT NULL,
  item_name VARCHAR(45),
  category VARCHAR(45),
  price DECIMAL(5,2),
  PRIMARY KEY (menu_item_id)
);

-- Insert data into table order_details & talbe menu_items
INSERT INTO order_details VALUES () | INSERT INTO menu_items VALUES ()

-- Explore the items table
-- 1. View the menu_items table and write a query to find the number of items on the menu
select * from menu_items; 
select count(*) from menu_items;

-- 2. What are the least and most expensive items on the menu?
select * from menu_items where price = (select max(price) from menu_items);
select * from menu_items where price = (select min(price) from menu_items);

-- 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
select count(*) from menu_items where category = 'Italian';
select * from menu_items where price = (select max(price) from menu_items where category = 'Italian');
select * from menu_items where price = (select min(price) from menu_items where category = 'Italian');

-- 4. How many dishes are in each category? What is the average dish price within each category?
select category, count(*) from menu_items group by category;
select category, avg(price) from menu_items group by category;

-- Explore the orders table
-- 1. View the order_details table. What is the date range of the table?
select * from order_details;
select min(order_date) as earliest_date, max(order_date) as latest_date from order_details;

-- 2. How many orders were made within this date range? How many items were ordered within this date range?
select count(distinct order_id) from order_details where order_date between (select min(order_date) from order_details) and (select max(order_date) from order_details);
select count(*) from order_details where order_date between (select min(order_date) from order_details) and (select max(order_date) from order_details);

-- 3. Which orders had the most number of items?
select order_id, count(item_id) as num_items from order_details group by order_id having num_items = (select count(item_id) as num_items from order_details group by order_id order by num_items desc limit 1);

-- 4. How many orders had more than 12 items?
select count(*) from (select order_id, count(item_id) as num_items from order_details group by order_id having num_items > 12) as num_orders;

-- Analyze customer behavior
-- 1. Combine the menu_items and order_details tables into a single table
select * from order_details o left join menu_items m on m.menu_item_id = o.item_id;

-- 2. What were the least and most ordered items? What categories were they in?
with result as (select m.item_name, count(*) as order_count, dense_rank () over (order by count(*) desc) as most_ordered_item 
from menu_items m join order_details o on m.menu_item_id = o.item_id group by m.item_name) select * from result where most_ordered_item = 1;
-- or 
select m.item_name, count(o.order_details_id)
from order_details o left join menu_items m 
	on m.menu_item_id = o.item_id
group by m.item_name
order by count(o.order_details_id) desc;

with result as (select m.menu_item_id, m.item_name, count(*) as order_count, dense_rank () over (order by count(*)) as least_ordered_item 
from menu_items m join order_details o on m.menu_item_id = o.item_id group by m.menu_item_id, m.item_name) select * from result where least_ordered_item = 1;
-- or
select m.item_name, count(o.order_details_id)
from order_details o left join menu_items m 
	on m.menu_item_id = o.item_id
group by m.item_name
order by count(o.order_details_id);

select * from 
	(select m.item_name, m.category, count(*) as order_count, 
		dense_rank() over(order by count(*)) as least_ordered_item,
		dense_rank() over(order by count(*) desc) as most_ordered_item
	from menu_items m join order_details d 
		on m.menu_item_id = d.item_id 
	group by m.item_name, m.category) as rk 
where most_ordered_item = 1 or least_ordered_item = 1 order by order_count desc;
-- or 
select m.item_name, m.category, count(*)
from order_details o left join menu_items m
	on m.menu_item_id = o.item_id 
group by m.item_name, m.category
order by count(*) desc; -- for most ordered item with category (just order by count(*) for least ordered item with category)

-- 3. What were the top 5 orders that spent the most money?
select o.order_id, sum(m.price) as total_spend 
from order_details o join menu_items m 
	on m.menu_item_id = o.item_id 
group by o.order_id 
order by total_spend desc limit 5;

-- 4. View the details of the highest spend order. Which specific items were purchased?
select m.item_name, m.category, sum(price) as amount_spent from menu_items m join order_details o on m.menu_item_id = o.item_id where order_id = 
(select order_id from order_details o join menu_items m on m.menu_item_id = o.item_id group by order_id order by sum(m.price) desc limit 1)
group by m.item_name, m.category order by amount_spent desc;

-- 5. : View the details of the top 5 highest spend orders
with orders as (select o.order_id from order_details o join menu_items m on m.menu_item_id = o.item_id group by o.order_id order by sum(m.price) desc limit 5)
select m.item_name, m.category, sum(price) from menu_items m join order_details o on m.menu_item_id = o.item_id join orders t on o.order_id = t.order_id group by m.item_name, m.category order by sum(price) desc;
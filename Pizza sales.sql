use pizza_sales;

/*
-- KPIs

-- 1 Total Revenue
-- 2 Avg order value
-- 3 Total pizzas sold
-- 4 Total Orders
-- 5 Avg pizza per order

-- Questions to Answer

-- 1 Daily trends for total orders
-- 2 Hourly trends for total orders
-- 3 Percentage of sales by pizza  category
-- 4 Percentage of sales by pizza size
-- 5 Total pizzas sold by pizza category
-- 6 Top 5 Best sellers by total pizza sold
-- 7 Bottom 5 or 5 worst sellers by total pizza sold

*/

-- 1- Total Revenue

select * 
from pizzas;

select * from order_details;

select round(sum(quantity * price), 2) as total_price
from order_details as OD 
join pizzas as P
on OD.pizza_id = P.pizza_id;

-- 2- Avg order value

select 
round(sum(quantity * price) / count(distinct order_id), 2 )as average_order_value
from order_details as OD 
join pizzas as P
on OD.pizza_id = P.pizza_id;



-- 3- Total pizzas sold


select 
sum(quantity) as total_pizzas_sold
from order_details;


-- 4- Total Orders

select 
count(distinct(order_id))
from order_details;


-- 5- Avg pizza per order
select 
sum(quantity) / count(distinct order_id) as avg_pizza_per_order
from order_details;



-- Sales Analysis Questions

-- 1- Daily trends for total orders

select * from orders;

SELECT 
	DATE_FORMAT(date, '%W') AS DayOfWeek, 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(date, '%W')
ORDER BY total_orders DESC;


-- 2- Hourly trends for total orders

SELECT 
	time_format(time, '%H') as order_hours, 
    COUNT(DISTINCT order_id) as order_counts
FROM orders
GROUP BY time_format(time, '%H')
ORDER BY order_hours ;


-- 3- Percentage of sales by pizza  category
	--	a: calculate total revenue per category 
    --  b: % sales calculated as (a:/total_revenue) *100;

SELECT 
    category, 
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100 / (
        SELECT ROUND(SUM(quantity * price), 2)
        FROM pizzas AS p2
        JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
    ), 2) AS percentage_sales
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
GROUP BY category
ORDER BY category;

-- 4- Percentage of sales by pizza size

SELECT 
    size, 
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100 / (
        SELECT ROUND(SUM(quantity * price), 2)
        FROM pizzas AS p2
        JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
    ), 2) AS percentage_sales
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
GROUP BY size
ORDER BY size;


-- 5- Total pizzas sold by pizza category
select 
category,
sum(quantity) as quantity_sold 
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
    group by category
    order by sum(quantity) desc;
    
    
-- 6- Top 5 Best sellers by total pizza sold

select 
name, 
sum(quantity) as total_pizza_sold
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
group by name
order by total_pizza_sold desc limit 5
;

-- 7- Bottom 5 or 5 worst sellers by total pizza sold
select 
name, 
sum(quantity) as total_pizza_sold
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
group by name
order by total_pizza_sold asc limit 5
;


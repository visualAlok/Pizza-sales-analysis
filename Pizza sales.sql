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

-- Total Revenue

select * 
from pizzas;

select * from order_details;

select * 
from order_details as OD
join pizzas as P
on OD.pizza_id = P.pizza_id
order by quantity desc;

select * from pizzas 
where pizza_id = 'big_meat_s';







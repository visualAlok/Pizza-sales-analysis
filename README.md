# Pizza-sales-analysis
Pizza Sales Portfolio Project : SQL &amp; Power BI

The project encompasses raw data stored in four CSV files, depicting a year's sales data for a pizza outlet. The objective is to address key questions aimed at enhancing sales and refining business operations. The implementation is carried out on Microsoft SQL Server, with the results visualized using Power BI. The data is organized into four tables through a process involving straightforward joins and sub-queries.

## QUESTIONS TO BE ANSWERED:
### KPIs

 1) Total Revenue (How much money did we make this year?)
 2) Average Order Value
 3) Total Pizzas Sold
 4) Total Orders
 5) Average Pizzas per Order

### QUESTIONS TO ANSWER 

 1) Daily Trends for Total Orders
 2) Hourly Trend for Total Orders
 3) Percentage of Sales by Pizza Category
 4) Percentage of Sales by Pizza Size
 5) Total Pizzas Sold by Pizza Category
 6) Top 5 Best Sellers by Total Pizzas Sold
 7) Bottom 5 Worst Sellers by Total Pizzas Sold


## Data Visualization
Data visualization was done in Microsoft Power BI


![pizza-sales-report](https://github.com/visualAlok/Pizza-sales-analysis/blob/main/Report%20Screen%20shot/home.png)

![pizza-sales-report-1](https://github.com/visualAlok/Pizza-sales-analysis/blob/main/Report%20Screen%20shot/page%202.png)

## FINDINGS:
### KPIs

 1) Total Revenue for the year was $817,860
 2) Average Order Value was $38.31
 3) Total Pizzas Sold – 50,000
 4) Total Orders – 21,000
 5) Average Pizzas per Order – 2


### ANSWER TO QUESTIONS
 1) The busiest days are Thursday (3239 orders), Friday (3538 orders) and Saturday (3158 orders). Most sales are recorded on Friday
 2) Most orders are placed between 12pm to 1pm, and 5pm to 7pm
 3) Classic pizza has the highest percentage sales (26.91%), followed by Supreme (25.46%), Chicken (23.96%) and Veggie (23.68%) pizzas 
 4) Large size pizzas record the highest sales (45.89%) followed by medium (30.49%), then small (21.77%). XL and XXL only account for 1.72% and 0.12% respectively 
 5) Classic Pizza accounts for the highest sales (14,888 pizzas) followed by Supreme (11,987 pizzas), Veggie (11,649 pizzas) and Chicken (11,050 pizzas)
 6) Top 5 Best Sellers are the Classic Deluxe (2453 pizzas), Barbecue Chicken (2432 pizzas), Hawaiian (2422), Peperoni (2418 pizzas) and Thai Chicken (2371 pizzas)
 7) Bottom 5 Worst Sellers are Brie Carre (490 pizzas), Mediterranean (934 pizzas), Calabrese (937 pizzas), Spinach Supreme (950 pizzas) and Soppressata (961).



## CONCLUSION:
The outlet should capitalize on Large size Classic, Supreme, Veggie and Chicken pizzas.

Since XL and XXL pizzas account for such a small percentage of their sales (just 1.94%), they can safely get rid of these pizza sizes.

Even though the Brie Carre pizza is the worst seller, it recorded 490 pizzas sold. It would still be a good idea to keep it in the menu. 


## QUERIES USED:
You can download all the full queries from the SQL file in this repository. Below is a summary of the main queries:

### KPIs

#### 1- Total Revenue
``` SQL
select round(sum(quantity * price), 2) as total_price
from order_details as OD 
join pizzas as P
on OD.pizza_id = P.pizza_id;

```

#### 2- Average Order Value
- total order value/order count
``` SQL
select 
round(sum(quantity * price) / count(distinct order_id), 2 )as average_order_value
from order_details as OD 
join pizzas as P
on OD.pizza_id = P.pizza_id;
```

#### 3- Total pizzas sold
``` SQL
 
select 
sum(quantity) as total_pizzas_sold
from order_details;
```


#### 4- Total Orders
``` SQL

select 
count(distinct(order_id))
from order_details;

```

#### 5- Average Pizzas Per Order
- quantity sold/order IDs
``` SQL
select 
sum(quantity) / count(distinct order_id) as avg_pizza_per_order
from order_details;
```

### Sales Analysis Questions

#### 1- Daily Trends for Total Orders
``` SQL
SELECT 
	DATE_FORMAT(date, '%W') AS DayOfWeek, 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(date, '%W')
ORDER BY total_orders DESC;
```


#### 2- Hourly TrendS for Total Orders
``` SQL
SELECT 
	time_format(time, '%H') as order_hours, 
    COUNT(DISTINCT order_id) as order_counts
FROM orders
GROUP BY time_format(time, '%H')
ORDER BY order_hours ;
```


### 3- Percentage of Sales by Pizza Category
- a: calculate total revenue per category
- % sales calculated as (a:/total revenue) * 100
``` SQL
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
```



#### 4- Percentage of Sales by Pizza Size
``` SQL
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
```


#### 5- Total Pizzas Sold by Pizza Category
``` SQL
select 
category,
sum(quantity) as quantity_sold 
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
    group by category
    order by sum(quantity) desc;
```


#### 6- Top 5 Best Sellers by Total Pizzas Sold
``` SQL
select 
name, 
sum(quantity) as total_pizza_sold
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
group by name
order by total_pizza_sold desc limit 5;
```


#### 7- Bottom 5 Best Sellers by Total Pizzas Sold
``` SQL
select 
name, 
sum(quantity) as total_pizza_sold
FROM 
    pizzas AS P
    JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
    JOIN order_details AS OD ON OD.pizza_id = p.pizza_id
group by name
order by total_pizza_sold asc limit 5;
```




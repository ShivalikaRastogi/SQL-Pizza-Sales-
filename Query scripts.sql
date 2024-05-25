create database PizzaSales;
use Pizzasales;
-- Importing Tables  1) directly from csv file 
-- 					 2) manually creating table and then importing values

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- to see the tables
select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

-- BASIC QUESTIONS
-- 1) Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS 'Total Orders'
FROM
    orders;


-- 2)Calculate the total revenue generated from pizza sales.

SELECT 
    CONCAT('Rs. ',
            ROUND(SUM(od.quantity * p.price), 2)) AS 'Total Revenue'
FROM
    pizzas p
        JOIN
    order_details od ON od.pizza_id = p.pizza_id;


-- 3)Identify the highest-priced pizza.


SELECT 
    pt.name, MAX(p.price) AS highest_price
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
HAVING MAX(p.price) = (SELECT 
        MAX(price)
    FROM
        pizzas);


-- 4) Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) AS 'no_of_orders'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY no_of_orders DESC
LIMIT 1;

-- 5) List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS 'Total'
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY total DESC
LIMIT 5;


-- INTERMEDIATE QUESTIONS
-- 6)Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS 'total_quantity'
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;


-- 7)Determine the distribution of orders by hour of the day.


SELECT 
    HOUR(order_time) AS 'Hour', COUNT(order_id) AS 'Orders'
FROM
    orders
GROUP BY Hour
ORDER BY Hour ASC;


-- 8)Find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- 9)Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(SUM_QTY), 0) AS 'Average Quantity'
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS 'SUM_QTY'
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date
    ORDER BY o.order_date ASC) AS Quantity_ordered;

-- 10)Determine the top 3 most ordered pizza types based on revenue.


SELECT 
    pt.name, SUM(p.price * od.quantity) AS 'Revenue'
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;


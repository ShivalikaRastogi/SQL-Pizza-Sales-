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


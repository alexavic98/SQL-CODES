CREATE SCHEMA pizza_runner;
USE pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INT,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INT,
  customer_id INT,
  pizza_id INT,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  (1, 101, 1, '', '', '2020-01-01 18:05:02'),
  (2, 101, 1, '', '', '2020-01-01 19:00:52'),
  (3, 102, 1, '', '', '2020-01-02 23:51:23'),
  (3, 102, 2, '', NULL, '2020-01-02 23:51:23'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 1, '4', '', '2020-01-04 13:23:46'),
  (4, 103, 2, '4', '', '2020-01-04 13:23:46'),
  (5, 104, 1, NULL, '1', '2020-01-08 21:00:29'),
  (6, 101, 2, NULL, NULL, '2020-01-08 21:03:13'),
  (7, 105, 2, NULL, '1', '2020-01-08 21:20:29'),
  (8, 102, 1, NULL, NULL, '2020-01-09 23:54:33'),
  (9, 103, 1, '4', '1, 5', '2020-01-10 11:22:59'),
  (10, 104, 1, NULL, NULL, '2020-01-11 18:34:49'),
  (10, 104, 1, '2, 6', '1, 4', '2020-01-11 18:34:49');

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INT,
  runner_id INT,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  (1, 1, '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  (2, 1, '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  (3, 1, '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  (4, 2, '2020-01-04 13:53:03', '23.4', '40', NULL),
  (5, 3, '2020-01-08 21:10:57', '10', '15', NULL),
  (6, 3, NULL, NULL, NULL, 'Restaurant Cancellation'),
  (7, 2, '2020-01-08 21:30:45', '25km', '25mins', NULL),
  (8, 2, '2020-01-10 00:15:02', '23.4 km', '15 minute', 'Customer Cancellation'),
  (9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
  (10, 1, '2020-01-11 18:50:20', '10km', '10minutes', 'Customer Cancellation');

DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INT,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INT,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INT,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
/* DATA CLEANING */

/* changing empty strings to NULL data type in the exclusions and extras columns*/
UPDATE customer_orders 
SET exclusions = NULL
WHERE exclusions = "";

UPDATE customer_orders 
SET extras = NULL
WHERE extras = "";

/*SECTION A Pizza Metrics */
  
/* 1. How many pizzas were ordered?*/
SELECT count(order_id) AS no_of_order
FROM customer_orders;

/*2. How many unique customer orders were made?*/
SELECT COUNT(DISTINCT order_id)
FROM customer_orders;

/*3. How many successful orders were delivered by each runner?*/
SELECT runner_id, count(order_id) AS successful
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

/*4. How many of each type of pizza was delivered?*/
SELECT pizza_name, pizza_names.pizza_id, count(runner_orders.order_id) AS delivered
FROM pizza_names JOIN customer_orders ON pizza_names.pizza_id = customer_orders.pizza_id 
JOIN runner_orders ON runner_orders.order_id = customer_orders.order_id
WHERE cancellation IS NULL
GROUP BY pizza_name, pizza_id;

/*5. How many Vegetarian and Meatlovers were ordered by each customer*/
SELECT customer_id, 
SUM(CASE WHEN pizza_name = "Vegetarian" THEN 1 ELSE 0 END) AS vegetarians,
SUM(CASE WHEN pizza_name ="Meatlovers" THEN 1 ELSE 0 END) AS Meatlovers
FROM customer_orders JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY pizza_name, customer_id;

/*6. What was the maximum number of pizzas delivered in a single order?*/
SELECT MAX(order_pizza_count) AS max_pizza_delivered
FROM (SELECT order_id, COUNT(pizza_id) AS order_pizza_count
FROM customer_orders
GROUP BY order_id) AS pizza_count;

/*7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes? */
SELECT c.customer_id, 
  COUNT(CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL 
  	THEN 1 END) AS changed_orders,
  COUNT(CASE WHEN c.exclusions IS NULL AND c.extras IS NULL
  	THEN 1 END) AS unchanged_orders
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
  ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id
ORDER BY c.customer_id;

/*8. How many pizzas were delivered that had both exclusions and extras?*/
SELECT COUNT(customer_orders.order_id) AS deliveries
FROM customer_orders JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE exclusions IS NOT NULL AND extras IS NOT NULL AND cancellation IS NULL;

/*9*/
/*10 */



/* SECTION B  Runner and Customer Experience */

/*1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)*/

/* SECTION C Ingredient Optimisation */

/*1 What are the standard ingredients for each pizza? */








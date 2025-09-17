
Select customer_state, Count(customer_id) as total_customers
from customers 
Group By 1
Order by 2 desc
limit 10;

SELECT c.customer_unique_id, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC;


WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN total_orders = 0 THEN 'Inactive'
        ELSE 'Active'
    END AS customer_status,
    COUNT(*) AS num_customers
FROM customer_orders
GROUP BY customer_status;

WITH customer_orders AS (
    SELECT c.customer_unique_id,
           COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN total_orders = 1 THEN 'One-time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(*) AS num_customers
FROM customer_orders
GROUP BY customer_type;

SELECT c.customer_unique_id, SUM(payment_value) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
Join payments as p On o.order_id=p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC
limit 50;

SELECT c.customer_unique_id, AVG(p.payment_value) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY avg_order_value DESC;

SELECT c.customer_id, 
       ROUND(AVG(TIMESTAMPDIFF(HOUR, o.order_purchase_timestamp, o.order_delivered_customer_date)) / 24) AS avg_delivery_days
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_id
ORDER BY avg_delivery_days desc;

SELECT c.customer_id,
       SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS delayed_orders,
       SUM(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS on_time_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_id
ORDER BY delayed_orders;

WITH last_order AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    customer_unique_id,
    last_purchase,
    CASE 
        WHEN last_purchase < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 'Churned'
        ELSE 'Active'
    END AS customer_status
FROM last_order;

SELECT 
    c.customer_unique_id,
    SUM(p.payment_value) AS lifetime_value,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value,
    MIN(o.order_purchase_timestamp) AS first_purchase,
    MAX(o.order_purchase_timestamp) AS last_purchase
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN payments p 
    ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC
LIMIT 50;












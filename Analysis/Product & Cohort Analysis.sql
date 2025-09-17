
SELECT 
    pr.product_category_name, 
    SUM(p.payment_value) AS total_revenue
FROM payments p
JOIN orders o 
    ON p.order_id = o.order_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products pr 
    ON oi.product_id = pr.product_id
GROUP BY pr.product_category_name
ORDER BY total_revenue DESC;

SELECT 
    pr.product_category_name,
    COUNT(oi.order_item_id) AS total_sold
FROM order_items oi
JOIN products pr 
    ON oi.product_id = pr.product_id
GROUP BY pr.product_category_name
ORDER BY total_sold DESC
LIMIT 10;

SELECT 
    pr.product_category_name,
    COUNT(oi.order_item_id) AS total_sold
FROM order_items oi
JOIN products pr 
    ON oi.product_id = pr.product_id
GROUP BY pr.product_category_name
ORDER BY total_sold ASC
LIMIT 10;

WITH first_orders AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    DATE_FORMAT(first_purchase, '%Y-%m') AS acquisition_month,
    COUNT(DISTINCT customer_unique_id) AS new_customers
FROM first_orders
GROUP BY DATE_FORMAT(first_purchase, '%Y-%m')
ORDER BY acquisition_month;

WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m') AS cohort_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
customer_orders AS (
    SELECT 
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
)
SELECT 
    f.cohort_month,
    co.order_month,
    COUNT(DISTINCT co.customer_unique_id) AS active_customers
FROM first_purchase f
JOIN customer_orders co
    ON f.customer_unique_id = co.customer_unique_id
GROUP BY f.cohort_month, co.order_month
ORDER BY f.cohort_month, co.order_month;





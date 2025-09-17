
Select * from customers;
Select * from orders;
Select * from order_items;
Select * from payments;
Select * from products;

 -- Revenue and Sales Analysis --

Select SUM(payment_value) as total_revenue from payments;

Select payment_type,sum(payment_value) as revenue from payments
group by 1
order by 2 desc;

Select payment_installments ,sum(payment_value) as revenue from payments
group by 1
order by 2 desc;

SELECT Month(order_purchase_timestamp) AS order_month, 
       SUM(p.payment_value) AS monthly_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY Month(order_purchase_timestamp)
ORDER BY order_month, monthly_revenue;

SELECT customer_id, SUM(p.payment_value) AS customer_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;

SELECT oi.seller_id, SUM(p.payment_value) AS seller_revenue
FROM order_items oi
JOIN payments p ON oi.order_id = p.order_id
GROUP BY oi.seller_id
ORDER BY seller_revenue DESC
LIMIT 10;

SELECT oi.product_id, SUM(p.payment_value) AS product_revenue
FROM order_items oi
JOIN payments p ON oi.order_id = p.order_id
GROUP BY oi.product_id
ORDER BY product_revenue DESC
LIMIT 10;

Select Round(SUM(p.payment_value) / Count(distinct o.order_id), 2) as AOV 
from payments as p Join orders as o 
On p.order_id=o.order_id;

SELECT YEAR(o.order_purchase_timestamp) AS order_year,
       MONTH(o.order_purchase_timestamp) AS order_month,
       SUM(p.payment_value) AS monthly_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY order_year, order_month;

Select Month(o.order_purchase_timestamp) as `Month`, SUM(payment_value) Sales ,
SUM(SUM(payment_value)) Over(order by Month(o.order_purchase_timestamp)) Running_Sales
from orders as o join payments as p 
on o.order_id=p.order_id
group by 1;

Select pr.product_category_name,
SUM(payment_value) as category_revenue,
Round(SUM(payment_value) * 100/ (Select SUM(payment_value) from payments),2) as revenue_by_category
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN payments p ON oi.order_id = p.order_id
GROUP BY pr.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;


WITH monthly AS (
    SELECT YEAR(o.order_purchase_timestamp) AS order_year,
           MONTH(o.order_purchase_timestamp) AS order_month,
           SUM(p.payment_value) AS monthly_revenue
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
)
SELECT order_year, order_month, monthly_revenue,
       LAG(monthly_revenue) OVER (ORDER BY order_year, order_month) AS prev_month,
       ROUND((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_year, order_month)) 
             * 100.0 / NULLIF(LAG(monthly_revenue) OVER (ORDER BY order_year, order_month),0), 2) AS mom_growth_pct
FROM monthly
order by 1,2;

SELECT ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.customer_id), 2) AS avg_revenue_per_customer
FROM orders o
JOIN payments p ON o.order_id = p.order_id;





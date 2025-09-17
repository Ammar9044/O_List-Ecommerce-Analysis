Create Database o_list;
Use o_list;

Select customer_id, customer_unique_id, Count(*) from customers 
group by 1,2
having Count(*) > 1;

Alter Table customers 
modify Column customer_id varchar(50),
modify Column customer_unique_id varchar(50),
modify Column customer_zip_code_prefix int,
modify Column customer_city varchar(40),
modify Column customer_state varchar(25);

UPDATE orders
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date = '';

SELECT order_id, order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date = '';

UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

SELECT order_id, order_approved_at
FROM orders
WHERE order_approved_at = '';

UPDATE orders
SET order_approved_at = NULL
WHERE order_approved_at = '';

ALTER TABLE orders 
MODIFY order_id VARCHAR(50) PRIMARY KEY,
MODIFY customer_id VARCHAR(50) NOT NULL,
MODIFY order_status VARCHAR(20),
MODIFY order_purchase_timestamp DATETIME,
MODIFY order_approved_at DATETIME,
MODIFY order_delivered_carrier_date DATETIME,
MODIFY order_delivered_customer_date DATETIME,
MODIFY order_estimated_delivery_date DATETIME;

Alter table products 
Modify product_id varchar(50) primary key;

Select order_item_id, Count(*) 
from order_items 
group by 1 
having Count(*) > 1;

ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE payments
ADD CONSTRAINT fk_payment_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

Select order_item_id, Count(*) 
from order_items 
group by 1 
having Count(*) > 1;

ALTER TABLE customers 
ADD PRIMARY KEY (customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_customer_orders
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

SELECT oi.product_id
FROM order_items oi
WHERE NOT EXISTS (
    SELECT 1 
    FROM products p
    WHERE oi.product_id = p.product_id
);

DELETE FROM order_items
WHERE product_id NOT IN (SELECT product_id FROM products);


ALTER TABLE order_items
ADD CONSTRAINT fk_product_orders
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE orders
  ADD INDEX idx_customer_id (customer_id),
  ADD INDEX idx_order_status (order_status),
  ADD INDEX idx_purchase_date (order_purchase_timestamp);

ALTER TABLE order_items
  ADD INDEX idx_product_id (product_id),
  ADD INDEX idx_seller_id (seller_id);

ALTER TABLE customers
  ADD INDEX idx_customer_unique (customer_unique_id);

ALTER TABLE products
  ADD INDEX idx_category (product_category_name);
  
  ALTER TABLE payments
  ADD INDEX idx_order_id (order_id),
  ADD INDEX idx_payment_type (payment_type);
  
  ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_sellers
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);































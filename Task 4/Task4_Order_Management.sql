-- TASK 4: ORDER MANAGEMENT SYSTEM
-- MySQL 8.0+

DROP DATABASE IF EXISTS task4_order_db;
CREATE DATABASE task4_order_db;
USE task4_order_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(80)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK(stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(total_amount >= 0),
    order_status ENUM('Pending','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_order_customer FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    CONSTRAINT fk_detail_order FOREIGN KEY(order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_product FOREIGN KEY(product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO customers(customer_name,email,phone,city) VALUES
('Arun Kumar','arun.order@example.com','9876500001','Chennai'),
('Priya S','priya.order@example.com','9876500002','Pondicherry'),
('Rahul M','rahul.order@example.com','9876500003','Bengaluru'),
('Divya R','divya.order@example.com','9876500004','Coimbatore');

INSERT INTO products(product_name,category,price,stock_quantity) VALUES
('Laptop','Electronics',55000.00,20),
('Wireless Mouse','Electronics',750.00,50),
('Keyboard','Electronics',1200.00,30),
('Smartphone','Electronics',25000.00,15),
('Headphones','Electronics',3000.00,25);

INSERT INTO orders(customer_id,total_amount,order_status) VALUES
(1,0,'Pending'),
(2,0,'Shipped'),
(3,0,'Delivered'),
(4,0,'Pending');

INSERT INTO order_details(order_id,product_id,quantity,price) VALUES
(1,1,1,55000.00),
(1,2,1,750.00),
(2,3,2,1200.00),
(3,4,1,25000.00),
(4,5,1,3000.00);

-- Calculate totals from order details to avoid inconsistent manual totals
UPDATE orders o
SET total_amount = (
    SELECT COALESCE(SUM(od.quantity * od.price),0)
    FROM order_details od
    WHERE od.order_id = o.order_id
);

-- Complete order report
SELECT o.order_id,c.customer_name,o.order_date,o.total_amount,o.order_status
FROM orders o JOIN customers c ON c.customer_id=o.customer_id
ORDER BY o.order_id;

-- Customer order history
SELECT c.customer_name,o.order_id,o.order_date,o.total_amount,o.order_status
FROM customers c JOIN orders o ON o.customer_id=c.customer_id
ORDER BY c.customer_name,o.order_date DESC;

-- Customer-wise summary
SELECT c.customer_name,
       COUNT(o.order_id) AS order_count,
       ROUND(COALESCE(SUM(o.total_amount),0),2) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_spent DESC;

-- Product popularity
SELECT p.product_name,
       SUM(od.quantity) AS quantity_ordered,
       COUNT(DISTINCT od.order_id) AS order_count
FROM products p
JOIN order_details od ON od.product_id=p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY quantity_ordered DESC;

-- Update order status
UPDATE orders
SET order_status='Shipped'
WHERE order_id=1;

-- Order status distribution
SELECT order_status,COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_status;

-- Final report
SELECT o.order_id,c.customer_name,o.total_amount,o.order_status
FROM orders o JOIN customers c ON c.customer_id=o.customer_id
ORDER BY o.order_id;

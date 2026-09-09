-- TASK 2: PRODUCT AND CATEGORY DATABASE
-- MySQL 8.0+

DROP DATABASE IF EXISTS task2_product_db;
CREATE DATABASE task2_product_db;
USE task2_product_db;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO categories (category_name,description) VALUES
('Electronics','Electronic devices and accessories'),
('Fashion','Clothing and fashion products'),
('Home','Home and kitchen products'),
('Books','Printed and educational books');

INSERT INTO products (product_name,category_id,price,stock_quantity) VALUES
('Laptop',1,55000.00,20),
('Wireless Mouse',1,750.00,60),
('Smartphone',1,25000.00,15),
('T-Shirt',2,799.00,40),
('Jeans',2,1499.00,18),
('Mixer Grinder',3,3200.00,12),
('SQL Fundamentals',4,650.00,30),
('DBMS Handbook',4,900.00,8);

-- Complete catalogue
SELECT p.product_id,p.product_name,c.category_name,p.price,p.stock_quantity
FROM products p
JOIN categories c ON c.category_id = p.category_id
ORDER BY p.product_id;

-- Update a product
UPDATE products
SET price = 700.00, stock_quantity = stock_quantity + 10
WHERE product_id = 2;

-- Increase electronics prices by 5%
UPDATE products
SET price = ROUND(price * 1.05, 2)
WHERE category_id = 1;

-- Category summary
SELECT c.category_name,
       COUNT(p.product_id) AS product_count,
       ROUND(AVG(p.price),2) AS average_price,
       COALESCE(SUM(p.stock_quantity),0) AS total_stock,
       ROUND(COALESCE(SUM(p.price * p.stock_quantity),0),2) AS inventory_value
FROM categories c
LEFT JOIN products p ON p.category_id = c.category_id
GROUP BY c.category_id,c.category_name
ORDER BY c.category_id;

-- Low-stock alert
SELECT product_id,product_name,stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity;

-- Delete a product safely
DELETE FROM products WHERE product_id = 8;

-- TASK 3: SELLER AND INVENTORY MANAGEMENT
-- MySQL 8.0+

DROP DATABASE IF EXISTS task3_inventory_db;
CREATE DATABASE task3_inventory_db;
USE task3_inventory_db;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_t3_product_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE sellers (
    seller_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(80)
);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    seller_id INT NOT NULL,
    sku VARCHAR(60) NOT NULL UNIQUE,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level INT NOT NULL DEFAULT 10 CHECK (reorder_level >= 0),
    last_restocked DATE,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_inventory_seller
        FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO categories(category_name) VALUES
('Electronics'),('Fashion'),('Home'),('Books'),('Sports');

INSERT INTO products(product_name,category_id) VALUES
('Laptop',1),('Smartphone',1),('Headphones',1),('T-Shirt',2),('Jeans',2),
('Mixer Grinder',3),('Chair',3),('DBMS Book',4),('SQL Book',4),('Football',5);

INSERT INTO sellers(store_name,email,phone,city) VALUES
('Tech World','tech@example.com','9000000001','Chennai'),
('Style Hub','style@example.com','9000000002','Bengaluru'),
('Home Store','home@example.com','9000000003','Coimbatore'),
('Book Point','book@example.com','9000000004','Madurai'),
('Sports Arena','sports@example.com','9000000005','Chennai');

INSERT INTO inventory(product_id,seller_id,sku,unit_price,stock_quantity,reorder_level,last_restocked) VALUES
(1,1,'LAP-001',55000,12,5,'2026-08-01'),
(2,1,'PHN-001',25000,25,10,'2026-08-03'),
(3,1,'AUD-001',3000,7,10,'2026-08-02'),
(4,2,'TSH-001',799,40,10,'2026-08-04'),
(5,2,'JNS-001',1499,18,10,'2026-08-05'),
(6,3,'MIX-001',3200,4,8,'2026-08-01'),
(7,3,'CHR-001',4500,0,5,'2026-08-02'),
(8,4,'DBM-001',650,30,10,'2026-08-06'),
(9,4,'SQL-001',700,14,10,'2026-08-06'),
(10,5,'FBL-001',1200,22,8,'2026-08-07');

-- Detailed inventory report
SELECT i.inventory_id,p.product_name,s.store_name,c.category_name,
       i.sku,i.unit_price,i.stock_quantity,i.reorder_level,
       CASE
           WHEN i.stock_quantity = 0 THEN 'UNAVAILABLE'
           WHEN i.stock_quantity <= i.reorder_level THEN 'LOW STOCK'
           ELSE 'AVAILABLE'
       END AS inventory_status
FROM inventory i
JOIN products p ON p.product_id=i.product_id
JOIN sellers s ON s.seller_id=i.seller_id
JOIN categories c ON c.category_id=p.category_id
ORDER BY i.inventory_id;

-- Low-stock products
SELECT p.product_name,s.store_name,i.stock_quantity,i.reorder_level
FROM inventory i
JOIN products p ON p.product_id=i.product_id
JOIN sellers s ON s.seller_id=i.seller_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity;

-- Inventory value
SELECT ROUND(SUM(unit_price * stock_quantity),2) AS total_inventory_value
FROM inventory;

-- Seller-wise report
SELECT s.store_name,
       COUNT(i.inventory_id) AS products_listed,
       COALESCE(SUM(i.stock_quantity),0) AS total_stock,
       ROUND(COALESCE(SUM(i.unit_price*i.stock_quantity),0),2) AS inventory_value
FROM sellers s
LEFT JOIN inventory i ON i.seller_id=s.seller_id
GROUP BY s.seller_id,s.store_name
ORDER BY inventory_value DESC;

-- Restock product 3
UPDATE inventory
SET stock_quantity = stock_quantity + 10,
    last_restocked = CURRENT_DATE
WHERE product_id = 3;

-- Reduce product 1 stock after a sale
UPDATE inventory
SET stock_quantity = stock_quantity - 2
WHERE product_id = 1 AND stock_quantity >= 2;

-- Final status report
SELECT p.product_name,i.stock_quantity,
       CASE
           WHEN i.stock_quantity=0 THEN 'UNAVAILABLE'
           WHEN i.stock_quantity<=i.reorder_level THEN 'LOW STOCK'
           ELSE 'AVAILABLE'
       END AS status
FROM inventory i JOIN products p ON p.product_id=i.product_id
ORDER BY p.product_id;

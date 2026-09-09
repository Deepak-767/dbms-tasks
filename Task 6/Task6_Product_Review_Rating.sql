-- TASK 6: PRODUCT REVIEW AND RATING MANAGEMENT
-- MySQL 8.0+

DROP DATABASE IF EXISTS task6_review_db;
CREATE DATABASE task6_review_db;
USE task6_review_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK(price > 0)
);

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK(rating BETWEEN 1 AND 5),
    review_text VARCHAR(500),
    review_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_customer_product_review UNIQUE(customer_id,product_id),
    CONSTRAINT fk_review_customer FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_review_product FOREIGN KEY(product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO customers(customer_name,email) VALUES
('Arun Kumar','arun.review@example.com'),
('Priya S','priya.review@example.com'),
('Rahul M','rahul.review@example.com'),
('Divya R','divya.review@example.com');

INSERT INTO products(product_name,price) VALUES
('Laptop',55000.00),
('Wireless Mouse',750.00),
('Smartphone',25000.00),
('Headphones',3000.00),
('DBMS Book',650.00);

INSERT INTO reviews(customer_id,product_id,rating,review_text) VALUES
(1,1,5,'Excellent performance and build quality.'),
(2,1,4,'Very good laptop for study and work.'),
(3,2,5,'Comfortable and responsive.'),
(4,3,3,'Good phone but battery can improve.'),
(1,4,2,'Sound quality needs improvement.'),
(2,5,5,'Very useful for DBMS preparation.');

-- All reviews
SELECT r.review_id,c.customer_name,p.product_name,r.rating,r.review_text,r.review_date
FROM reviews r
JOIN customers c ON c.customer_id=r.customer_id
JOIN products p ON p.product_id=r.product_id
ORDER BY r.review_date DESC;

-- Product rating summary
SELECT p.product_id,p.product_name,
       COUNT(r.review_id) AS review_count,
       ROUND(AVG(r.rating),2) AS average_rating
FROM products p
LEFT JOIN reviews r ON r.product_id=p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY average_rating DESC;

-- Highly rated products
SELECT p.product_name,ROUND(AVG(r.rating),2) AS average_rating
FROM products p JOIN reviews r ON r.product_id=p.product_id
GROUP BY p.product_id,p.product_name
HAVING AVG(r.rating) >= 4
ORDER BY average_rating DESC;

-- Low-rated products
SELECT p.product_name,ROUND(AVG(r.rating),2) AS average_rating
FROM products p JOIN reviews r ON r.product_id=p.product_id
GROUP BY p.product_id,p.product_name
HAVING AVG(r.rating) < 3
ORDER BY average_rating;

-- Rating distribution
SELECT rating,COUNT(*) AS review_count
FROM reviews
GROUP BY rating
ORDER BY rating;

-- Update a review
UPDATE reviews
SET rating=4,
    review_text='Updated after extended usage.'
WHERE review_id=5;

-- Final rating report
SELECT p.product_name,COUNT(r.review_id) AS reviews,ROUND(AVG(r.rating),2) AS average_rating
FROM products p LEFT JOIN reviews r ON r.product_id=p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY average_rating DESC;

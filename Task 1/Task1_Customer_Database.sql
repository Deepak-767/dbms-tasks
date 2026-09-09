-- TASK 1: CUSTOMER DATABASE
-- MySQL 8.0+

DROP DATABASE IF EXISTS task1_customer_db;
CREATE DATABASE task1_customer_db;
USE task1_customer_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    city VARCHAR(80),
    status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (customer_name,email,phone,city,status) VALUES
('Arun Kumar','arun@example.com','9876543210','Chennai','Active'),
('Priya S','priya@example.com','9876543211','Pondicherry','Active'),
('Rahul M','rahul@example.com','9876543212','Bengaluru','Inactive'),
('Divya R','divya@example.com','9876543213','Coimbatore','Active');

-- Display all customers
SELECT * FROM customers ORDER BY customer_id;

-- Active customers by city
SELECT city, COUNT(*) AS active_customers
FROM customers
WHERE status = 'Active'
GROUP BY city
ORDER BY active_customers DESC;

-- Search customers by city
SELECT * FROM customers WHERE city = 'Chennai';

-- Update customer status
UPDATE customers
SET status = 'Active'
WHERE customer_id = 3;

-- Delete a customer
DELETE FROM customers
WHERE customer_id = 4;

-- Final report
SELECT customer_id, customer_name, email, city, status, created_at
FROM customers
ORDER BY customer_id;

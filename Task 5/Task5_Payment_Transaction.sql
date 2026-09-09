-- TASK 5: PAYMENT TRANSACTION MANAGEMENT
-- MySQL 8.0+

DROP DATABASE IF EXISTS task5_payment_db;
CREATE DATABASE task5_payment_db;
USE task5_payment_db;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL CHECK(order_amount > 0)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_mode ENUM('UPI','Credit Card','Debit Card','Net Banking','Cash on Delivery') NOT NULL,
    payment_status ENUM('Pending','Successful','Failed') NOT NULL DEFAULT 'Pending',
    transaction_amount DECIMAL(10,2) NOT NULL CHECK(transaction_amount > 0),
    CONSTRAINT fk_payment_order FOREIGN KEY(order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO orders(order_id,customer_name,order_amount) VALUES
(1,'Arun Kumar',450.00),
(2,'Priya S',4056.00),
(3,'Rahul M',5760.00),
(4,'Divya R',950.00);

INSERT INTO payments(order_id,payment_mode,payment_status,transaction_amount) VALUES
(1,'UPI','Pending',450.00),
(2,'Credit Card','Successful',4056.00),
(3,'Debit Card','Failed',5760.00),
(4,'UPI','Successful',950.00);

-- Display all transactions
SELECT * FROM payments ORDER BY payment_id;

-- Successful transactions
SELECT * FROM payments WHERE payment_status='Successful';

-- Failed transactions
SELECT * FROM payments WHERE payment_status='Failed';

-- Pending transactions
SELECT * FROM payments WHERE payment_status='Pending';

-- Count by payment mode
SELECT payment_mode,COUNT(*) AS number_of_transactions
FROM payments
GROUP BY payment_mode
ORDER BY payment_mode;

-- Count by payment status
SELECT payment_status,COUNT(*) AS number_of_transactions
FROM payments
GROUP BY payment_status
ORDER BY payment_status;

-- Payment totals by status
SELECT payment_status,
       COUNT(*) AS transaction_count,
       ROUND(SUM(transaction_amount),2) AS total_amount
FROM payments
GROUP BY payment_status;

-- Retry the failed payment (Payment_ID = 3 exists)
UPDATE payments
SET payment_status='Successful'
WHERE payment_id=3 AND payment_status='Failed';

-- Verify retry result
SELECT * FROM payments WHERE payment_id=3;

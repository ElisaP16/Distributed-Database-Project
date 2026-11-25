-- MCO2 setup: 3 databases standing in for 3 nodes 
-- Node 1 = transactions_sakila  (all payments)
-- Node 2 = transactions_sakila2 (payments for @node2_staff)
-- Node 3 = transactions_sakila3 (payments for @node3_staff)

-- ==================== SPLIT RULE ====================
-- Which staff_id goes to which node. To swap, change ONLY these two lines.
SET @node2_staff = 1;
SET @node3_staff = 2;

CREATE DATABASE IF NOT EXISTS transactions_sakila;
CREATE DATABASE IF NOT EXISTS transactions_sakila2;
CREATE DATABASE IF NOT EXISTS transactions_sakila3;

-- ==================== NODE 1 ====================
USE transactions_sakila;

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    customer_id  INT           NOT NULL,
    amount       DECIMAL(5,2)  NOT NULL,
    payment_date DATETIME      NOT NULL,
    staff_id     INT           NOT NULL,
    PRIMARY KEY (payment_id),
    KEY idx_customer (customer_id)
) ENGINE = InnoDB;

INSERT INTO transactions_sakila.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment;


-- ==================== NODE 2 ====================
USE transactions_sakila2;

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    customer_id  INT           NOT NULL,
    amount       DECIMAL(5,2)  NOT NULL,
    payment_date DATETIME      NOT NULL,
    staff_id     INT           NOT NULL,
    PRIMARY KEY (payment_id),
    KEY idx_customer (customer_id)
) ENGINE = InnoDB;

INSERT INTO transactions_sakila2.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment
WHERE staff_id = @node2_staff;


-- ==================== NODE 3 ====================
USE transactions_sakila3;

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    customer_id  INT           NOT NULL,
    amount       DECIMAL(5,2)  NOT NULL,
    payment_date DATETIME      NOT NULL,
    staff_id     INT           NOT NULL,
    PRIMARY KEY (payment_id),
    KEY idx_customer (customer_id)
) ENGINE = InnoDB;

INSERT INTO transactions_sakila3.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment
WHERE staff_id = @node3_staff;

-- Check that the counts are correct. 
-- Node 2 count + Node 3 count should equal Node 1 count.
SELECT
    (SELECT COUNT(*) FROM transactions_sakila.payments)  AS node1_count,
    (SELECT COUNT(*) FROM transactions_sakila2.payments) AS node2_count,
    (SELECT COUNT(*) FROM transactions_sakila3.payments) AS node3_count,
    (SELECT COUNT(*) FROM transactions_sakila2.payments) +
    (SELECT COUNT(*) FROM transactions_sakila3.payments) AS node2_plus_node3;

-- ==================== TO ADD LATER ====================
-- replication_log table (design pending, owner: Member 3)
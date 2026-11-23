CREATE DATABASE IF NOT EXISTS transactions_sakila;
CREATE DATABASE IF NOT EXISTS transactions_sakila2;
CREATE DATABASE IF NOT EXISTS transactions_sakila3;

CREATE TABLE payments (
    payment_id   INT           NOT NULL AUTO_INCREMENT,
    customer_id  INT           NOT NULL,
    amount       DECIMAL(5,2)  NOT NULL,
    payment_date DATETIME      NOT NULL,
    staff_id 	 INT 		   NOT NULL,
    PRIMARY KEY (payment_id),
    KEY idx_customer (customer_id)
) ENGINE = InnoDB;


INSERT INTO transactions_sakila.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment;

INSERT INTO transactions_sakila2.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment
WHERE staff_id = 1;

INSERT INTO transactions_sakila3.payments (payment_id, customer_id, amount, payment_date, staff_id)
SELECT payment_id, customer_id, amount, payment_date, staff_id
FROM sakila.payment 
WHERE staff_id = 2;



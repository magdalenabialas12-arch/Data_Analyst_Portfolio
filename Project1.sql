-- tworzymy tabele/creating tables
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  country VARCHAR(50)
);

CREATE TABLE orders (
  order_id    SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(customer_id),
  order_date  DATE,
  amount      NUMERIC(10,2),
  product     VARCHAR(100),
  status      VARCHAR(20)
);

-- przykładowe dane: customers/sample data: customers
INSERT INTO customers (first_name, last_name, email, country) VALUES
('Anna','Nowak','anna.nowak@example.com','Poland'),
('Piotr','Kowalski','piotr.kowalski@example.com','Poland'),
('Eva','Smith','eva.smith@example.com','UK'),
('John','Doe','john.doe@example.com','USA'),
('Maria','Garcia','maria.garcia@example.com','Spain'),
('Lukas','Novak','lukas.novak@example.com','Czechia'),
('Zofia','Wozniak','zofia.wozniak@example.com','Poland'),
('Ola','Lewandowska','ola.lewandowska@example.com','Poland');

-- przykładowe dane: orders/sample data: orders
INSERT INTO orders (customer_id, order_date, amount, product, status) VALUES
(1, '2025-06-01', 120.50, 'Widget A', 'completed'),
(1, '2025-07-12', 59.99, 'Widget B', 'completed'),
(2, '2025-06-15', 250.00, 'Widget C', 'completed'),
(3, '2025-07-01', 15.00, 'Accessory X', 'cancelled'),
(4, '2025-08-20', 550.00, 'Gadget Pro', 'completed'),
(5, '2025-05-30', 75.00, 'Widget B', 'completed'),
(6, '2025-08-01', 300.00, 'Service Fee', 'completed'),
(2, '2025-08-05', 40.00, 'Accessory Y', 'completed'),
(7, '2025-09-01', 20.00, 'Accessory X', 'completed'),
(8, '2025-09-10', 99.99, 'Widget A', 'completed'),
(8, '2025-09-12', 10.00, 'Shipping', 'completed');

-- wybierz wszystkie customers/select everything from customers table
SELECT * FROM customers;

-- wybierz wszystkie orders, posortowane malejąco po dacie/select all orders, sorted in descending order by date
SELECT * FROM orders ORDER BY order_date DESC;

-- zamówienia powyżej 100/orders above 100
SELECT * FROM orders WHERE amount > 100;

-- połączenie zamówień z danymi klienta/combining orders with customer data
SELECT o.order_id, o.order_date, o.amount, o.product, c.first_name, c.last_name, c.email
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
ORDER BY o.order_date DESC;

-- wszyscy klienci i ich zamówienia/all customers and their orders
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

--suma wydatków na klienta/total expenditure per customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spend,
COUNT (o.order_id) AS orders_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spend DESC;

--klienci z wydatkami powyżej 200/customers with expenses above 200
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spend,
COUNT (o.order_id) AS orders_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.amount)>200;

--szeregowanie klientów po wydatkach/ranking customers by spending
SELECT customer_id, total_spend,
RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM (
SELECT c.customer_id, SUM(o.amount) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id);

--CTE z WITH/CTE with WITH
WITH customer_totals AS (
  SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spent
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * FROM customer_totals WHERE total_spent > 150;


-- Sample Data for Session 1 Final Challenge
-- Sales Insights Report
-- MySQL Version

USE sql_course;

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    registration_date DATE
);

-- Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Customers
INSERT INTO customers VALUES
(1, 'Alice Johnson', 'North', '2023-01-15'),
(2, 'Bob Smith', 'South', '2023-02-20'),
(3, 'Charlie Brown', 'East', '2023-01-10'),
(4, 'Diana Prince', 'West', '2023-03-05'),
(5, 'Eve Wilson', 'North', '2023-02-01'),
(6, 'Frank Miller', 'South', '2023-04-12'),
(7, 'Grace Lee', 'East', '2023-01-25'),
(8, 'Henry Davis', 'West', '2023-03-18'),
(9, 'Iris Chen', 'North', '2023-02-14'),
(10, 'Jack Taylor', 'South', '2023-05-01');

-- Insert Products
INSERT INTO products VALUES
(1, 'Laptop Pro', 'Electronics', 1200.00),
(2, 'Wireless Mouse', 'Electronics', 25.00),
(3, 'Keyboard', 'Electronics', 75.00),
(4, 'Monitor 27"', 'Electronics', 350.00),
(5, 'T-Shirt Classic', 'Clothing', 20.00),
(6, 'Jeans Denim', 'Clothing', 60.00),
(7, 'Winter Jacket', 'Clothing', 150.00),
(8, 'Running Shoes', 'Clothing', 90.00),
(9, 'Baseball Cap', 'Clothing', 15.00),
(10, 'Smartphone', 'Electronics', 800.00);

-- Insert Orders (spread across 6 months)
INSERT INTO orders VALUES
(1, 1, '2024-01-05', 1225.00),
(2, 2, '2024-01-10', 80.00),
(3, 3, '2024-01-15', 350.00),
(4, 1, '2024-01-20', 25.00),
(5, 4, '2024-01-25', 240.00),
(6, 5, '2024-02-01', 1200.00),
(7, 2, '2024-02-05', 150.00),
(8, 6, '2024-02-10', 90.00),
(9, 1, '2024-02-15', 425.00),
(10, 7, '2024-02-20', 800.00),
(11, 3, '2024-02-25', 75.00),
(12, 8, '2024-03-01', 60.00),
(13, 1, '2024-03-05', 75.00),
(14, 9, '2024-03-10', 1200.00),
(15, 2, '2024-03-15', 20.00),
(16, 4, '2024-03-20', 150.00),
(17, 10, '2024-03-25', 800.00),
(18, 5, '2024-04-01', 90.00),
(19, 1, '2024-04-05', 350.00),
(20, 6, '2024-04-10', 15.00),
(21, 2, '2024-04-15', 60.00),
(22, 7, '2024-04-20', 25.00),
(23, 3, '2024-04-25', 1200.00),
(24, 8, '2024-05-01', 90.00),
(25, 1, '2024-05-05', 1225.00),
(26, 4, '2024-05-10', 240.00),
(27, 9, '2024-05-15', 75.00),
(28, 2, '2024-05-20', 150.00),
(29, 5, '2024-05-25', 20.00),
(30, 10, '2024-06-01', 800.00),
(31, 1, '2024-06-05', 425.00),
(32, 6, '2024-06-10', 60.00),
(33, 3, '2024-06-15', 350.00),
(34, 7, '2024-06-20', 90.00),
(35, 8, '2024-06-25', 15.00);

-- Insert Order Items
INSERT INTO order_items VALUES
(1, 1, 1, 1, 1200.00), (2, 1, 2, 1, 25.00),
(3, 2, 3, 1, 75.00), (4, 2, 9, 1, 15.00),
(5, 3, 4, 1, 350.00),
(6, 4, 2, 1, 25.00),
(7, 5, 6, 2, 60.00), (8, 5, 8, 2, 90.00),
(9, 6, 1, 1, 1200.00),
(10, 7, 7, 1, 150.00),
(11, 8, 8, 1, 90.00),
(12, 9, 4, 1, 350.00), (13, 9, 3, 1, 75.00),
(14, 10, 10, 1, 800.00),
(15, 11, 3, 1, 75.00),
(16, 12, 6, 1, 60.00),
(17, 13, 3, 1, 75.00),
(18, 14, 1, 1, 1200.00),
(19, 15, 5, 1, 20.00),
(20, 16, 7, 1, 150.00),
(21, 17, 10, 1, 800.00),
(22, 18, 8, 1, 90.00),
(23, 19, 4, 1, 350.00),
(24, 20, 9, 1, 15.00),
(25, 21, 6, 1, 60.00),
(26, 22, 2, 1, 25.00),
(27, 23, 1, 1, 1200.00),
(28, 24, 8, 1, 90.00),
(29, 25, 1, 1, 1200.00), (30, 25, 2, 1, 25.00),
(31, 26, 6, 2, 60.00), (32, 26, 8, 2, 90.00),
(33, 27, 3, 1, 75.00),
(34, 28, 7, 1, 150.00),
(35, 29, 5, 1, 20.00),
(36, 30, 10, 1, 800.00),
(37, 31, 4, 1, 350.00), (38, 31, 3, 1, 75.00),
(39, 32, 6, 1, 60.00),
(40, 33, 4, 1, 350.00),
(41, 34, 8, 1, 90.00),
(42, 35, 9, 1, 15.00);

-- Note: Some customers haven't ordered recently (for churn analysis)
-- Customer 4 last ordered on 2024-05-10 (potential churn)
-- Customer 9 last ordered on 2024-05-15 (potential churn)


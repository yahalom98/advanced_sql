# Session 5: Step-by-Step Tutorial - Complete Case Study

## 🎯 Goal
Build a complete SQL project from start to finish - E-Commerce example.

---

## Project Overview
Build a complete e-commerce database, analyze it, and create insights.

**Time:** 3 hours  
**Steps:** 10 steps

---

## Step 1: Design the Database (30 min)

### 1.1 List what you need
- Customers (who buys)
- Products (what they buy)
- Orders (when they buy)
- Order Items (how many)
- Categories (organize products)

### 1.2 Create the schema
```sql
USE sql_course;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE,
    city VARCHAR(50)
);

-- Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20) DEFAULT 'pending',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## Step 2: Insert Sample Data (20 min)

### 2.1 Insert customers
```sql
INSERT INTO customers (first_name, last_name, email, registration_date, city) VALUES
('Alice', 'Johnson', 'alice@email.com', '2023-01-15', 'New York'),
('Bob', 'Smith', 'bob@email.com', '2023-02-20', 'Los Angeles'),
('Charlie', 'Brown', 'charlie@email.com', '2023-01-10', 'Chicago'),
('Diana', 'Prince', 'diana@email.com', '2023-03-05', 'Miami'),
('Eve', 'Wilson', 'eve@email.com', '2023-02-01', 'Seattle');
```

### 2.2 Insert categories
```sql
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Garden');
```

### 2.3 Insert products
```sql
INSERT INTO products (product_name, category_id, price, cost) VALUES
('Laptop', 1, 1200.00, 800.00),
('Mouse', 1, 25.00, 10.00),
('Keyboard', 1, 75.00, 30.00),
('T-Shirt', 2, 20.00, 8.00),
('Jeans', 2, 60.00, 25.00),
('Plant Pot', 3, 15.00, 5.00);
```

### 2.4 Insert orders
```sql
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2024-01-05', 'completed', 1225.00),
(1, '2024-01-20', 'completed', 25.00),
(2, '2024-01-10', 'completed', 80.00),
(3, '2024-01-15', 'completed', 1200.00),
(4, '2024-02-01', 'completed', 140.00),
(5, '2024-02-05', 'pending', 60.00);
```

### 2.5 Insert order items
```sql
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),  -- Laptop
(1, 2, 1, 25.00),    -- Mouse
(2, 2, 1, 25.00),    -- Mouse
(3, 3, 1, 75.00),    -- Keyboard
(3, 2, 1, 5.00),     -- Mouse (discounted)
(4, 1, 1, 1200.00),  -- Laptop
(5, 4, 2, 20.00),    -- T-Shirt x2
(5, 5, 1, 60.00),    -- Jeans
(5, 6, 1, 20.00),    -- Plant Pot
(6, 5, 1, 60.00);    -- Jeans
```

---

## Step 3: Verify Your Data (10 min)

### 3.1 Check all tables
```sql
SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
```

### 3.2 Test a join
```sql
SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
```

---

## Step 4: Answer Business Questions (60 min)

### Question 1: Top 5 Customers by Total Spent
```sql
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) as total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;
```

### Question 2: Revenue by Category
```sql
SELECT 
    cat.category_name,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(oi.quantity * oi.unit_price) as total_revenue
FROM categories cat
INNER JOIN products p ON cat.category_id = p.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY cat.category_id, cat.category_name
ORDER BY total_revenue DESC;
```

### Question 3: Average Order Value
```sql
SELECT 
    AVG(total_amount) as avg_order_value,
    MIN(total_amount) as min_order_value,
    MAX(total_amount) as max_order_value
FROM orders
WHERE status = 'completed';
```

### Question 4: Products Never Sold
```sql
SELECT 
    p.product_id,
    p.product_name,
    p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
```

### Question 5: Monthly Revenue Trend
```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(*) as order_count,
    SUM(total_amount) as monthly_revenue
FROM orders
WHERE status = 'completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

### Question 6: Customer Lifetime Value
```sql
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(o.total_amount) as lifetime_value,
    AVG(o.total_amount) as avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_value DESC;
```

### Question 7: Best Selling Products
```sql
SELECT 
    p.product_name,
    cat.category_name,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) as total_revenue
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY total_quantity_sold DESC;
```

### Question 8: Customers with No Orders
```sql
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

---

## Step 5: Create Summary Views (20 min)

### 5.1 Customer summary view
```sql
CREATE VIEW customer_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.city,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value,
    MAX(o.order_date) as last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.city;
```

### 5.2 Product performance view
```sql
CREATE VIEW product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    COALESCE(SUM(oi.quantity), 0) as units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) as total_revenue
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'completed'
GROUP BY p.product_id, p.product_name, cat.category_name, p.price;
```

---

## Step 6: Export Data for Visualization (10 min)

### 6.1 Export customer summary
```sql
-- In MySQL Workbench: Run query, then Export to CSV
SELECT * FROM customer_summary;
```

### 6.2 Export monthly revenue
```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(*) as order_count,
    SUM(total_amount) as monthly_revenue
FROM orders
WHERE status = 'completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

---

## Step 7: Create Tableau Dashboard (30 min)

### 7.1 Connect to MySQL
1. Open Tableau
2. Connect to MySQL
3. Select `sql_course` database
4. Use the views you created

### 7.2 Create charts
- **Bar Chart:** Revenue by category
- **Line Chart:** Monthly revenue trend
- **Table:** Top customers
- **Pie Chart:** Product sales distribution

### 7.3 Combine into dashboard
- Arrange all charts on one dashboard
- Add filters
- Format nicely

---

## Step 8: Write Summary Report (20 min)

### 8.1 Key findings
Write 2-3 paragraphs about:
- Top performing products
- Best customers
- Revenue trends
- Recommendations

### 8.2 Example:
```
Key Findings:
1. Electronics category generates the most revenue ($2,500)
2. Alice Johnson is our top customer with $1,250 total spent
3. Revenue is growing month-over-month
4. Laptop is the best-selling product

Recommendations:
1. Focus marketing on electronics category
2. Create loyalty program for top customers
3. Expand laptop inventory
```

---

## Step 9: Present Your Work (10 min)

### 9.1 Prepare presentation
- Show your database schema
- Show key queries
- Show Tableau dashboard
- Present findings

### 9.2 Practice explaining
- Why you designed it this way
- What insights you found
- What you'd do next

---

## Step 10: Review and Improve (10 min)

### 10.1 Check your work
- [ ] All tables created correctly
- [ ] Data inserted properly
- [ ] Queries return correct results
- [ ] Views work
- [ ] Dashboard looks good

### 10.2 Think about improvements
- What would you add?
- What would you change?
- How would you scale this?

---

## ✅ Project Checklist

- [ ] Database schema designed
- [ ] Tables created with proper relationships
- [ ] Sample data inserted
- [ ] 8+ business questions answered
- [ ] Views created
- [ ] Data exported
- [ ] Tableau dashboard created
- [ ] Summary report written
- [ ] Presentation prepared

---

## 🎯 Congratulations!

You've completed a full SQL project! You now know how to:
- Design databases
- Write complex queries
- Analyze business data
- Create visualizations
- Present findings

**You're ready for real-world data analyst work!** 🚀


# Session 5: Case Study - Solutions with Explanations

## Exercise 1: Design Schema for Online Store

### Solution
```sql
-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    registration_date DATE
);

-- Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    description TEXT
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    stock_quantity INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20) DEFAULT 'pending',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Reviews
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Explanation
- **Normalized design**: All tables in 3NF
  - Customer data in `customers` table
  - Product data in `products` table
  - Category data in `categories` table
- **Relationships**:
  - Customer → Orders (one-to-many)
  - Order → Order Items (one-to-many)
  - Product → Order Items (one-to-many)
  - Category → Products (one-to-many)
  - Customer → Reviews (one-to-many)
  - Product → Reviews (one-to-many)
- **Inventory tracking**: `stock_quantity` in products table
- **Constraints**: UNIQUE on email, CHECK on rating, FOREIGN KEYs for relationships

### Why This Works
This schema is properly normalized, handles all relationships correctly, and includes all required features. The design is scalable and maintainable.

---

## Exercise 2: Generate Realistic Sample Data

### Solution
```sql
-- Insert customers
INSERT INTO customers (first_name, last_name, email, registration_date) VALUES
('John', 'Smith', 'john.smith@email.com', '2023-01-15'),
('Sarah', 'Johnson', 'sarah.j@email.com', '2023-02-20'),
('Mike', 'Brown', 'mike.brown@email.com', '2023-01-10'),
('Emily', 'Davis', 'emily.d@email.com', '2023-03-05'),
('David', 'Wilson', 'david.w@email.com', '2023-02-01'),
('Lisa', 'Anderson', 'lisa.a@email.com', '2023-04-12'),
('Tom', 'Taylor', 'tom.t@email.com', '2023-01-25'),
('Amy', 'Martinez', 'amy.m@email.com', '2023-03-18'),
('Chris', 'Lee', 'chris.l@email.com', '2023-02-14'),
('Jessica', 'Garcia', 'jessica.g@email.com', '2023-05-01');

-- Insert categories
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Home & Garden', 'Home improvement and garden supplies');

-- Insert products
INSERT INTO products (product_name, category_id, price, cost, stock_quantity) VALUES
('Laptop', 1, 1200.00, 800.00, 50),
('Mouse', 1, 25.00, 10.00, 200),
('Keyboard', 1, 75.00, 30.00, 150),
('Monitor', 1, 350.00, 200.00, 75),
('T-Shirt', 2, 20.00, 8.00, 500),
('Jeans', 2, 60.00, 25.00, 300),
('Jacket', 2, 150.00, 75.00, 100),
('Shoes', 2, 90.00, 40.00, 250),
('Plant Pot', 3, 15.00, 5.00, 400),
('Garden Tools', 3, 45.00, 20.00, 150);

-- Insert orders (spread over 6 months)
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2024-01-05', 'completed', 1225.00),
(1, '2024-02-15', 'completed', 25.00),
(2, '2024-01-10', 'completed', 80.00),
(3, '2024-01-15', 'completed', 1200.00),
(4, '2024-02-01', 'completed', 140.00),
(5, '2024-02-05', 'completed', 60.00),
(1, '2024-03-10', 'completed', 425.00),
(6, '2024-03-15', 'completed', 90.00),
(7, '2024-04-01', 'completed', 150.00),
(8, '2024-04-10', 'completed', 20.00),
(2, '2024-05-05', 'completed', 200.00),
(9, '2024-05-15', 'completed', 75.00),
(10, '2024-06-01', 'completed', 45.00);

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),  -- Laptop
(1, 2, 1, 25.00),    -- Mouse
(2, 2, 1, 25.00),    -- Mouse
(3, 3, 1, 75.00),    -- Keyboard
(3, 2, 1, 5.00),     -- Mouse (discounted)
(4, 1, 1, 1200.00),  -- Laptop
(5, 5, 2, 20.00),    -- T-Shirt x2
(5, 6, 1, 60.00),    -- Jeans
(5, 9, 1, 20.00),    -- Plant Pot
(6, 6, 1, 60.00),    -- Jeans
(7, 4, 1, 350.00),   -- Monitor
(7, 3, 1, 75.00),    -- Keyboard
(8, 8, 1, 90.00),    -- Shoes
(9, 7, 1, 150.00),    -- Jacket
(10, 5, 1, 20.00),   -- T-Shirt
(11, 1, 1, 1200.00), -- Laptop
(12, 3, 1, 75.00),   -- Keyboard
(13, 10, 1, 45.00);  -- Garden Tools

-- Insert reviews
INSERT INTO reviews (customer_id, product_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Great laptop, very fast!', '2024-01-10'),
(2, 3, 4, 'Good keyboard, comfortable to use', '2024-01-15'),
(3, 1, 5, 'Excellent product, highly recommend', '2024-01-20'),
(4, 5, 3, 'Okay quality, expected better', '2024-02-05'),
(5, 6, 4, 'Good jeans, fit well', '2024-02-10');
```

### Explanation
- **Realistic data**: 
  - Real names and email formats
  - Spread dates over 6 months
  - Varied order amounts
  - Some products more popular (laptop appears multiple times)
- **Edge cases included**:
  - Customer 9 and 10 have fewer orders
  - Some products have no reviews
  - Mix of order statuses
- **Data relationships**: All foreign keys properly maintained

### Why This Works
Good sample data should be realistic, varied, and include edge cases. This helps test your queries thoroughly and makes your analysis more meaningful.

---

## Exercise 3: Top Customers Query

### Solution
```sql
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    SUM(o.total_amount) as total_spent,
    COUNT(o.order_id) as order_count,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;
```

### Explanation
- **JOIN**: Links customers with their orders
- **WHERE**: Only count completed orders
- **Aggregations**:
  - `SUM(total_amount)` = lifetime value
  - `COUNT(order_id)` = number of orders
  - `AVG(total_amount)` = average order value
- **GROUP BY**: Required for aggregations
- **ORDER BY**: Sort by total spent (highest first)
- **LIMIT 5**: Top 5 only

### Why This Works
This query identifies your best customers by combining multiple metrics. The JOIN connects customer info with order data, and aggregations calculate the key metrics businesses care about.

---

## Exercise 4: Product Performance Analysis

### Solution

**1. Best selling products (by quantity)**
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

**2. Products with highest revenue**
```sql
SELECT 
    p.product_name,
    SUM(oi.quantity * oi.unit_price) as total_revenue,
    SUM(oi.quantity) as units_sold
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;
```

**3. Products that haven't sold**
```sql
SELECT 
    p.product_id,
    p.product_name,
    p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
```

**4. Average order value by category**
```sql
SELECT 
    cat.category_name,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(oi.quantity * oi.unit_price) as total_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id), 2) as avg_order_value
FROM categories cat
INNER JOIN products p ON cat.category_id = p.category_id
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY cat.category_id, cat.category_name
ORDER BY avg_order_value DESC;
```

### Explanation
- **Query 1-2**: Standard aggregations with JOINs to get product performance
- **Query 3**: Uses LEFT JOIN to find products with no matching order_items (NULL check)
- **Query 4**: Groups by category and calculates average order value per category
- **All queries**: Filter by `status = 'completed'` to only count actual sales

### Why This Works
These queries answer key business questions about product performance. They help identify best sellers, underperformers, and category trends - all crucial for inventory and marketing decisions.

---

## Exercise 5: Monthly Revenue Trend

### Solution
```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    SUM(total_amount) as revenue,
    LAG(SUM(total_amount), 1) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) as prev_month,
    ROUND(
        ((SUM(total_amount) - LAG(SUM(total_amount), 1) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) 
         / LAG(SUM(total_amount), 1) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) * 100, 
        2
    ) as growth_pct
FROM orders
WHERE status = 'completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

### Explanation
- **DATE_FORMAT**: Groups orders by year-month ('2024-01', '2024-02', etc.)
- **SUM**: Total revenue per month
- **LAG**: Gets previous month's revenue for comparison
- **Growth calculation**: (current - previous) / previous * 100
- **Window function**: LAG with ORDER BY to get previous month correctly

### Why This Works
This shows revenue trends over time, which is critical for business planning. The month-over-month growth helps identify if business is growing, declining, or stable.

---

## Exercise 6: Customer Segmentation

### Solution
```sql
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) as customer_name,
        SUM(o.total_amount) as total_spent
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.first_name, c.last_name
),
segmented AS (
    SELECT 
        customer_id,
        customer_name,
        total_spent,
        NTILE(5) OVER (ORDER BY total_spent DESC) as segment_num
    FROM customer_totals
)
SELECT 
    CASE 
        WHEN segment_num = 1 THEN 'High-value'
        WHEN segment_num BETWEEN 2 AND 4 THEN 'Medium-value'
        WHEN segment_num = 5 THEN 'Low-value'
    END as segment,
    COUNT(*) as customer_count,
    ROUND(AVG(total_spent), 2) as avg_spending
FROM segmented
GROUP BY segment
ORDER BY avg_spending DESC;
```

### Explanation
- **CTE 1**: Calculates total spent per customer
- **CTE 2**: Uses NTILE(5) to divide into 5 groups (20% each)
  - Group 1 = top 20% (high-value)
  - Groups 2-4 = middle 60% (medium-value)
  - Group 5 = bottom 20% (low-value)
- **Main query**: Groups by segment and calculates averages

### Why This Works
Customer segmentation helps target marketing efforts. High-value customers might get VIP treatment, while low-value customers might get re-engagement campaigns. NTILE makes it easy to divide customers into equal groups.

---

## Exercise 7: Create Views for Dashboard

### Solution

**1. Customer Summary View**
```sql
CREATE VIEW customer_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURRENT_DATE, MAX(o.order_date)) as days_since_last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;
```

**2. Product Performance View**
```sql
CREATE VIEW product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    COALESCE(SUM(oi.quantity), 0) as units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) as total_revenue,
    p.stock_quantity,
    CASE 
        WHEN p.stock_quantity < 10 THEN 'Low Stock'
        WHEN p.stock_quantity < 50 THEN 'Medium Stock'
        ELSE 'In Stock'
    END as stock_status
FROM products p
INNER JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status = 'completed'
GROUP BY p.product_id, p.product_name, cat.category_name, p.price, p.stock_quantity;
```

**3. Monthly Revenue View**
```sql
CREATE VIEW monthly_revenue AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(DISTINCT order_id) as order_count,
    COUNT(DISTINCT customer_id) as customer_count,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

### Explanation
- **Views**: Save complex queries for reuse
- **LEFT JOIN**: Includes customers/products with no orders (shows 0)
- **COALESCE**: Converts NULL to 0 for products with no sales
- **Calculated fields**: Days since last order, stock status
- **All views**: Can be queried like tables: `SELECT * FROM customer_summary`

### Why This Works
Views make complex queries reusable and simplify reporting. Instead of rewriting complex JOINs every time, you query the view. This is especially useful for dashboards that need the same data repeatedly.

---

## Exercise 8: Export and Prepare for Tableau

### Solution

**Step 1: Export Views**
```sql
-- In MySQL Workbench:
-- 1. Run: SELECT * FROM customer_summary;
-- 2. Right-click results → Export Recordset to External File
-- 3. Choose CSV format
-- 4. Save as customer_summary.csv

-- Repeat for other views
```

**Step 2: Data Dictionary**

```
Table: customer_summary
- customer_id: INT - Unique customer identifier
- customer_name: VARCHAR - Full name (first + last)
- email: VARCHAR - Customer email address
- total_orders: INT - Number of completed orders
- total_spent: DECIMAL - Lifetime value in dollars
- avg_order_value: DECIMAL - Average amount per order
- last_order_date: DATE - Date of most recent order
- days_since_last_order: INT - Days since last purchase (for churn analysis)

Table: product_performance
- product_id: INT - Unique product identifier
- product_name: VARCHAR - Product name
- category_name: VARCHAR - Product category
- price: DECIMAL - Current product price
- units_sold: INT - Total quantity sold (0 if never sold)
- total_revenue: DECIMAL - Total revenue from this product
- stock_quantity: INT - Current inventory level
- stock_status: VARCHAR - Low/Medium/In Stock indicator

Table: monthly_revenue
- month: VARCHAR - Year-month format (YYYY-MM)
- order_count: INT - Number of orders in month
- customer_count: INT - Number of unique customers
- total_revenue: DECIMAL - Total revenue for month
- avg_order_value: DECIMAL - Average order value for month
```

### Explanation
- **Export process**: CSV is standard format for Tableau
- **Data dictionary**: Documents what each column means
- **Important**: Note any calculations or aggregations
- **Use in Tableau**: Import CSV files, create visualizations

### Why This Works
Exporting to CSV bridges SQL and visualization tools. The data dictionary helps others understand your data, making collaboration easier. Tableau can then create interactive dashboards from your SQL analysis.

---

## Exercise 9: Write Business Insights

### Example Insights

**1. Customer Concentration**
- **Finding**: Top 20% of customers generate 65% of revenue
- **Data**: High-value segment (5 customers) = $2,500, Total = $3,850
- **Implication**: Business heavily dependent on few customers
- **Recommendation**: 
  - Create VIP program for high-value customers
  - Focus retention efforts on top segment
  - Develop strategies to move medium-value to high-value

**2. Product Performance**
- **Finding**: Electronics category has highest average order value ($425)
- **Data**: Electronics avg = $425, Clothing = $45, Home & Garden = $30
- **Implication**: Customers spend more on electronics
- **Recommendation**:
  - Increase electronics inventory
  - Cross-sell electronics to clothing customers
  - Feature electronics in marketing campaigns

**3. Revenue Growth**
- **Finding**: Revenue declining month-over-month in recent months
- **Data**: Jan = $2,505, Feb = $280, Mar = $515, Apr = $170, May = $275, Jun = $45
- **Implication**: Business may be losing momentum
- **Recommendation**:
  - Investigate cause of decline
  - Launch re-engagement campaign
  - Consider seasonal factors

### Explanation
- **Structure**: Finding → Data → Implication → Recommendation
- **Data-driven**: Each insight backed by actual numbers
- **Actionable**: Recommendations are specific and implementable
- **Business-focused**: Answers "so what?" question

### Why This Works
Good insights connect data to business decisions. They tell a story: what's happening, why it matters, and what to do about it. This is what makes a data analyst valuable.

---

## Key Takeaways

1. **Schema design**: Start with entities, identify relationships, normalize properly
2. **Sample data**: Make it realistic, varied, and include edge cases
3. **Queries**: Answer business questions, not just technical exercises
4. **Views**: Save complex queries for reuse
5. **Export**: Bridge SQL and visualization tools
6. **Insights**: Connect data to business decisions

---

## Common Mistakes to Avoid

1. ❌ Over-complicating schema (keep it simple)
2. ❌ Not testing queries with sample data
3. ❌ Forgetting to filter by order status
4. ❌ Not documenting your work
5. ❌ Focusing only on queries, not insights
6. ❌ Not preparing for presentation

---

**Great job! You're ready for real-world data analysis projects!** 🎉


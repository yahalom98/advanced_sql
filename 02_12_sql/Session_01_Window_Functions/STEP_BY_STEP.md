# Session 1: Step-by-Step Tutorial - Window Functions

## 🎯 Goal
Learn window functions step-by-step with simple examples in MySQL.

---

## Step 1: Setup MySQL Database

### 1.1 Open MySQL Workbench (or command line)

### 1.2 Create database and table
```sql
-- Create database
CREATE DATABASE sql_course;
USE sql_course;

-- Create a simple sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    sale_date DATE,
    amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO sales (customer_id, sale_date, amount) VALUES
(1, '2024-01-05', 100.00),
(1, '2024-01-15', 150.00),
(1, '2024-02-01', 200.00),
(2, '2024-01-10', 75.00),
(2, '2024-02-05', 120.00),
(3, '2024-01-20', 300.00),
(1, '2024-02-20', 180.00),
(2, '2024-03-01', 250.00);
```

### 1.3 Verify data
```sql
SELECT * FROM sales ORDER BY customer_id, sale_date;
```

---

## Step 2: Understanding Window Functions (Simple Example)

### 2.1 What's the difference?

**Regular SUM (aggregate):**
```sql
-- This collapses rows - shows total per customer
SELECT customer_id, SUM(amount) as total
FROM sales
GROUP BY customer_id;
```

**Window Function SUM:**
```sql
-- This keeps all rows - shows running total
SELECT 
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date) as running_total
FROM sales;
```

**Try it!** Run both queries and see the difference.

---

## Step 3: Running Totals (Easiest Window Function)

### 3.1 Calculate running total per customer

```sql
SELECT 
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id 
        ORDER BY sale_date
    ) as running_total
FROM sales
ORDER BY customer_id, sale_date;
```

**What this does:**
- `PARTITION BY customer_id` = Start over for each customer
- `ORDER BY sale_date` = Calculate in date order
- `SUM(amount)` = Add up amounts

**Expected Result:**
```
customer_id | sale_date  | amount | running_total
------------|------------|--------|--------------
1           | 2024-01-05 | 100.00 | 100.00
1           | 2024-01-15 | 150.00 | 250.00
1           | 2024-02-01 | 200.00 | 450.00
1           | 2024-02-20 | 180.00 | 630.00
2           | 2024-01-10 | 75.00  | 75.00
...
```

### 3.2 Practice: Add running total to your query
Modify the query to also show the average amount per customer.

<details>
<summary>💡 Hint</summary>
Use AVG() instead of SUM()
</details>

---

## Step 4: Ranking Functions

### 4.1 Create products table
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Mouse', 'Electronics', 25.00),
('Keyboard', 'Electronics', 75.00),
('Monitor', 'Electronics', 350.00),
('T-Shirt', 'Clothing', 20.00),
('Jeans', 'Clothing', 60.00),
('Jacket', 'Clothing', 150.00);
```

### 4.2 Rank products by price
```sql
SELECT 
    product_name,
    category,
    price,
    RANK() OVER (ORDER BY price DESC) as rank_by_price
FROM products;
```

**What RANK() does:**
- Ranks from highest to lowest
- If two products have same price, they get same rank
- Next rank skips numbers (1, 2, 2, 4)

### 4.3 Rank within each category
```sql
SELECT 
    product_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) as rank_in_category
FROM products;
```

**Try it!** Now each category has its own ranking.

### 4.4 Compare RANK vs DENSE_RANK vs ROW_NUMBER

```sql
SELECT 
    product_name,
    price,
    RANK() OVER (ORDER BY price DESC) as rank_with_gaps,
    DENSE_RANK() OVER (ORDER BY price DESC) as rank_no_gaps,
    ROW_NUMBER() OVER (ORDER BY price DESC) as row_number
FROM products;
```

**Differences:**
- **RANK**: 1, 2, 2, 4 (gaps when ties)
- **DENSE_RANK**: 1, 2, 2, 3 (no gaps)
- **ROW_NUMBER**: 1, 2, 3, 4 (always unique)

---

## Step 5: Top N per Category

### 5.1 Get top 2 products per category

```sql
SELECT * FROM (
    SELECT 
        product_name,
        category,
        price,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY price DESC
        ) as rank_in_category
    FROM products
) ranked
WHERE rank_in_category <= 2
ORDER BY category, rank_in_category;
```

**Step-by-step:**
1. Inner query: Rank products within each category
2. Outer query: Filter to top 2 only

---

## Step 6: Compare Current vs Previous (LAG)

### 6.1 Create monthly sales table
```sql
CREATE TABLE monthly_sales (
    month DATE,
    total_sales DECIMAL(10,2)
);

INSERT INTO monthly_sales VALUES
('2024-01-01', 50000.00),
('2024-02-01', 55000.00),
('2024-03-01', 48000.00),
('2024-04-01', 62000.00),
('2024-05-01', 58000.00);
```

### 6.2 Compare to previous month
```sql
SELECT 
    month,
    total_sales as current_month,
    LAG(total_sales, 1) OVER (ORDER BY month) as previous_month,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY month) as difference
FROM monthly_sales
ORDER BY month;
```

**What LAG() does:**
- `LAG(column, 1)` = Get value from 1 row before
- First row has NULL (no previous row)

### 6.3 Calculate percentage change
```sql
SELECT 
    month,
    total_sales as current_month,
    LAG(total_sales, 1) OVER (ORDER BY month) as previous_month,
    ROUND(
        ((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
         / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 
        2
    ) as percent_change
FROM monthly_sales
ORDER BY month;
```

---

## Step 7: Moving Average

### 7.1 Create daily sales
```sql
CREATE TABLE daily_sales (
    sale_date DATE,
    sales_amount DECIMAL(10,2)
);

-- Insert 30 days of data
INSERT INTO daily_sales (sale_date, sales_amount) VALUES
('2024-01-01', 500.00),
('2024-01-02', 520.00),
('2024-01-03', 480.00),
('2024-01-04', 550.00),
('2024-01-05', 600.00),
('2024-01-06', 580.00),
('2024-01-07', 620.00);
-- Add more dates as needed
```

### 7.2 Calculate 7-day moving average
```sql
SELECT 
    sale_date,
    sales_amount,
    AVG(sales_amount) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7d
FROM daily_sales
ORDER BY sale_date;
```

**What ROWS BETWEEN does:**
- `6 PRECEDING` = 6 rows before current
- `CURRENT ROW` = current row
- So it averages 7 rows total (6 before + current)

---

## Step 8: Practice Challenge

### Challenge: Create a Sales Report

**Requirements:**
1. Show all sales with running total per customer
2. Rank each sale within customer (by amount)
3. Show previous sale amount for each customer
4. Calculate 3-sale moving average per customer

**Your SQL:**
```sql
-- Write your query here
```

<details>
<summary>💡 Solution</summary>

```sql
SELECT 
    customer_id,
    sale_date,
    amount,
    -- Running total
    SUM(amount) OVER (
        PARTITION BY customer_id 
        ORDER BY sale_date
    ) as running_total,
    -- Rank by amount
    RANK() OVER (
        PARTITION BY customer_id 
        ORDER BY amount DESC
    ) as rank_by_amount,
    -- Previous sale
    LAG(amount, 1) OVER (
        PARTITION BY customer_id 
        ORDER BY sale_date
    ) as previous_sale,
    -- 3-sale moving average
    AVG(amount) OVER (
        PARTITION BY customer_id 
        ORDER BY sale_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3
FROM sales
ORDER BY customer_id, sale_date;
```

</details>

---

## ✅ Check Your Understanding

1. What's the difference between `SUM()` and `SUM() OVER()`?
2. When would you use `PARTITION BY`?
3. What's the difference between `RANK()` and `DENSE_RANK()`?
4. How does `LAG()` work?
5. What does `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` mean?

---

## 🎯 Next Steps

- Try the exercises in the main README
- Experiment with different window functions
- Practice on your own data

**Ready for Session 2?** Let's learn about query optimization!


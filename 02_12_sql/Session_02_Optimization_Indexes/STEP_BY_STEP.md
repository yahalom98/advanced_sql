# Session 2: Step-by-Step Tutorial - SQL Optimization

## 🎯 Goal
Learn how to make SQL queries faster using indexes and optimization techniques in MySQL.

---

## Step 1: Understanding Query Performance

### 1.1 Create a large table
```sql
USE sql_course;

-- Create table with 100,000 rows
CREATE TABLE large_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(20)
);

-- Insert 100,000 rows (this might take a minute)
INSERT INTO large_orders (customer_id, order_date, amount, status)
SELECT 
    FLOOR(1 + RAND() * 1000) as customer_id,
    DATE('2024-01-01' + INTERVAL FLOOR(RAND() * 365) DAY) as order_date,
    ROUND(10 + RAND() * 1000, 2) as amount,
    ELT(1 + FLOOR(RAND() * 3), 'pending', 'completed', 'cancelled') as status
FROM 
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t5
LIMIT 100000;
```

### 1.2 Run a slow query (no index)
```sql
-- This will be slow!
SELECT * FROM large_orders 
WHERE customer_id = 500;
```

### 1.3 Check the execution plan
```sql
EXPLAIN SELECT * FROM large_orders 
WHERE customer_id = 500;
```

**Look for:**
- `type: ALL` = Full table scan (BAD!)
- `rows: 100000` = Checking all rows (BAD!)

---

## Step 2: Create Your First Index

### 2.1 Add index on customer_id
```sql
CREATE INDEX idx_customer_id ON large_orders(customer_id);
```

### 2.2 Run the same query again
```sql
SELECT * FROM large_orders 
WHERE customer_id = 500;
```

**Notice:** It's much faster!

### 2.3 Check execution plan again
```sql
EXPLAIN SELECT * FROM large_orders 
WHERE customer_id = 500;
```

**Now you should see:**
- `type: ref` = Using index (GOOD!)
- `rows: ~100` = Only checking relevant rows (GOOD!)

---

## Step 3: Understanding Index Types

### 3.1 Single Column Index
```sql
-- Already created above
CREATE INDEX idx_customer_id ON large_orders(customer_id);
```

**Use when:** Filtering by one column

### 3.2 Composite Index (Multiple Columns)
```sql
CREATE INDEX idx_customer_date ON large_orders(customer_id, order_date);
```

**Use when:** Filtering by multiple columns together

**Important:** Order matters!
- `(customer_id, order_date)` is good for:
  - `WHERE customer_id = X`
  - `WHERE customer_id = X AND order_date > Y`
- But NOT good for:
  - `WHERE order_date > Y` (without customer_id)

### 3.3 Test composite index
```sql
-- This uses the index
EXPLAIN SELECT * FROM large_orders 
WHERE customer_id = 500 AND order_date > '2024-06-01';

-- This might NOT use the index efficiently
EXPLAIN SELECT * FROM large_orders 
WHERE order_date > '2024-06-01';
```

---

## Step 4: Common Performance Problems

### 4.1 Problem 1: SELECT *

**Bad:**
```sql
SELECT * FROM large_orders WHERE customer_id = 500;
```

**Good:**
```sql
SELECT order_id, customer_id, order_date, amount 
FROM large_orders 
WHERE customer_id = 500;
```

**Why:** Only fetch columns you need

### 4.2 Problem 2: Functions in WHERE

**Bad:**
```sql
SELECT * FROM large_orders 
WHERE YEAR(order_date) = 2024;
```

**Good:**
```sql
SELECT * FROM large_orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';
```

**Why:** Indexes can't be used with functions

### 4.3 Problem 3: OR Conditions

**Bad:**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 500 OR customer_id = 600;
```

**Good:**
```sql
SELECT * FROM large_orders 
WHERE customer_id IN (500, 600);
```

**Why:** IN is more index-friendly

---

## Step 5: Optimize a Real Query

### 5.1 Create related tables
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (customer_id, name, email)
SELECT DISTINCT customer_id, 
       CONCAT('Customer ', customer_id),
       CONCAT('customer', customer_id, '@email.com')
FROM large_orders
LIMIT 1000;
```

### 5.2 Slow query (no indexes)
```sql
-- Find total amount per customer
SELECT 
    c.name,
    SUM(o.amount) as total_spent
FROM customers c
INNER JOIN large_orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-06-01'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;
```

### 5.3 Check execution plan
```sql
EXPLAIN SELECT 
    c.name,
    SUM(o.amount) as total_spent
FROM customers c
INNER JOIN large_orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-06-01'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;
```

### 5.4 Add indexes
```sql
-- Index on join column
CREATE INDEX idx_orders_customer ON large_orders(customer_id);

-- Index on filter column
CREATE INDEX idx_orders_date ON large_orders(order_date);

-- Composite index for both
CREATE INDEX idx_orders_customer_date ON large_orders(customer_id, order_date);
```

### 5.5 Run query again and compare
```sql
-- Should be much faster now!
SELECT 
    c.name,
    SUM(o.amount) as total_spent
FROM customers c
INNER JOIN large_orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-06-01'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 10;
```

---

## Step 6: When NOT to Use Indexes

### 6.1 Small tables
```sql
-- Table with 100 rows - index not needed
CREATE TABLE small_table (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
-- Don't create index here - table is too small
```

### 6.2 Frequently updated columns
```sql
-- If this column changes often, index might slow down updates
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    stock_quantity INT  -- Changes frequently, maybe don't index
);
```

### 6.3 Low selectivity columns
```sql
-- Column with only 2-3 values (like status: active/inactive)
-- Index won't help much
```

---

## Step 7: Practice - Optimize These Queries

### Query 1: Fix the function
```sql
-- Current (slow):
SELECT * FROM large_orders 
WHERE MONTH(order_date) = 6;

-- Your optimized version:
-- Write here
```

<details>
<summary>💡 Solution</summary>

```sql
SELECT * FROM large_orders 
WHERE order_date >= '2024-06-01' 
  AND order_date < '2024-07-01';
```

</details>

### Query 2: Fix SELECT *
```sql
-- Current (slow):
SELECT * FROM large_orders 
WHERE customer_id = 500;

-- Your optimized version:
-- Write here
```

<details>
<summary>💡 Solution</summary>

```sql
SELECT order_id, customer_id, order_date, amount 
FROM large_orders 
WHERE customer_id = 500;
```

</details>

---

## Step 8: View All Indexes

### 8.1 See indexes on a table
```sql
SHOW INDEXES FROM large_orders;
```

### 8.2 Drop an index (if needed)
```sql
DROP INDEX idx_customer_id ON large_orders;
```

---

## ✅ Check Your Understanding

1. What does `EXPLAIN` show you?
2. When should you create an index?
3. Why is `SELECT *` bad for performance?
4. What's wrong with using functions in WHERE clauses?
5. What's a composite index?

---

## 🎯 Next Steps

- Practice optimizing queries
- Try the challenge queries in the main README
- Learn to read execution plans

**Ready for Session 3?** Let's do data analysis with Tableau!


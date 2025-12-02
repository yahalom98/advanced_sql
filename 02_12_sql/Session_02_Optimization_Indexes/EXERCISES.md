# Session 2: SQL Optimization - Exercises

## Exercise 1: Analyze Query Performance

### Setup
```sql
USE sql_course;

-- Create a large table
CREATE TABLE large_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    status VARCHAR(20)
);

-- Insert 50,000 rows (this might take a minute)
-- For testing, you can insert fewer rows
INSERT INTO large_orders (customer_id, order_date, amount, status)
SELECT 
    FLOOR(1 + RAND() * 100) as customer_id,
    DATE('2024-01-01' + INTERVAL FLOOR(RAND() * 365) DAY) as order_date,
    ROUND(10 + RAND() * 1000, 2) as amount,
    ELT(1 + FLOOR(RAND() * 3), 'pending', 'completed', 'cancelled') as status
FROM 
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
    (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4
LIMIT 50000;
```

### Your Task
1. Run this query and check its performance:
```sql
SELECT * FROM large_orders WHERE customer_id = 50;
```

2. Use `EXPLAIN` to analyze the query:
```sql
EXPLAIN SELECT * FROM large_orders WHERE customer_id = 50;
```

3. What does the execution plan show? (Write your observations)

4. Create an index on `customer_id`:
```sql
-- Write your CREATE INDEX statement here
```

5. Run `EXPLAIN` again and compare the results.

### 💡 Hints
- Look at the `type` column in EXPLAIN output
- `ALL` means full table scan (bad)
- `ref` means using index (good)
- Check the `rows` column - lower is better
- Index name format: `idx_column_name`

---

## Exercise 2: Optimize Function in WHERE Clause

### Setup
Use the `large_orders` table from Exercise 1.

### Your Task
**Current query (slow):**
```sql
SELECT * FROM large_orders 
WHERE YEAR(order_date) = 2024;
```

**Your task:** Rewrite this query to avoid using a function in the WHERE clause.

### Expected Result
Same results, but faster execution.

### 💡 Hints
- Instead of `YEAR(order_date) = 2024`, use date range
- 2024 starts on '2024-01-01'
- 2024 ends on '2024-12-31'
- Use `>=` and `<` operators
- Or use `BETWEEN` (but be careful with dates)

---

## Exercise 3: Create Composite Index

### Setup
Use the `large_orders` table.

### Your Task
1. Create a composite index on `(customer_id, order_date)`
2. Test these queries and explain which ones will use the index efficiently:

**Query A:**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 50 AND order_date > '2024-06-01';
```

**Query B:**
```sql
SELECT * FROM large_orders 
WHERE order_date > '2024-06-01';
```

**Query C:**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 50 
ORDER BY order_date DESC;
```

### 💡 Hints
- Composite index order matters!
- Index on (A, B) helps queries with A, or A and B
- It doesn't help queries with only B
- Use EXPLAIN to verify index usage

---

## Exercise 4: Optimize JOIN Query

### Setup
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Insert customers
INSERT INTO customers (customer_id, name, email)
SELECT DISTINCT customer_id, 
       CONCAT('Customer ', customer_id),
       CONCAT('customer', customer_id, '@email.com')
FROM large_orders
LIMIT 100;
```

### Your Task
**Current query:**
```sql
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

1. Use `EXPLAIN` to analyze this query
2. Identify what indexes are needed
3. Create the appropriate indexes
4. Run `EXPLAIN` again and compare

### 💡 Hints
- Index on join column: `customer_id` in `large_orders`
- Index on filter column: `order_date` in `large_orders`
- Composite index might be even better
- Check which table is scanned (look for `type: ALL`)

---

## Exercise 5: Fix SELECT * Anti-Pattern

### Setup
Use the `large_orders` table.

### Your Task
**Current query (inefficient):**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 50 
ORDER BY order_date DESC;
```

Rewrite to only select the columns you actually need:
- `order_id`
- `customer_id`
- `order_date`
- `amount`

### 💡 Hints
- Replace `*` with specific column names
- This reduces data transfer
- Especially important for large tables

---

## Exercise 6: Optimize Subquery

### Setup
Use the `large_orders` and `customers` tables.

### Your Task
**Current query (slow - correlated subquery):**
```sql
SELECT 
    c.customer_id,
    c.name,
    (SELECT COUNT(*) FROM large_orders o 
     WHERE o.customer_id = c.customer_id) as order_count,
    (SELECT SUM(amount) FROM large_orders o 
     WHERE o.customer_id = c.customer_id) as total_spent
FROM customers c;
```

Rewrite this using a JOIN instead of correlated subqueries.

### 💡 Hints
- Correlated subqueries run once per row (slow!)
- Use JOIN with GROUP BY instead
- Aggregate in the JOIN, then select from the result

---

## Exercise 7: Optimize OR Condition

### Setup
Use the `large_orders` table.

### Your Task
**Current query:**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 50 OR customer_id = 60 OR customer_id = 70;
```

Rewrite using `IN` instead of `OR`.

### 💡 Hints
- `IN` is more index-friendly than `OR`
- Syntax: `WHERE column IN (value1, value2, value3)`
- Much simpler and faster

---

## Exercise 8: Analyze Index Usage

### Setup
Create these indexes on `large_orders`:
```sql
CREATE INDEX idx_customer ON large_orders(customer_id);
CREATE INDEX idx_date ON large_orders(order_date);
CREATE INDEX idx_status ON large_orders(status);
CREATE INDEX idx_customer_date ON large_orders(customer_id, order_date);
```

### Your Task
For each query below, use `EXPLAIN` and determine:
1. Which index (if any) is used
2. Why that index is or isn't used

**Query 1:**
```sql
SELECT * FROM large_orders WHERE customer_id = 50;
```

**Query 2:**
```sql
SELECT * FROM large_orders WHERE order_date > '2024-06-01';
```

**Query 3:**
```sql
SELECT * FROM large_orders 
WHERE customer_id = 50 AND order_date > '2024-06-01';
```

**Query 4:**
```sql
SELECT * FROM large_orders WHERE status = 'completed';
```

### 💡 Hints
- Check the `key` column in EXPLAIN output
- `key` shows which index is used
- `NULL` means no index used
- Composite indexes can be used for partial matches (leftmost columns)

---

## ✅ Practice Tips

1. Always use `EXPLAIN` before and after optimization
2. Compare `rows` column - lower is better
3. Check `type` column - `ref` or `range` is good, `ALL` is bad
4. Create indexes on frequently queried columns
5. Test with realistic data volumes

---

**Ready for solutions?** Check the [SOLUTIONS.md](./SOLUTIONS.md) file!


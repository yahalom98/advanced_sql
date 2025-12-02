# Session 2: Real-World SQL Optimization + Indexes

## 🚀 Start Here: Step-by-Step Tutorial

**New to optimization?** Start with the step-by-step guide:
👉 **[STEP_BY_STEP.md](./STEP_BY_STEP.md)** - Simple, beginner-friendly tutorial

## 📋 Session Overview

**Duration:** 3 hours  
**Focus:** Query performance optimization and indexing strategies

---

## 🎯 Learning Objectives

By the end of this session, you will:
- Understand how databases execute queries
- Read and interpret execution plans (EXPLAIN)
- Know when and how to create effective indexes
- Identify and fix performance anti-patterns
- Optimize slow queries for production environments

---

## 📖 Mini-Lecture (20-30 min)

### How Databases Execute Queries

When you run a SQL query, the database goes through several steps:

1. **Parsing**: Check syntax
2. **Planning**: Create execution plan
3. **Optimization**: Choose best execution strategy
4. **Execution**: Run the plan

**Key Tool: EXPLAIN**

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```

**PostgreSQL:**
```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
```

**MySQL:**
```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```

**SQL Server:**
```sql
SET SHOWPLAN_ALL ON;
SELECT * FROM orders WHERE customer_id = 123;
```

### Understanding Execution Plans

**Key Metrics:**
- **Cost**: Estimated relative cost (lower is better)
- **Rows**: Number of rows processed
- **Time**: Actual execution time (ANALYZE)
- **Scans**: Sequential scan vs Index scan

**Red Flags:**
- 🔴 Sequential Scan on large tables
- 🔴 High row counts
- 🔴 Nested loops with large datasets
- 🔴 Missing index warnings

### Index Types

#### 1. Clustered Index
- **Definition**: Determines physical order of data
- **One per table** (usually PRIMARY KEY)
- **Best for**: Range queries, sorting

#### 2. Non-Clustered Index
- **Definition**: Separate structure pointing to data
- **Multiple per table**
- **Best for**: Lookups, filtering

#### 3. Composite Index
- **Definition**: Index on multiple columns
- **Column order matters!**
- **Best for**: Multi-column WHERE clauses

```sql
-- Composite index example
CREATE INDEX idx_customer_date ON orders(customer_id, order_date);

-- This uses the index:
SELECT * FROM orders WHERE customer_id = 123 AND order_date > '2024-01-01';

-- This might not use it efficiently:
SELECT * FROM orders WHERE order_date > '2024-01-01';
```

### When Indexes Help

✅ **Good for:**
- WHERE clauses
- JOIN conditions
- ORDER BY
- GROUP BY (sometimes)
- Foreign keys

❌ **Not helpful for:**
- Small tables (< 1000 rows)
- Columns with low selectivity (e.g., boolean with 50/50 split)
- Frequent INSERT/UPDATE/DELETE operations
- Very wide tables (many columns)

### Performance Anti-Patterns

#### 1. SELECT *
```sql
-- ❌ BAD: Fetches all columns
SELECT * FROM large_table;

-- ✅ GOOD: Only needed columns
SELECT id, name, email FROM large_table;
```

#### 2. Wildcard Joins
```sql
-- ❌ BAD: Cartesian product risk
SELECT * FROM table1, table2 WHERE table1.id = table2.id;

-- ✅ GOOD: Explicit JOIN
SELECT * FROM table1 
INNER JOIN table2 ON table1.id = table2.id;
```

#### 3. Functions in WHERE Clauses
```sql
-- ❌ BAD: Can't use index
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- ✅ GOOD: Index-friendly
SELECT * FROM orders WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01';
```

#### 4. OR Conditions
```sql
-- ❌ BAD: Often prevents index usage
SELECT * FROM products WHERE category = 'A' OR category = 'B';

-- ✅ GOOD: Use IN or UNION
SELECT * FROM products WHERE category IN ('A', 'B');
```

#### 5. Subqueries vs JOINs
```sql
-- ❌ BAD: Correlated subquery (runs for each row)
SELECT * FROM orders o1 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders o2 WHERE o2.customer_id = o1.customer_id);

-- ✅ GOOD: JOIN with CTE
WITH avg_amounts AS (
    SELECT customer_id, AVG(total_amount) as avg_amount
    FROM orders
    GROUP BY customer_id
)
SELECT o.* FROM orders o
INNER JOIN avg_amounts a ON o.customer_id = a.customer_id
WHERE o.total_amount > a.avg_amount;
```

---

## 💻 Hands-On Exercises (1.5-2 hours)

### Exercise 1: Compare Slow vs Fast Queries

**Task:** Use EXPLAIN to analyze query performance.

**Setup:**
```sql
-- Create a large table (1M+ rows)
CREATE TABLE large_orders AS
SELECT 
    generate_series(1, 1000000) as order_id,
    (random() * 10000)::int as customer_id,
    '2024-01-01'::date + (random() * 365)::int as order_date,
    (random() * 1000 + 10)::decimal(10,2) as amount
FROM generate_series(1, 1000000);
```

**Your Tasks:**

1. Run EXPLAIN on a query without index:
```sql
EXPLAIN ANALYZE 
SELECT * FROM large_orders WHERE customer_id = 5000;
```

2. Create an index:
```sql
CREATE INDEX idx_customer_id ON large_orders(customer_id);
```

3. Run EXPLAIN again and compare:
```sql
EXPLAIN ANALYZE 
SELECT * FROM large_orders WHERE customer_id = 5000;
```

**Questions:**
- What's the difference in execution time?
- What changed in the execution plan?
- How many rows were scanned?

[📝 Solution](./solutions/exercise_01_solution.sql)

---

### Exercise 2: Add and Test Different Index Types

**Task:** Create and test various index configurations.

**Setup:** Use the `large_orders` table from Exercise 1.

**Your Tasks:**

1. Create a composite index on (customer_id, order_date):
```sql
CREATE INDEX idx_customer_date ON large_orders(customer_id, order_date);
```

2. Test these queries and explain which indexes they use:
```sql
-- Query A
SELECT * FROM large_orders 
WHERE customer_id = 5000 AND order_date > '2024-06-01';

-- Query B
SELECT * FROM large_orders 
WHERE order_date > '2024-06-01';

-- Query C
SELECT * FROM large_orders 
WHERE customer_id = 5000 
ORDER BY order_date DESC;
```

3. Create a partial index (index on subset of data):
```sql
-- Index only on recent orders
CREATE INDEX idx_recent_orders ON large_orders(customer_id) 
WHERE order_date > '2024-06-01';
```

[📝 Solution](./solutions/exercise_02_solution.sql)

---

### Exercise 3: Optimize Queries from Large Tables

**Task:** Optimize these slow queries.

**Setup:**
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    created_at TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2)
);

-- Insert 100K products, 1M order items
```

**Slow Queries to Optimize:**

1. **Query 1:** Find all products in a category
```sql
-- Current (slow)
SELECT * FROM products WHERE LOWER(category) = 'electronics';
```

2. **Query 2:** Count orders per product
```sql
-- Current (slow)
SELECT 
    p.product_name,
    COUNT(oi.order_item_id) as order_count
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;
```

3. **Query 3:** Find expensive products
```sql
-- Current (slow)
SELECT * FROM products 
WHERE price > (SELECT AVG(price) FROM products);
```

[📝 Solution](./solutions/exercise_03_solution.sql)

---

### Exercise 4: Rewrite Heavy Joins/Aggregations

**Task:** Optimize complex queries with multiple joins.

**Setup:**
```sql
CREATE TABLE customers (customer_id INT PRIMARY KEY, name VARCHAR(100));
CREATE TABLE orders (order_id INT PRIMARY KEY, customer_id INT, order_date DATE);
CREATE TABLE order_items (order_item_id INT PRIMARY KEY, order_id INT, product_id INT, quantity INT);
CREATE TABLE products (product_id INT PRIMARY KEY, price DECIMAL(10,2));
```

**Slow Query to Optimize:**
```sql
-- Find top 10 customers by total revenue
SELECT 
    c.customer_id,
    c.name,
    SUM(oi.quantity * p.price) as total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_revenue DESC
LIMIT 10;
```

**Your Task:** 
- Analyze with EXPLAIN
- Add appropriate indexes
- Rewrite if needed
- Compare performance

[📝 Solution](./solutions/exercise_04_solution.sql)

---

## 🎯 Final Challenge: Fix 6 Awful Queries

**Objective:** Optimize 6 poorly written queries to production-ready performance.

### The Challenge

You're given 6 queries that are causing performance issues. Your task is to:

1. **Analyze** each query using EXPLAIN
2. **Identify** the performance problems
3. **Optimize** the queries (rewrite, add indexes, etc.)
4. **Measure** the improvement
5. **Document** your changes

### The 6 Queries

All queries use this database schema:
- `users` (1M rows): user_id, email, registration_date, status
- `orders` (5M rows): order_id, user_id, order_date, total_amount
- `products` (50K rows): product_id, name, category, price
- `order_items` (20M rows): order_item_id, order_id, product_id, quantity, price

[📊 Challenge Queries](./challenge_queries.sql)  
[💡 Optimization Guide](./optimization_guide.md)

### Deliverable

Submit a document with:
1. **Original query** + EXPLAIN output
2. **Problems identified** (list all issues)
3. **Optimized query** + EXPLAIN output
4. **Performance improvement** (time/cost reduction)
5. **Indexes created** (if any)
6. **Explanation** of changes

**Evaluation Criteria:**
- ✅ Correct identification of problems
- ✅ Effective optimization strategies
- ✅ Significant performance improvement
- ✅ Proper index usage
- ✅ Query correctness maintained

---

## 📚 Additional Resources

- [PostgreSQL EXPLAIN Documentation](https://www.postgresql.org/docs/current/sql-explain.html)
- [Use The Index, Luke!](https://use-the-index-luke.com/)
- [SQL Performance Cheat Sheet](./cheat_sheet.md)

---

## ✅ Session Checklist

- [ ] Completed Exercise 1: Slow vs Fast Queries
- [ ] Completed Exercise 2: Different Index Types
- [ ] Completed Exercise 3: Optimize Large Table Queries
- [ ] Completed Exercise 4: Rewrite Heavy Joins
- [ ] Completed Final Challenge: Fixed 6 Awful Queries
- [ ] Reviewed all solutions
- [ ] Understand execution plans and indexing

---

**Next Session:** [Session 3 - SQL for Data Analysis + BI](../Session_03_Data_Analysis_BI/)


# Session 1: Advanced SQL Analytics + Window Functions Masterclass

## 🚀 Start Here: Step-by-Step Tutorial

**New to window functions?** Start with the step-by-step guide:
👉 **[STEP_BY_STEP.md](./STEP_BY_STEP.md)** - Simple, beginner-friendly tutorial

## 📋 Session Overview

**Duration:** 3 hours  
**Focus:** Master window functions for advanced analytics

---

## 🎯 Learning Objectives

By the end of this session, you will:
- Understand window functions and their syntax
- Use partitioning and framing effectively
- Apply ranking functions (RANK, DENSE_RANK, NTILE)
- Perform time-series analysis with LAG/LEAD
- Calculate running totals and moving averages
- Build comprehensive analytical reports

---

## 📖 Mini-Lecture (20-30 min)

### What are Window Functions?

Window functions perform calculations across a set of table rows that are related to the current row. Unlike aggregate functions, they don't collapse rows—they return a value for each row.

**Basic Syntax:**
```sql
function_name() OVER (
    [PARTITION BY column1, column2, ...]
    [ORDER BY column1 [ASC|DESC], ...]
    [ROWS BETWEEN start AND end]
)
```

### Key Concepts

#### 1. PARTITION BY
Divides the result set into partitions. The window function is applied to each partition separately.

```sql
-- Example: Rank products within each category
SELECT 
    product_name,
    category,
    price,
    RANK() OVER (PARTITION BY category ORDER BY price DESC) as rank_in_category
FROM products;
```

#### 2. ORDER BY in Window Functions
Determines the order of rows within each partition.

#### 3. Window Frames (ROWS BETWEEN)
Defines which rows to include in the calculation relative to the current row.

**Frame Options:**
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` - All rows from start to current
- `ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING` - 3 rows before and after
- `ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING` - Current to end

```sql
-- 7-day moving average
SELECT 
    date,
    sales,
    AVG(sales) OVER (
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7d
FROM daily_sales;
```

### Window Function Categories

#### Ranking Functions
- **RANK()**: Gaps in ranking when ties occur (1, 2, 2, 4)
- **DENSE_RANK()**: No gaps (1, 2, 2, 3)
- **ROW_NUMBER()**: Unique sequential numbers (1, 2, 3, 4)
- **NTILE(n)**: Divides rows into n groups

#### Value Functions
- **LAG(column, n)**: Value from n rows before
- **LEAD(column, n)**: Value from n rows ahead
- **FIRST_VALUE(column)**: First value in partition
- **LAST_VALUE(column)**: Last value in partition

#### Aggregate Functions (as Window Functions)
- **SUM()**, **AVG()**, **COUNT()**, **MAX()**, **MIN()**

---

## 💻 Hands-On Exercises (1.5-2 hours)

### Exercise 1: Running Totals per Customer

**Task:** Calculate cumulative sales for each customer over time.

**Setup:**
```sql
-- Create sample data
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);

INSERT INTO customer_orders VALUES
(1, 101, '2024-01-05', 150.00),
(2, 101, '2024-01-15', 200.00),
(3, 102, '2024-01-10', 75.00),
(4, 101, '2024-02-01', 300.00),
(5, 102, '2024-02-05', 120.00),
(6, 103, '2024-01-20', 500.00),
(7, 101, '2024-02-20', 180.00),
(8, 102, '2024-03-01', 250.00);
```

**Your Task:** Write a query that shows:
- Customer ID
- Order Date
- Order Amount
- Running Total (cumulative sum per customer)

**Expected Output:**
```
customer_id | order_date | order_amount | running_total
------------|------------|--------------|--------------
101         | 2024-01-05 | 150.00       | 150.00
101         | 2024-01-15 | 200.00       | 350.00
101         | 2024-02-01 | 300.00       | 650.00
101         | 2024-02-20 | 180.00       | 830.00
102         | 2024-01-10 | 75.00        | 75.00
...
```

[📝 Solution](./solutions/exercise_01_solution.sql)

---

### Exercise 2: Month-over-Month Comparison

**Task:** Compare each month's sales to the previous month.

**Setup:**
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

**Your Task:** Write a query showing:
- Current month
- Current sales
- Previous month sales
- Absolute change
- Percentage change

[📝 Solution](./solutions/exercise_02_solution.sql)

---

### Exercise 3: Top 3 Products per Category

**Task:** Find the top 3 best-selling products in each category.

**Setup:**
```sql
CREATE TABLE product_sales (
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    units_sold INT
);

INSERT INTO product_sales VALUES
(1, 'Laptop Pro', 'Electronics', 150),
(2, 'Wireless Mouse', 'Electronics', 300),
(3, 'Keyboard', 'Electronics', 200),
(4, 'Monitor', 'Electronics', 120),
(5, 'T-Shirt', 'Clothing', 500),
(6, 'Jeans', 'Clothing', 350),
(7, 'Jacket', 'Clothing', 180),
(8, 'Shoes', 'Clothing', 400),
(9, 'Hat', 'Clothing', 250);
```

**Your Task:** Use window functions to rank and filter top 3.

[📝 Solution](./solutions/exercise_03_solution.sql)

---

### Exercise 4: 7-Day Moving Average

**Task:** Calculate a 7-day moving average for daily sales.

**Setup:**
```sql
CREATE TABLE daily_sales (
    sale_date DATE,
    sales_amount DECIMAL(10,2)
);

-- Generate 30 days of data
INSERT INTO daily_sales 
SELECT 
    '2024-01-01'::DATE + (generate_series(0, 29) || ' days')::INTERVAL as sale_date,
    (RANDOM() * 1000 + 500)::DECIMAL(10,2) as sales_amount;
```

**Your Task:** Calculate moving average using ROWS BETWEEN frame.

[📝 Solution](./solutions/exercise_04_solution.sql)

---

## 🎯 Final Challenge: Sales Insights Report

**Objective:** Build a comprehensive "Sales Insights Report" using ONLY window functions.

### Requirements

Create a single query (or view) that provides:

1. **Top Customers Analysis**
   - Customer ID, total lifetime value
   - Rank within their region
   - Percentile (NTILE) of customer value

2. **Sales Trends**
   - Month-over-month growth rate
   - 3-month moving average
   - Identify months with declining sales (flag)

3. **Product Performance**
   - Top 3 products per category by revenue
   - Products showing declining sales (compare last 30 days vs previous 30 days)

4. **Customer Behavior**
   - Days since last purchase per customer
   - Customers at risk of churn (no purchase in 60+ days)

### Sample Data

Use the provided [sample_data.sql](./data/sample_data.sql) file which includes:
- `customers` table
- `orders` table
- `order_items` table
- `products` table

### Deliverable

Submit:
1. SQL query/view that generates the complete report
2. Screenshot or export of the results
3. Brief explanation of each window function used

**Evaluation Criteria:**
- ✅ Correct use of window functions
- ✅ Proper partitioning and framing
- ✅ Query performance and readability
- ✅ Business insights derived

[📊 Sample Data](./data/sample_data.sql)  
[💡 Challenge Hints](./challenge_hints.md)

---

## 📚 Additional Resources

- [PostgreSQL Window Functions Documentation](https://www.postgresql.org/docs/current/tutorial-window.html)
- [SQL Window Functions Cheat Sheet](./cheat_sheet.md)

---

## ✅ Session Checklist

- [ ] Completed Exercise 1: Running Totals
- [ ] Completed Exercise 2: Month-over-Month Comparison
- [ ] Completed Exercise 3: Top 3 Products per Category
- [ ] Completed Exercise 4: 7-Day Moving Average
- [ ] Completed Final Challenge: Sales Insights Report
- [ ] Reviewed all solutions
- [ ] Understood window function concepts

---

**Next Session:** [Session 2 - SQL Optimization + Indexes](../Session_02_Optimization_Indexes/)


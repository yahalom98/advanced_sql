# Session 1: Window Functions - Exercises

## Exercise 1: Running Totals per Customer

### Setup
```sql
USE sql_course;

CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2)
);

INSERT INTO customer_orders (customer_id, order_date, order_amount) VALUES
(1, '2024-01-05', 150.00),
(1, '2024-01-15', 200.00),
(2, '2024-01-10', 75.00),
(1, '2024-02-01', 300.00),
(2, '2024-02-05', 120.00),
(3, '2024-01-20', 500.00),
(1, '2024-02-20', 180.00),
(2, '2024-03-01', 250.00);
```

### Your Task
Write a query that shows:
- Customer ID
- Order Date
- Order Amount
- **Running Total** (cumulative sum per customer, ordered by date)

### Expected Output
```
customer_id | order_date | order_amount | running_total
------------|------------|--------------|--------------
1           | 2024-01-05 | 150.00       | 150.00
1           | 2024-01-15 | 200.00       | 350.00
1           | 2024-02-01 | 300.00       | 650.00
1           | 2024-02-20 | 180.00       | 830.00
2           | 2024-01-10 | 75.00        | 75.00
2           | 2024-02-05 | 120.00       | 195.00
2           | 2024-03-01 | 250.00       | 445.00
3           | 2024-01-20 | 500.00       | 500.00
```

### 💡 Hints
- Use `SUM()` as a window function
- You'll need `PARTITION BY` to separate each customer
- Use `ORDER BY` to calculate in date order
- The running total should reset for each customer

---

## Exercise 2: Month-over-Month Comparison

### Setup
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

### Your Task
Write a query showing:
- Current month
- Current sales
- Previous month sales
- Absolute change (current - previous)
- Percentage change ((current - previous) / previous * 100)

### Expected Output
```
month       | current_sales | previous_month | absolute_change | percent_change
------------|---------------|----------------|-----------------|---------------
2024-01-01  | 50000.00      | NULL           | NULL            | NULL
2024-02-01  | 55000.00      | 50000.00       | 5000.00         | 10.00
2024-03-01  | 48000.00      | 55000.00       | -7000.00        | -12.73
2024-04-01  | 62000.00      | 48000.00       | 14000.00        | 29.17
2024-05-01  | 58000.00      | 62000.00       | -4000.00        | -6.45
```

### 💡 Hints
- Use `LAG()` to get the previous row's value
- `LAG(column, 1)` gets the value from 1 row before
- You'll need `ORDER BY month` in the window function
- For percentage: `(current - previous) / previous * 100`
- Use `ROUND()` to format the percentage

---

## Exercise 3: Top 3 Products per Category

### Setup
```sql
CREATE TABLE product_sales (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    units_sold INT
);

INSERT INTO product_sales (product_name, category, units_sold) VALUES
('Laptop Pro', 'Electronics', 150),
('Wireless Mouse', 'Electronics', 300),
('Keyboard', 'Electronics', 200),
('Monitor', 'Electronics', 120),
('T-Shirt', 'Clothing', 500),
('Jeans', 'Clothing', 350),
('Jacket', 'Clothing', 180),
('Shoes', 'Clothing', 400),
('Hat', 'Clothing', 250);
```

### Your Task
Find the top 3 best-selling products in each category by units sold.

### Expected Output
```
category    | product_name   | units_sold | rank_in_category
------------|----------------|------------|-----------------
Electronics | Wireless Mouse | 300        | 1
Electronics | Keyboard       | 200        | 2
Electronics | Laptop Pro     | 150        | 3
Clothing    | T-Shirt        | 500        | 1
Clothing    | Shoes          | 400        | 2
Clothing    | Jeans          | 350        | 3
```

### 💡 Hints
- Use `RANK()` or `DENSE_RANK()` window function
- `PARTITION BY category` to rank within each category
- `ORDER BY units_sold DESC` to rank from highest to lowest
- Use a subquery or CTE to filter to top 3
- Filter with `WHERE rank <= 3`

---

## Exercise 4: 7-Day Moving Average

### Setup
```sql
CREATE TABLE daily_sales (
    sale_date DATE,
    sales_amount DECIMAL(10,2)
);

INSERT INTO daily_sales VALUES
('2024-01-01', 500.00),
('2024-01-02', 520.00),
('2024-01-03', 480.00),
('2024-01-04', 550.00),
('2024-01-05', 600.00),
('2024-01-06', 580.00),
('2024-01-07', 620.00),
('2024-01-08', 590.00),
('2024-01-09', 610.00),
('2024-01-10', 630.00);
```

### Your Task
Calculate a 7-day moving average for daily sales.

### Expected Output
```
sale_date  | sales_amount | moving_avg_7d
-----------|--------------|--------------
2024-01-01 | 500.00       | 500.00
2024-01-02 | 520.00       | 510.00
2024-01-03 | 480.00       | 500.00
2024-01-04 | 550.00       | 512.50
2024-01-05 | 600.00       | 530.00
2024-01-06 | 580.00       | 538.33
2024-01-07 | 620.00       | 550.00
2024-01-08 | 590.00       | 562.86
2024-01-09 | 610.00       | 581.43
2024-01-10 | 630.00       | 600.00
```

### 💡 Hints
- Use `AVG()` as a window function
- Use `ROWS BETWEEN` to define the window frame
- For 7-day average: `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`
- This means: current row + 6 rows before = 7 rows total
- Don't forget `ORDER BY sale_date`

---

## Exercise 5: Customer Ranking and Percentiles

### Setup
Use the `customer_orders` table from Exercise 1.

### Your Task
For each customer, show:
- Customer ID
- Total amount spent (lifetime value)
- Rank among all customers (by total spent)
- Percentile (divide customers into 4 groups using NTILE)

### Expected Output
```
customer_id | total_spent | customer_rank | percentile_group
------------|-------------|---------------|------------------
3           | 500.00      | 1             | 1
1           | 830.00      | 2             | 1
2           | 445.00      | 3             | 2
```

### 💡 Hints
- First, calculate total spent per customer (use CTE or subquery)
- Use `RANK()` to rank customers by total spent
- Use `NTILE(4)` to divide into 4 percentile groups
- Order by total spent DESC for ranking

---

## Exercise 6: Compare Current Row to First and Last

### Setup
Use the `monthly_sales` table from Exercise 2.

### Your Task
Show for each month:
- Month
- Sales
- First month sales (for comparison)
- Last month sales (for comparison)
- Percentage change from first month

### Expected Output
```
month       | sales     | first_month | last_month | pct_from_first
------------|-----------|-------------|------------|---------------
2024-01-01  | 50000.00  | 50000.00    | 58000.00   | 0.00
2024-02-01  | 55000.00  | 50000.00    | 58000.00   | 10.00
2024-03-01  | 48000.00  | 50000.00    | 58000.00   | -4.00
2024-04-01  | 62000.00  | 50000.00    | 58000.00   | 24.00
2024-05-01  | 58000.00  | 50000.00    | 58000.00   | 16.00
```

### 💡 Hints
- Use `FIRST_VALUE()` to get the first value
- Use `LAST_VALUE()` to get the last value
- For `LAST_VALUE()`, you might need `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`
- Calculate percentage: `(current - first) / first * 100`

---

## ✅ Practice Tips

1. **Try each exercise** before looking at solutions
2. **Experiment** with different window functions
3. **Check your results** against expected output
4. **Understand** why each solution works
5. **Practice** with your own data

---

**Ready for solutions?** Check the [SOLUTIONS.md](./SOLUTIONS.md) file!


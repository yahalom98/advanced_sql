# Session 1: Window Functions - Solutions with Explanations

## Exercise 1: Running Totals per Customer

### Solution
```sql
SELECT 
    customer_id,
    order_date,
    order_amount,
    SUM(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as running_total
FROM customer_orders
ORDER BY customer_id, order_date;
```

### Explanation
- **`SUM(order_amount) OVER (...)`**: This is a window function that calculates a sum, but keeps all rows instead of collapsing them like regular `SUM()` with `GROUP BY`
- **`PARTITION BY customer_id`**: This divides the data into separate groups for each customer. The running total resets for each customer
- **`ORDER BY order_date`**: This determines the order in which the sum is calculated. It processes rows in date order, so each row gets the sum of all previous rows (for that customer) plus the current row
- **Result**: Each row shows the cumulative total up to that point for each customer

### Why This Works
Without `PARTITION BY`, you'd get one running total across all customers. With it, each customer gets their own running total that starts fresh.

---

## Exercise 2: Month-over-Month Comparison

### Solution
```sql
SELECT 
    month,
    total_sales as current_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) as previous_month,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY month) as absolute_change,
    ROUND(
        ((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
         / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 
        2
    ) as percent_change
FROM monthly_sales
ORDER BY month;
```

### Explanation
- **`LAG(total_sales, 1)`**: Gets the value from 1 row before the current row. The `1` means "1 row back"
- **`OVER (ORDER BY month)`**: Orders the rows by month so `LAG` knows which row is "previous"
- **Absolute change**: Simply subtract previous from current
- **Percentage change**: Formula is `(new - old) / old * 100`
  - Example: (55000 - 50000) / 50000 * 100 = 10%
- **`ROUND(..., 2)`**: Rounds to 2 decimal places
- **First row**: Will have `NULL` for previous_month because there's no row before it

### Why This Works
`LAG()` looks backward in the ordered result set. Since we order by month, it gets the previous month's value. This is perfect for time-series comparisons.

---

## Exercise 3: Top 3 Products per Category

### Solution
```sql
SELECT 
    category,
    product_name,
    units_sold,
    rank_in_category
FROM (
    SELECT 
        category,
        product_name,
        units_sold,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY units_sold DESC
        ) as rank_in_category
    FROM product_sales
) ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
```

### Explanation
- **Inner query**: Uses `RANK()` to assign ranks within each category
  - `PARTITION BY category`: Separates Electronics and Clothing
  - `ORDER BY units_sold DESC`: Ranks from highest to lowest
  - `RANK()`: Assigns 1, 2, 3, etc. (with gaps if there are ties)
- **Outer query**: Filters to only show ranks 1, 2, and 3
- **Why subquery?**: You can't use `WHERE` with window functions directly, so we need a subquery

### Alternative: Using DENSE_RANK()
```sql
-- If you want no gaps in ranking (1, 2, 2, 3 instead of 1, 2, 2, 4)
DENSE_RANK() OVER (PARTITION BY category ORDER BY units_sold DESC)
```

### Why This Works
Window functions calculate values, but you can't filter by them in the same query level. The subquery calculates the rank, then the outer query filters.

---

## Exercise 4: 7-Day Moving Average

### Solution
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

### Explanation
- **`AVG(sales_amount) OVER (...)`**: Calculates average as a window function
- **`ORDER BY sale_date`**: Orders rows by date (required for ROWS BETWEEN)
- **`ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`**: Defines the window frame
  - `6 PRECEDING`: 6 rows before the current row
  - `CURRENT ROW`: The current row
  - Total: 7 rows (6 before + current = 7)
- **First 6 rows**: Will have fewer than 7 rows to average, so the average uses whatever rows are available

### Why This Works
`ROWS BETWEEN` creates a sliding window. For each row, it looks at the current row plus the 6 rows before it, calculates the average, and moves to the next row. This creates a smooth trend line.

### Frame Options Reference
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`: All rows from start to current (running total)
- `ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING`: 3 before, current, 3 after (7 rows total)
- `ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING`: Current to end

---

## Exercise 5: Customer Ranking and Percentiles

### Solution
```sql
WITH customer_totals AS (
    SELECT 
        customer_id,
        SUM(order_amount) as total_spent
    FROM customer_orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) as customer_rank,
    NTILE(4) OVER (ORDER BY total_spent DESC) as percentile_group
FROM customer_totals
ORDER BY customer_rank;
```

### Explanation
- **CTE (Common Table Expression)**: `WITH customer_totals AS (...)` creates a temporary result set
  - First calculates total spent per customer using regular `SUM()` and `GROUP BY`
- **Main query**: Uses window functions on the aggregated data
  - `RANK() OVER (ORDER BY total_spent DESC)`: Ranks customers from highest to lowest spender
  - `NTILE(4) OVER (ORDER BY total_spent DESC)`: Divides customers into 4 equal groups
    - Group 1: Top 25% of customers
    - Group 2: Next 25%
    - Group 3: Next 25%
    - Group 4: Bottom 25%

### Why This Works
You can't use window functions and `GROUP BY` in the same way, so we first aggregate with a CTE, then apply window functions. `NTILE(4)` creates quartiles - perfect for customer segmentation.

---

## Exercise 6: Compare Current Row to First and Last

### Solution
```sql
SELECT 
    month,
    total_sales as sales,
    FIRST_VALUE(total_sales) OVER (ORDER BY month) as first_month,
    LAST_VALUE(total_sales) OVER (
        ORDER BY month 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_month,
    ROUND(
        ((total_sales - FIRST_VALUE(total_sales) OVER (ORDER BY month)) 
         / FIRST_VALUE(total_sales) OVER (ORDER BY month)) * 100, 
        2
    ) as pct_from_first
FROM monthly_sales
ORDER BY month;
```

### Explanation
- **`FIRST_VALUE(total_sales) OVER (ORDER BY month)`**: Gets the first value when ordered by month
  - This is the January sales (50000) for all rows
- **`LAST_VALUE(...)`**: Gets the last value, but needs special frame specification
  - Without the frame, `LAST_VALUE` only looks up to the current row
  - `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` makes it look at all rows
  - This gives us the May sales (58000) for all rows
- **Percentage calculation**: `(current - first) / first * 100`
  - Example: (55000 - 50000) / 50000 * 100 = 10%

### Why This Works
`FIRST_VALUE` and `LAST_VALUE` need `ORDER BY` to know which is first/last. For `LAST_VALUE`, you must specify the full frame, otherwise it only sees up to the current row (which would just be the current value).

---

## Key Takeaways

1. **Window functions keep all rows** - Unlike `GROUP BY` which collapses rows
2. **PARTITION BY** - Separates data into groups (like GROUP BY but keeps rows)
3. **ORDER BY in window** - Determines calculation order and frame boundaries
4. **ROWS BETWEEN** - Defines which rows to include in the calculation
5. **LAG/LEAD** - Look backward/forward in ordered data
6. **RANK vs DENSE_RANK** - RANK has gaps, DENSE_RANK doesn't
7. **NTILE** - Divides data into equal groups (percentiles, quartiles, etc.)

---

## Common Mistakes to Avoid

1. ❌ Forgetting `ORDER BY` in window function (needed for LAG, LEAD, frames)
2. ❌ Using window function in WHERE clause (use subquery instead)
3. ❌ Not specifying frame for LAST_VALUE (won't work correctly)
4. ❌ Mixing window functions with GROUP BY incorrectly (use CTE)
5. ❌ Using RANK when you want DENSE_RANK (or vice versa)

---

**Great job completing these exercises!** 🎉 Try creating your own window function queries now!


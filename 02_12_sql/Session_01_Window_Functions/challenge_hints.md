# Final Challenge Hints: Sales Insights Report

## 💡 Hints for Each Requirement

### 1. Top Customers Analysis

**Hint:** Use multiple window functions:
- `SUM()` with `PARTITION BY region` for regional totals
- `RANK()` or `DENSE_RANK()` for ranking
- `NTILE(4)` or `NTILE(10)` for quartiles/deciles

```sql
-- Structure to get you started
SELECT 
    customer_id,
    total_lifetime_value,
    region,
    RANK() OVER (PARTITION BY region ORDER BY total_lifetime_value DESC) as rank_in_region,
    NTILE(4) OVER (ORDER BY total_lifetime_value DESC) as value_quartile
FROM (
    -- Calculate lifetime value per customer
    SELECT ...
) customer_values;
```

### 2. Sales Trends

**Hint:** Use LAG for month-over-month, and AVG with ROWS BETWEEN for moving average.

```sql
-- Month-over-month growth
SELECT 
    month,
    total_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) as prev_month,
    -- Calculate growth rate
    -- Flag declining months
FROM monthly_sales;

-- 3-month moving average
SELECT 
    month,
    total_sales,
    AVG(total_sales) OVER (
        ORDER BY month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3m
FROM monthly_sales;
```

### 3. Product Performance

**Hint:** Combine RANK with LAG to compare periods.

```sql
-- Top 3 per category
SELECT * FROM (
    SELECT 
        category,
        product_name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) as rank
    FROM product_revenue
) WHERE rank <= 3;

-- Compare last 30 days vs previous 30 days
-- Use LAG or separate CTEs for different time periods
```

### 4. Customer Behavior

**Hint:** Use MAX() with window function and date arithmetic.

```sql
-- Days since last purchase
SELECT 
    customer_id,
    MAX(order_date) OVER (PARTITION BY customer_id) as last_purchase_date,
    CURRENT_DATE - MAX(order_date) OVER (PARTITION BY customer_id) as days_since_purchase,
    CASE 
        WHEN CURRENT_DATE - MAX(order_date) OVER (PARTITION BY customer_id) > 60 
        THEN 'At Risk'
        ELSE 'Active'
    END as churn_status
FROM orders;
```

## 🎯 Putting It All Together

Consider using CTEs to organize your query:

```sql
WITH customer_lifetime_value AS (
    -- Calculate lifetime value
),
top_customers AS (
    -- Rank customers
),
monthly_trends AS (
    -- Calculate trends
),
product_performance AS (
    -- Product analysis
),
customer_churn AS (
    -- Churn analysis
)
SELECT 
    -- Combine all insights
FROM ...
```

## ✅ Checklist

- [ ] All requirements use window functions (no subqueries for ranking/aggregation)
- [ ] Proper PARTITION BY clauses
- [ ] Appropriate window frames (ROWS BETWEEN)
- [ ] Results are meaningful and accurate
- [ ] Query is readable and well-commented

Good luck! 🚀


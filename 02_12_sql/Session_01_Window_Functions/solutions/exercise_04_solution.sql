-- Exercise 4 Solution: 7-Day Moving Average

-- Note: For PostgreSQL, use generate_series. For other DBs, adjust accordingly.

-- First, ensure we have data (if using PostgreSQL)
-- INSERT INTO daily_sales 
-- SELECT 
--     '2024-01-01'::DATE + (generate_series(0, 29) || ' days')::INTERVAL as sale_date,
--     (RANDOM() * 1000 + 500)::DECIMAL(10,2) as sales_amount;

-- Calculate 7-day moving average
SELECT 
    sale_date,
    sales_amount,
    AVG(sales_amount) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7d,
    -- Bonus: Also show count of days in average (for first 6 days)
    COUNT(*) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as days_in_avg
FROM daily_sales
ORDER BY sale_date;

-- Enhanced version with min/max in window
SELECT 
    sale_date,
    sales_amount,
    AVG(sales_amount) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7d,
    MIN(sales_amount) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as min_7d,
    MAX(sales_amount) OVER (
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as max_7d
FROM daily_sales
ORDER BY sale_date;


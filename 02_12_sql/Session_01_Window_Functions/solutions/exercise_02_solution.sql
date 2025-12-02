-- Exercise 2 Solution: Month-over-Month Comparison

SELECT 
    month,
    total_sales as current_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) as previous_month_sales,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY month) as absolute_change,
    ROUND(
        ((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
         / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 
        2
    ) as percent_change
FROM monthly_sales
ORDER BY month;

-- Enhanced version with growth indicator
SELECT 
    month,
    total_sales as current_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) as previous_month_sales,
    total_sales - LAG(total_sales, 1) OVER (ORDER BY month) as absolute_change,
    ROUND(
        ((total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
         / LAG(total_sales, 1) OVER (ORDER BY month)) * 100, 
        2
    ) as percent_change,
    CASE 
        WHEN total_sales > LAG(total_sales, 1) OVER (ORDER BY month) THEN '📈 Growth'
        WHEN total_sales < LAG(total_sales, 1) OVER (ORDER BY month) THEN '📉 Decline'
        ELSE '➡️ Stable'
    END as trend
FROM monthly_sales
ORDER BY month;


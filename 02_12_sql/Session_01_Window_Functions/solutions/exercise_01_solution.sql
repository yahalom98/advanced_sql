-- Exercise 1 Solution: Running Totals per Customer

SELECT 
    customer_id,
    order_date,
    order_amount,
    SUM(order_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total
FROM customer_orders
ORDER BY customer_id, order_date;

-- Alternative (simpler) - ORDER BY in window function handles the frame
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


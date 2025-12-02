-- Final Challenge: 6 Awful Queries to Optimize
-- Database: users (1M), orders (5M), products (50K), order_items (20M)

-- ============================================
-- QUERY 1: The SELECT * Monster
-- ============================================
-- Problem: Fetches all columns, no indexes, full table scan
SELECT * 
FROM orders 
WHERE YEAR(order_date) = 2024 
ORDER BY order_date DESC;

-- ============================================
-- QUERY 2: The N+1 Subquery
-- ============================================
-- Problem: Correlated subquery runs for each row
SELECT 
    u.user_id,
    u.email,
    (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) as order_count,
    (SELECT SUM(total_amount) FROM orders o WHERE o.user_id = u.user_id) as total_spent
FROM users u
WHERE u.status = 'active';

-- ============================================
-- QUERY 3: The Cartesian Explosion
-- ============================================
-- Problem: Implicit cross join, no proper join condition
SELECT 
    u.email,
    o.order_id,
    o.order_date,
    p.name as product_name
FROM users u, orders o, order_items oi, products p
WHERE u.user_id = o.user_id 
AND o.order_id = oi.order_id 
AND oi.product_id = p.product_id
AND u.registration_date > '2023-01-01';

-- ============================================
-- QUERY 4: The Function in WHERE
-- ============================================
-- Problem: Function prevents index usage
SELECT 
    product_id,
    name,
    price
FROM products
WHERE LOWER(category) = 'electronics'
AND SUBSTRING(name, 1, 5) = 'Apple';

-- ============================================
-- QUERY 5: The Unnecessary DISTINCT
-- ============================================
-- Problem: DISTINCT with GROUP BY, inefficient aggregation
SELECT DISTINCT
    u.user_id,
    u.email,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(DISTINCT o.total_amount) as total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.registration_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY u.user_id, u.email
HAVING COUNT(DISTINCT o.order_id) > 5;

-- ============================================
-- QUERY 6: The Window Function Overkill
-- ============================================
-- Problem: Window function on entire table, no partition, expensive sort
SELECT 
    o.order_id,
    o.user_id,
    o.order_date,
    o.total_amount,
    ROW_NUMBER() OVER (ORDER BY o.total_amount DESC) as rank_by_amount,
    AVG(o.total_amount) OVER () as avg_order_amount
FROM orders o
WHERE o.order_date >= '2024-01-01'
ORDER BY o.total_amount DESC
LIMIT 100;

-- ============================================
-- YOUR TASK:
-- 1. Run EXPLAIN ANALYZE on each query
-- 2. Identify all performance issues
-- 3. Optimize each query
-- 4. Create necessary indexes
-- 5. Measure improvement
-- ============================================


-- A/B Test Data for Final Challenge
-- Test: New checkout flow (B) vs Existing checkout flow (A)
-- MySQL Version

USE sql_course;

-- Create experiments table
CREATE TABLE experiments (
    user_id INT,
    experiment_name VARCHAR(50),
    variant VARCHAR(10), -- 'A' (control) or 'B' (treatment)
    assigned_date DATE
);

-- Create events table
CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_type VARCHAR(50),
    event_date TIMESTAMP
);

-- Create purchases table
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    purchase_date TIMESTAMP,
    amount DECIMAL(10,2)
);

-- Insert experiment assignments (2 weeks, ~2000 users)
-- Variant A: 1000 users
-- Variant B: 1000 users
-- Note: MySQL doesn't have generate_series, so we'll insert manually
INSERT INTO experiments (user_id, experiment_name, variant, assigned_date) VALUES
(1, 'checkout_flow_test', 'A', '2024-01-01'),
(2, 'checkout_flow_test', 'A', '2024-01-02'),
(3, 'checkout_flow_test', 'A', '2024-01-03');
-- Add more rows as needed, or use a script to generate 2000 rows

-- Insert events (page views, add to cart, checkout start, purchase)
-- Simulate realistic funnel with drop-offs
-- Variant B should have slightly better conversion

-- Events for Variant A (control)
INSERT INTO events
SELECT 
    generate_series(1, 50000) as event_id,
    (random() * 1000 + 1)::INT as user_id,
    CASE 
        WHEN random() < 0.6 THEN 'page_view'
        WHEN random() < 0.8 THEN 'add_to_cart'
        WHEN random() < 0.95 THEN 'checkout_start'
        ELSE 'purchase'
    END as event_type,
    '2024-01-01'::TIMESTAMP + (random() * INTERVAL '14 days') as event_date;

-- Events for Variant B (treatment - better conversion)
INSERT INTO events
SELECT 
    generate_series(50001, 102000) as event_id,
    (random() * 1000 + 1001)::INT as user_id,
    CASE 
        WHEN random() < 0.55 THEN 'page_view'
        WHEN random() < 0.78 THEN 'add_to_cart'
        WHEN random() < 0.92 THEN 'checkout_start'
        ELSE 'purchase'
    END as event_type,
    '2024-01-01'::TIMESTAMP + (random() * INTERVAL '14 days') as event_date;

-- Insert purchases (only for users who completed purchase event)
-- Variant B should have slightly higher AOV
INSERT INTO purchases
SELECT 
    generate_series(1, 5000) as purchase_id,
    e.user_id,
    e.event_date as purchase_date,
    -- Variant A: avg $45, Variant B: avg $48
    CASE 
        WHEN e.user_id <= 1000 THEN (random() * 30 + 30)::DECIMAL(10,2)
        ELSE (random() * 30 + 33)::DECIMAL(10,2)
    END as amount
FROM events e
WHERE e.event_type = 'purchase'
ORDER BY e.event_id
LIMIT 5000;

-- Note: The data is designed so that:
-- - Variant B has slightly better conversion rate
-- - Variant B has slightly higher average order value
-- - Both variants have similar traffic patterns
-- Your task is to detect these differences and determine statistical significance


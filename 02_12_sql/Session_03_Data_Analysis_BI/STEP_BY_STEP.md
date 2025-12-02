# Session 3: Step-by-Step Tutorial - Data Analysis + Tableau

## 🎯 Goal
Learn SQL for business analysis and visualize results in Tableau.

---

## Part 1: SQL Analysis

## Step 1: Setup Data for Analysis

### 1.1 Create user events table
```sql
USE sql_course;

CREATE TABLE user_events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_type VARCHAR(50),
    event_date DATE
);

-- Insert sample data
INSERT INTO user_events (user_id, event_type, event_date) VALUES
(1, 'signup', '2024-01-01'),
(1, 'first_purchase', '2024-01-05'),
(2, 'signup', '2024-01-02'),
(2, 'first_purchase', '2024-01-10'),
(3, 'signup', '2024-01-01'),
(3, 'first_purchase', '2024-01-03'),
(4, 'signup', '2024-01-05'),
(5, 'signup', '2024-01-01'),
(5, 'first_purchase', '2024-01-15'),
(6, 'signup', '2024-02-01'),
(6, 'first_purchase', '2024-02-05');
```

### 1.2 Create purchases table
```sql
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO purchases (user_id, purchase_date, amount) VALUES
(1, '2024-01-05', 100.00),
(1, '2024-01-20', 150.00),
(2, '2024-01-10', 75.00),
(3, '2024-01-03', 200.00),
(5, '2024-01-15', 120.00),
(6, '2024-02-05', 80.00);
```

---

## Step 2: Funnel Analysis (Simple)

### 2.1 Count users at each step
```sql
SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'signup' THEN user_id END) as signups,
    COUNT(DISTINCT CASE WHEN event_type = 'first_purchase' THEN user_id END) as purchases
FROM user_events;
```

### 2.2 Calculate conversion rate
```sql
SELECT 
    COUNT(DISTINCT CASE WHEN event_type = 'signup' THEN user_id END) as signups,
    COUNT(DISTINCT CASE WHEN event_type = 'first_purchase' THEN user_id END) as purchases,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN event_type = 'first_purchase' THEN user_id END) 
        / COUNT(DISTINCT CASE WHEN event_type = 'signup' THEN user_id END), 
        2
    ) as conversion_rate
FROM user_events;
```

**Result:** Shows signup → purchase conversion

---

## Step 3: Retention Analysis

### 3.1 Find first activity date per user
```sql
CREATE TABLE user_activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    activity_date DATE
);

INSERT INTO user_activities (user_id, activity_date) VALUES
(1, '2024-01-01'),
(1, '2024-01-05'),
(1, '2024-01-20'),
(2, '2024-01-02'),
(2, '2024-01-10'),
(3, '2024-01-01'),
(3, '2024-01-15'),
(4, '2024-01-05');
```

### 3.2 Calculate 30-day retention
```sql
WITH first_activity AS (
    SELECT user_id, MIN(activity_date) as first_date
    FROM user_activities
    GROUP BY user_id
),
retention_check AS (
    SELECT 
        fa.user_id,
        fa.first_date,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM user_activities a 
                WHERE a.user_id = fa.user_id 
                AND a.activity_date BETWEEN DATE_ADD(fa.first_date, INTERVAL 30 DAY) 
                AND DATE_ADD(fa.first_date, INTERVAL 31 DAY)
            ) THEN 1 ELSE 0 
        END as retained_30d
    FROM first_activity fa
)
SELECT 
    COUNT(*) as total_users,
    SUM(retained_30d) as retained_users,
    ROUND(100.0 * SUM(retained_30d) / COUNT(*), 2) as retention_rate_30d
FROM retention_check;
```

---

## Step 4: Cohort Analysis

### 4.1 Create cohort table
```sql
-- Users grouped by signup month
WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_FORMAT(MIN(event_date), '%Y-%m') as cohort_month
    FROM user_events
    WHERE event_type = 'signup'
    GROUP BY user_id
),
monthly_activity AS (
    SELECT 
        u.user_id,
        DATE_FORMAT(e.event_date, '%Y-%m') as activity_month
    FROM user_events e
    INNER JOIN user_cohorts u ON e.user_id = u.user_id
    GROUP BY u.user_id, DATE_FORMAT(e.event_date, '%Y-%m')
)
SELECT 
    c.cohort_month,
    m.activity_month,
    COUNT(DISTINCT m.user_id) as active_users
FROM user_cohorts c
INNER JOIN monthly_activity m ON c.user_id = m.user_id
GROUP BY c.cohort_month, m.activity_month
ORDER BY c.cohort_month, m.activity_month;
```

---

## Step 5: Revenue Analysis

### 5.1 Monthly revenue
```sql
SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') as month,
    COUNT(*) as purchase_count,
    SUM(amount) as total_revenue,
    AVG(amount) as avg_order_value
FROM purchases
GROUP BY DATE_FORMAT(purchase_date, '%Y-%m')
ORDER BY month;
```

### 5.2 Revenue per user
```sql
SELECT 
    user_id,
    COUNT(*) as purchase_count,
    SUM(amount) as total_spent,
    AVG(amount) as avg_purchase
FROM purchases
GROUP BY user_id
ORDER BY total_spent DESC;
```

---

## Part 2: Export to Tableau

## Step 6: Prepare Data for Tableau

### 6.1 Create a view for Tableau
```sql
-- Monthly revenue view
CREATE VIEW monthly_revenue AS
SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') as month,
    COUNT(*) as purchase_count,
    SUM(amount) as total_revenue,
    AVG(amount) as avg_order_value
FROM purchases
GROUP BY DATE_FORMAT(purchase_date, '%Y-%m');
```

### 6.2 Export query results to CSV
```sql
-- In MySQL Workbench:
-- 1. Run your query
-- 2. Right-click results
-- 3. Select "Export Recordset to an External File"
-- 4. Choose CSV format
-- 5. Save file

-- Or use command line:
SELECT * FROM monthly_revenue
INTO OUTFILE 'C:/temp/monthly_revenue.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

---

## Step 7: Connect Tableau to MySQL

### 7.1 In Tableau:
1. Open Tableau Desktop
2. Click "Connect to Data"
3. Select "MySQL"
4. Enter:
   - Server: `localhost`
   - Port: `3306`
   - Database: `sql_course`
   - Username: `root` (or your username)
   - Password: (your password)
5. Click "Sign In"

### 7.2 Or Import CSV:
1. Open Tableau Desktop
2. Click "Text file"
3. Select your CSV file
4. Click "Open"

---

## Step 8: Create Your First Tableau Dashboard

### 8.1 Simple Bar Chart - Monthly Revenue
1. Drag `month` to Columns
2. Drag `total_revenue` to Rows
3. Tableau creates a bar chart automatically!

### 8.2 Line Chart - Revenue Trend
1. Drag `month` to Columns
2. Drag `total_revenue` to Rows
3. Click "Show Me" → Select Line Chart

### 8.3 Pie Chart - Revenue by User
1. Drag `user_id` to Columns
2. Drag `total_revenue` to Rows
3. Click "Show Me" → Select Pie Chart

---

## Step 9: Advanced Tableau Visualizations

### 9.1 Funnel Chart
1. Create calculated field: `Funnel Step` (signup, purchase, etc.)
2. Drag to Columns
3. Drag `user_count` to Rows
4. Format as funnel

### 9.2 Cohort Heatmap
1. Use cohort analysis query results
2. Drag `cohort_month` to Rows
3. Drag `activity_month` to Columns
4. Drag `active_users` to Color
5. Select Heatmap from Show Me

### 9.3 Dashboard
1. Create multiple sheets (charts)
2. Go to Dashboard → New Dashboard
3. Drag sheets onto dashboard
4. Arrange and resize

---

## Step 10: Practice - A/B Test Analysis

### 10.1 Create A/B test data
```sql
CREATE TABLE ab_test (
    user_id INT,
    variant VARCHAR(10), -- 'A' or 'B'
    converted INT -- 1 or 0
);

INSERT INTO ab_test VALUES
(1, 'A', 0),
(2, 'A', 1),
(3, 'A', 0),
(4, 'A', 1),
(5, 'A', 0),
(6, 'B', 1),
(7, 'B', 1),
(8, 'B', 0),
(9, 'B', 1),
(10, 'B', 1);
```

### 10.2 Analyze results
```sql
SELECT 
    variant,
    COUNT(*) as total_users,
    SUM(converted) as conversions,
    ROUND(100.0 * SUM(converted) / COUNT(*), 2) as conversion_rate
FROM ab_test
GROUP BY variant;
```

### 10.3 Export and visualize in Tableau
- Export to CSV
- Import to Tableau
- Create comparison chart

---

## ✅ Check Your Understanding

1. What is a funnel analysis?
2. How do you calculate retention rate?
3. What is cohort analysis?
4. How do you connect Tableau to MySQL?
5. What types of charts can you create in Tableau?

---

## 🎯 Next Steps

- Practice more SQL analysis queries
- Create dashboards in Tableau
- Try the A/B test challenge

**Ready for Session 4?** Let's learn database design!


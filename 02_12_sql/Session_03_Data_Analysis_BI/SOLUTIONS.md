# Session 3: Data Analysis + BI - Solutions with Explanations

## Exercise 1: Simple Funnel Analysis

### Solution
```sql
WITH funnel_steps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'landing' THEN 1 ELSE 0 END) as landed,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) as signed_up,
        MAX(CASE WHEN event_type = 'first_purchase' THEN 1 ELSE 0 END) as purchased
    FROM user_events
    GROUP BY user_id
)
SELECT 
    'landing' as step,
    SUM(landed) as users,
    100.00 as conversion_rate
FROM funnel_steps
UNION ALL
SELECT 
    'signup' as step,
    SUM(signed_up) as users,
    ROUND(100.0 * SUM(signed_up) / SUM(landed), 2) as conversion_rate
FROM funnel_steps
UNION ALL
SELECT 
    'first_purchase' as step,
    SUM(purchased) as users,
    ROUND(100.0 * SUM(purchased) / SUM(signed_up), 2) as conversion_rate
FROM funnel_steps;
```

### Explanation
- **CTE `funnel_steps`**: For each user, creates flags (1 or 0) for each step they completed
  - `MAX(CASE WHEN...)` converts event types into columns
  - If user has the event, flag = 1, else 0
- **Main query**: Uses UNION ALL to stack the three steps
  - Each SELECT calculates users at that step
  - Conversion rate: (current_step / previous_step) * 100
  - Landing has 100% (everyone starts there)

### Why This Works
This approach identifies which users completed which steps, then aggregates to show the funnel. The CASE statements convert the event log into a user-level summary, making it easy to calculate conversion rates.

---

## Exercise 2: Calculate 30-Day Retention

### Solution
```sql
WITH first_activity AS (
    SELECT 
        user_id,
        MIN(activity_date) as first_date
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
                AND a.activity_date BETWEEN 
                    DATE_ADD(fa.first_date, INTERVAL 30 DAY) 
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

### Explanation
- **CTE 1 `first_activity`**: Finds each user's first activity date
- **CTE 2 `retention_check`**: For each user, checks if they were active 30 days after first activity
  - `EXISTS` subquery checks for activity in the 30-31 day window
  - Returns 1 if retained, 0 if not
- **Final query**: Calculates totals and percentage
  - `SUM(retained_30d)` = number of retained users
  - `COUNT(*)` = total users
  - Percentage: (retained / total) * 100

### Why This Works
Retention measures if users come back. By checking for activity in a specific time window (30 days after first activity), we can measure 30-day retention. The EXISTS subquery efficiently checks if any activity exists in that window.

---

## Exercise 3: Cohort Analysis - Monthly Retention

### Solution
```sql
WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_FORMAT(signup_date, '%Y-%m') as cohort_month
    FROM user_signups
),
monthly_activity AS (
    SELECT 
        u.user_id,
        u.cohort_month,
        DATE_FORMAT(l.login_date, '%Y-%m') as activity_month
    FROM user_cohorts u
    INNER JOIN user_logins l ON u.user_id = l.user_id
    GROUP BY u.user_id, u.cohort_month, DATE_FORMAT(l.login_date, '%Y-%m')
)
SELECT 
    cohort_month,
    activity_month,
    COUNT(DISTINCT user_id) as active_users
FROM monthly_activity
WHERE activity_month >= cohort_month  -- Only count activity after signup
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;
```

### Explanation
- **CTE 1 `user_cohorts`**: Groups users by signup month (cohort)
  - `DATE_FORMAT` converts dates to 'YYYY-MM' format
- **CTE 2 `monthly_activity`**: Joins cohorts with logins and groups by month
  - One row per user per month they were active
- **Main query**: Counts active users per cohort per month
  - `WHERE activity_month >= cohort_month` ensures we only count activity after signup
  - Shows how each cohort's activity changes over time

### Why This Works
Cohort analysis tracks groups of users (cohorts) over time. By grouping by signup month and tracking monthly activity, we can see retention patterns. This helps identify if newer cohorts are more or less engaged than older ones.

---

## Exercise 4: Revenue per Cohort

### Solution
```sql
SELECT 
    DATE_FORMAT(s.signup_date, '%Y-%m') as cohort_month,
    DATE_FORMAT(p.purchase_date, '%Y-%m') as purchase_month,
    SUM(p.amount) as revenue
FROM user_signups s
INNER JOIN purchases p ON s.user_id = p.user_id
GROUP BY 
    DATE_FORMAT(s.signup_date, '%Y-%m'),
    DATE_FORMAT(p.purchase_date, '%Y-%m')
ORDER BY cohort_month, purchase_month;
```

### Explanation
- **Join**: Links signups with purchases to know which cohort each purchase belongs to
- **Group by**: Both signup month (cohort) and purchase month
- **Sum**: Total revenue for each cohort-month combination
- **Result**: Shows how much revenue each cohort generates in each month

### Why This Works
This shows the revenue contribution of each cohort over time. You can see if early cohorts generate more revenue, or if newer cohorts are catching up. This is crucial for understanding customer lifetime value by cohort.

---

## Exercise 5: First-Touch Attribution

### Solution
```sql
WITH first_touch AS (
    SELECT 
        user_id,
        channel,
        MIN(visit_date) as first_visit_date
    FROM user_visits
    GROUP BY user_id, channel
    HAVING visit_date = MIN(visit_date)
),
first_touch_per_user AS (
    SELECT 
        user_id,
        channel as first_channel
    FROM first_touch
    WHERE visit_date = (SELECT MIN(visit_date) FROM user_visits uv WHERE uv.user_id = first_touch.user_id)
)
SELECT 
    ft.first_channel,
    COUNT(DISTINCT c.user_id) as conversions,
    SUM(c.revenue) as total_revenue
FROM first_touch_per_user ft
INNER JOIN conversions c ON ft.user_id = c.user_id
GROUP BY ft.first_channel;
```

### Simpler Solution
```sql
WITH first_visits AS (
    SELECT 
        user_id,
        channel,
        visit_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY visit_date) as rn
    FROM user_visits
),
first_touch AS (
    SELECT user_id, channel as first_channel
    FROM first_visits
    WHERE rn = 1
)
SELECT 
    ft.first_channel,
    COUNT(DISTINCT c.user_id) as conversions,
    SUM(c.revenue) as total_revenue
FROM first_touch ft
INNER JOIN conversions c ON ft.user_id = c.user_id
GROUP BY ft.first_channel;
```

### Explanation
- **CTE 1 `first_visits`**: Uses ROW_NUMBER to identify each user's first visit
  - `PARTITION BY user_id` = separate ranking per user
  - `ORDER BY visit_date` = rank by date (1 = earliest)
- **CTE 2 `first_touch`**: Filters to only first visits (rn = 1)
- **Main query**: Joins with conversions and aggregates by first channel
  - Shows which channels drive the most conversions and revenue

### Why This Works
First-touch attribution gives credit to the channel that first brought the user. This helps marketing understand which channels are best for acquisition. ROW_NUMBER is perfect for finding "first" records.

---

## Exercise 6: Churn Analysis

### Solution
```sql
SELECT 
    user_id,
    MAX(activity_date) as last_activity,
    DATEDIFF(CURRENT_DATE, MAX(activity_date)) as days_since,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, MAX(activity_date)) > 30 
        THEN 'Churned'
        ELSE 'Active'
    END as status
FROM user_activities
GROUP BY user_id
ORDER BY days_since DESC;
```

### Explanation
- **MAX(activity_date)**: Finds each user's most recent activity
- **DATEDIFF**: Calculates days between today and last activity
  - `DATEDIFF(date1, date2)` returns date1 - date2 in days
- **CASE statement**: Categorizes users
  - > 30 days since last activity = Churned
  - ≤ 30 days = Active
- **Result**: Shows which users are at risk of churning

### Why This Works
Churn analysis identifies inactive users. By calculating days since last activity, we can flag users who haven't been active recently. This helps with retention campaigns - target users who are about to churn.

---

## Exercise 7: A/B Test Analysis

### Solution
```sql
SELECT 
    variant,
    COUNT(*) as total_users,
    SUM(converted) as conversions,
    ROUND(100.0 * SUM(converted) / COUNT(*), 2) as conversion_rate
FROM ab_test
GROUP BY variant
ORDER BY variant;
```

### Explanation
- **COUNT(*)**: Total users in each variant
- **SUM(converted)**: Number of conversions (converted = 1, so SUM counts conversions)
- **Conversion rate**: (conversions / total_users) * 100
- **Result**: Shows which variant performed better

### Analysis
- Variant A: 40% conversion rate (2/5)
- Variant B: 80% conversion rate (4/5)
- **Conclusion**: Variant B performed better (2x conversion rate)

### Why This Works
A/B testing compares two versions to see which performs better. By grouping by variant and calculating conversion rates, we can see which variant drives more conversions. This is the foundation of data-driven decision making.

---

## Exercise 8: Export Data for Tableau

### Solution

**Step 1: Create View**
```sql
CREATE VIEW funnel_analysis AS
WITH funnel_steps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'landing' THEN 1 ELSE 0 END) as landed,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) as signed_up,
        MAX(CASE WHEN event_type = 'first_purchase' THEN 1 ELSE 0 END) as purchased
    FROM user_events
    GROUP BY user_id
)
SELECT 
    'landing' as step,
    SUM(landed) as users,
    100.00 as conversion_rate
FROM funnel_steps
UNION ALL
SELECT 
    'signup' as step,
    SUM(signed_up) as users,
    ROUND(100.0 * SUM(signed_up) / SUM(landed), 2) as conversion_rate
FROM funnel_steps
UNION ALL
SELECT 
    'first_purchase' as step,
    SUM(purchased) as users,
    ROUND(100.0 * SUM(purchased) / SUM(signed_up), 2) as conversion_rate
FROM funnel_steps;
```

**Step 2: Export in MySQL Workbench**
1. Run: `SELECT * FROM funnel_analysis;`
2. Right-click on results
3. Select "Export Recordset to an External File"
4. Choose CSV format
5. Save file

**Step 3: Import to Tableau**
1. Open Tableau Desktop
2. Click "Text file"
3. Select your CSV file
4. Click "Open"
5. Create visualization:
   - Drag `step` to Columns
   - Drag `users` to Rows
   - Drag `conversion_rate` to Color or Labels

### Explanation
- **Views**: Save queries for reuse and easy export
- **CSV export**: Standard format that Tableau can read
- **Tableau import**: Simple drag-and-drop to create visualizations

### Why This Works
Exporting SQL results to CSV bridges SQL analysis and visualization. Tableau can then create interactive dashboards from your SQL analysis, making insights more accessible to stakeholders.

---

## Key Takeaways

1. **Funnel analysis** - Track users through steps, calculate conversion rates
2. **Retention** - Measure if users come back after first activity
3. **Cohort analysis** - Group users by signup date, track over time
4. **Attribution** - Give credit to marketing channels
5. **Churn analysis** - Identify inactive users
6. **A/B testing** - Compare variants to find winners
7. **Export to Tableau** - Visualize SQL results

---

## Common Mistakes to Avoid

1. ❌ Not filtering activity_month >= cohort_month (counts pre-signup activity)
2. ❌ Using COUNT instead of SUM for binary flags (0/1)
3. ❌ Forgetting DISTINCT when counting users
4. ❌ Not handling NULLs in calculations
5. ❌ Exporting without documenting column meanings

---

**Great job! You're now analyzing data like a pro analyst!** 📊


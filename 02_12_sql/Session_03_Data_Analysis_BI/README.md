# Session 3: SQL for Data Analysis + BI + Tableau

## 🚀 Start Here: Step-by-Step Tutorial

**New to data analysis?** Start with the step-by-step guide:
👉 **[STEP_BY_STEP.md](./STEP_BY_STEP.md)** - Simple tutorial with Tableau integration

## 📋 Session Overview

**Duration:** 3 hours  
**Focus:** Real-world analytics queries for business intelligence with Tableau visualization

---

## 🎯 Learning Objectives

By the end of this session, you will:
- Perform cohort analysis
- Calculate retention and churn metrics
- Build funnel analysis queries
- Implement attribution logic (first touch / last touch)
- Analyze A/B test results using SQL

---

## 📖 Mini-Lecture (20-30 min)

### Cohort Analysis

**Definition:** Group users by their first activity date, then track their behavior over time.

**Use Cases:**
- User retention by signup month
- Revenue per cohort
- Product adoption by cohort

**Key Components:**
1. **Cohort Definition**: First event date (e.g., signup, first purchase)
2. **Period**: Time since cohort start (e.g., month 0, 1, 2)
3. **Metric**: What to measure (retention, revenue, activity)

```sql
-- Basic cohort structure
WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', MIN(activity_date)) as cohort_month
    FROM user_activities
    GROUP BY user_id
),
periods AS (
    SELECT 
        user_id,
        activity_date,
        DATE_TRUNC('month', activity_date) as activity_month
    FROM user_activities
)
SELECT 
    c.cohort_month,
    p.activity_month,
    COUNT(DISTINCT p.user_id) as active_users
FROM user_cohorts c
INNER JOIN periods p ON c.user_id = p.user_id
GROUP BY c.cohort_month, p.activity_month;
```

### Retention Analysis

**Retention Rate:** Percentage of users who return after their first visit.

**Types:**
- **Day 1 Retention**: Users active 1 day after signup
- **Day 7 Retention**: Users active 7 days after signup
- **Day 30 Retention**: Users active 30 days after signup

```sql
-- Calculate 30-day retention
WITH first_activity AS (
    SELECT user_id, MIN(activity_date) as first_date
    FROM activities
    GROUP BY user_id
),
retention_check AS (
    SELECT 
        fa.user_id,
        fa.first_date,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM activities a 
                WHERE a.user_id = fa.user_id 
                AND a.activity_date BETWEEN fa.first_date + INTERVAL '30 days' 
                AND fa.first_date + INTERVAL '31 days'
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

### Churn Analysis

**Churn:** Users who stopped using the product.

**Churn Rate:** Percentage of users who churned in a period.

```sql
-- Identify churned users (no activity in last 30 days)
SELECT 
    user_id,
    MAX(activity_date) as last_activity_date,
    CURRENT_DATE - MAX(activity_date) as days_since_last_activity,
    CASE 
        WHEN CURRENT_DATE - MAX(activity_date) > 30 THEN 'Churned'
        ELSE 'Active'
    END as status
FROM user_activities
GROUP BY user_id;
```

### Funnel Analysis

**Definition:** Track users through a series of steps.

**Common Funnels:**
- Signup → Onboarding → First Purchase
- View Product → Add to Cart → Checkout → Purchase
- Landing Page → Signup → Activation

```sql
-- Funnel analysis example
WITH funnel_steps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) as signed_up,
        MAX(CASE WHEN event_type = 'onboarded' THEN 1 ELSE 0 END) as onboarded,
        MAX(CASE WHEN event_type = 'first_purchase' THEN 1 ELSE 0 END) as purchased
    FROM user_events
    GROUP BY user_id
)
SELECT 
    COUNT(*) as total_visitors,
    SUM(signed_up) as signups,
    SUM(onboarded) as onboarded,
    SUM(purchased) as purchases,
    ROUND(100.0 * SUM(signed_up) / COUNT(*), 2) as signup_rate,
    ROUND(100.0 * SUM(onboarded) / SUM(signed_up), 2) as onboarding_rate,
    ROUND(100.0 * SUM(purchased) / SUM(onboarded), 2) as purchase_rate
FROM funnel_steps;
```

### Attribution Logic

**Attribution:** Assigning credit to marketing channels for conversions.

**Types:**

1. **First Touch Attribution**: Credit to first channel
```sql
WITH first_touch AS (
    SELECT 
        user_id,
        channel,
        MIN(visit_date) as first_visit_date
    FROM user_visits
    GROUP BY user_id, channel
)
SELECT 
    ft.channel,
    COUNT(DISTINCT u.user_id) as conversions,
    SUM(u.revenue) as total_revenue
FROM first_touch ft
INNER JOIN users u ON ft.user_id = u.user_id
WHERE u.converted = 1
GROUP BY ft.channel;
```

2. **Last Touch Attribution**: Credit to last channel before conversion
```sql
WITH last_touch AS (
    SELECT 
        user_id,
        channel,
        MAX(visit_date) as last_visit_date
    FROM user_visits
    WHERE visit_date <= (SELECT conversion_date FROM conversions WHERE user_id = user_visits.user_id)
    GROUP BY user_id, channel
)
SELECT 
    lt.channel,
    COUNT(DISTINCT c.user_id) as conversions
FROM last_touch lt
INNER JOIN conversions c ON lt.user_id = c.user_id
GROUP BY lt.channel;
```

3. **Multi-Touch Attribution**: Credit distributed across all touches
```sql
-- Equal weight to all touches
WITH all_touches AS (
    SELECT 
        user_id,
        channel,
        COUNT(*) as touch_count
    FROM user_visits
    WHERE user_id IN (SELECT user_id FROM conversions)
    GROUP BY user_id, channel
),
total_touches AS (
    SELECT 
        user_id,
        SUM(touch_count) as total
    FROM all_touches
    GROUP BY user_id
)
SELECT 
    at.channel,
    SUM(at.touch_count::decimal / tt.total) as attributed_conversions
FROM all_touches at
INNER JOIN total_touches tt ON at.user_id = tt.user_id
GROUP BY at.channel;
```

---

## 💻 Hands-On Exercises (1.5-2 hours)

### Exercise 1: Build a User Funnel

**Task:** Create a funnel analysis for: Landing → Signup → Onboarding → First Purchase

**Setup:**
```sql
CREATE TABLE user_events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(50),
    event_date TIMESTAMP
);

-- Sample data
INSERT INTO user_events VALUES
(1, 101, 'landing', '2024-01-01 10:00:00'),
(2, 101, 'signup', '2024-01-01 10:05:00'),
(3, 101, 'onboarding', '2024-01-01 10:10:00'),
(4, 101, 'first_purchase', '2024-01-02 14:00:00'),
(5, 102, 'landing', '2024-01-01 11:00:00'),
(6, 102, 'signup', '2024-01-01 11:02:00'),
(7, 103, 'landing', '2024-01-01 12:00:00');
-- ... more data
```

**Your Task:** Calculate conversion rates at each step.

[📝 Solution](./solutions/exercise_01_solution.sql)

---

### Exercise 2: Calculate 30/60/90-Day Retention

**Task:** Calculate retention rates for multiple time periods.

**Setup:**
```sql
CREATE TABLE user_activities (
    activity_id INT PRIMARY KEY,
    user_id INT,
    activity_date DATE
);

-- Users with activities over time
```

**Your Task:** Calculate:
- Day 30 retention rate
- Day 60 retention rate
- Day 90 retention rate

[📝 Solution](./solutions/exercise_02_solution.sql)

---

### Exercise 3: Revenue per Cohort

**Task:** Track revenue by user signup cohort over time.

**Setup:**
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
);
```

**Your Task:** Create a cohort table showing revenue by signup month and purchase month.

[📝 Solution](./solutions/exercise_03_solution.sql)

---

### Exercise 4: Marketing Channel Attribution

**Task:** Implement first-touch and last-touch attribution.

**Setup:**
```sql
CREATE TABLE user_visits (
    visit_id INT PRIMARY KEY,
    user_id INT,
    channel VARCHAR(50),
    visit_date TIMESTAMP
);

CREATE TABLE conversions (
    conversion_id INT PRIMARY KEY,
    user_id INT,
    conversion_date TIMESTAMP,
    revenue DECIMAL(10,2)
);
```

**Your Task:** Calculate:
- First-touch attribution by channel
- Last-touch attribution by channel
- Compare the results

[📝 Solution](./solutions/exercise_04_solution.sql)

---

## 🎯 Final Challenge: A/B Test Analysis

**Objective:** Evaluate experiment results using SQL to determine if a new feature improved key metrics.

### The Challenge

Your company ran an A/B test:
- **Control Group (A)**: Existing checkout flow
- **Treatment Group (B)**: New checkout flow with one-click purchase

**Test Period:** 2 weeks  
**Goal:** Increase conversion rate and average order value

### Data Schema

```sql
CREATE TABLE experiments (
    user_id INT,
    experiment_name VARCHAR(50),
    variant VARCHAR(10), -- 'A' or 'B'
    assigned_date DATE
);

CREATE TABLE events (
    event_id INT,
    user_id INT,
    event_type VARCHAR(50), -- 'page_view', 'add_to_cart', 'checkout_start', 'purchase'
    event_date TIMESTAMP
);

CREATE TABLE purchases (
    purchase_id INT,
    user_id INT,
    purchase_date TIMESTAMP,
    amount DECIMAL(10,2)
);
```

### Your Tasks

1. **Calculate Conversion Rates**
   - Overall conversion rate by variant
   - Conversion rate by day (to check for trends)

2. **Funnel Analysis**
   - Compare funnel drop-off rates between A and B
   - Identify where the biggest differences occur

3. **Revenue Analysis**
   - Average order value by variant
   - Total revenue by variant
   - Revenue per user

4. **Statistical Significance**
   - Sample sizes
   - Conversion rate difference
   - Confidence intervals (if possible)

5. **Recommendation**
   - Should we roll out variant B?
   - What are the risks?
   - What additional analysis would help?

### Deliverable

Submit a SQL script and report with:
1. All analysis queries
2. Key metrics comparison table
3. Visualization-ready data (export to CSV)
4. Written recommendation (2-3 paragraphs)

[📊 Sample Data](./data/ab_test_data.sql)  
[💡 Analysis Guide](./analysis_guide.md)

---

## 📚 Additional Resources

- [Cohort Analysis in SQL](https://www.sisense.com/blog/cohort-analysis-in-sql/)
- [Funnel Analysis Best Practices](./funnel_best_practices.md)
- [A/B Testing Statistics](./ab_testing_stats.md)

---

## ✅ Session Checklist

- [ ] Completed Exercise 1: User Funnel
- [ ] Completed Exercise 2: Retention Rates
- [ ] Completed Exercise 3: Revenue per Cohort
- [ ] Completed Exercise 4: Channel Attribution
- [ ] Completed Final Challenge: A/B Test Analysis
- [ ] Reviewed all solutions
- [ ] Understand analytics query patterns

---

**Next Session:** [Session 4 - Database Design + Normalization](../Session_04_Database_Design/)


# Session 3: Data Analysis + BI - Exercises

## Exercise 1: Simple Funnel Analysis

### Setup
```sql
USE sql_course;

CREATE TABLE user_events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    event_type VARCHAR(50),
    event_date DATE
);

INSERT INTO user_events (user_id, event_type, event_date) VALUES
(1, 'landing', '2024-01-01'),
(1, 'signup', '2024-01-01'),
(1, 'first_purchase', '2024-01-05'),
(2, 'landing', '2024-01-02'),
(2, 'signup', '2024-01-02'),
(3, 'landing', '2024-01-01'),
(3, 'signup', '2024-01-01'),
(4, 'landing', '2024-01-05'),
(5, 'landing', '2024-01-01'),
(5, 'signup', '2024-01-01'),
(5, 'first_purchase', '2024-01-15');
```

### Your Task
Create a funnel showing:
- Number of users at each step (landing → signup → first_purchase)
- Conversion rate from each step to the next

### Expected Output
```
step            | users | conversion_rate
----------------|-------|----------------
landing         | 5     | 100.00
signup          | 4     | 80.00
first_purchase  | 2     | 50.00
```

### 💡 Hints
- Count distinct users for each event type
- Calculate conversion rate: (next_step / current_step) * 100
- Use CASE statements or conditional aggregation
- You might need a subquery or CTE

---

## Exercise 2: Calculate 30-Day Retention

### Setup
```sql
CREATE TABLE user_activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    activity_date DATE
);

INSERT INTO user_activities (user_id, activity_date) VALUES
(1, '2024-01-01'),
(1, '2024-01-05'),
(1, '2024-02-01'),  -- 31 days later (retained!)
(2, '2024-01-02'),
(2, '2024-01-10'),
(3, '2024-01-01'),
(3, '2024-01-15'),
(4, '2024-01-05');
```

### Your Task
Calculate the 30-day retention rate:
- Find each user's first activity date
- Check if they were active 30 days after first activity
- Calculate percentage of users retained

### Expected Output
```
total_users | retained_users | retention_rate_30d
------------|----------------|-------------------
4           | 1              | 25.00
```

### 💡 Hints
- Use CTE to find first activity per user
- Use EXISTS or JOIN to check for activity 30 days later
- Date calculation: `DATE_ADD(first_date, INTERVAL 30 DAY)`
- Calculate percentage: (retained / total) * 100

---

## Exercise 3: Cohort Analysis - Monthly Retention

### Setup
```sql
CREATE TABLE user_signups (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    signup_date DATE
);

CREATE TABLE user_logins (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    login_date DATE
);

INSERT INTO user_signups (signup_date) VALUES
('2024-01-01'),
('2024-01-01'),
('2024-01-15'),
('2024-02-01'),
('2024-02-01');

INSERT INTO user_logins (user_id, login_date) VALUES
(1, '2024-01-01'),
(1, '2024-01-15'),
(1, '2024-02-01'),
(2, '2024-01-01'),
(2, '2024-02-01'),
(3, '2024-01-15'),
(4, '2024-02-01'),
(5, '2024-02-01');
```

### Your Task
Create a cohort table showing:
- Signup month (cohort)
- Activity month
- Number of active users in that month for that cohort

### Expected Output
```
cohort_month | activity_month | active_users
-------------|----------------|--------------
2024-01      | 2024-01        | 3
2024-01      | 2024-02        | 2
2024-02      | 2024-02        | 2
```

### 💡 Hints
- Group signups by month: `DATE_FORMAT(signup_date, '%Y-%m')`
- Group logins by month
- Join on user_id
- Count distinct users per cohort and month

---

## Exercise 4: Revenue per Cohort

### Setup
```sql
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
);

-- Use user_signups from Exercise 3
INSERT INTO purchases (user_id, purchase_date, amount) VALUES
(1, '2024-01-05', 100.00),
(1, '2024-02-10', 150.00),
(2, '2024-01-10', 75.00),
(3, '2024-01-20', 200.00),
(4, '2024-02-05', 120.00);
```

### Your Task
Calculate total revenue by signup cohort and purchase month.

### Expected Output
```
cohort_month | purchase_month | revenue
-------------|----------------|----------
2024-01      | 2024-01        | 375.00
2024-01      | 2024-02        | 150.00
2024-02      | 2024-02        | 120.00
```

### 💡 Hints
- Join purchases with user_signups
- Group by signup month and purchase month
- Sum the amounts

---

## Exercise 5: First-Touch Attribution

### Setup
```sql
CREATE TABLE user_visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    channel VARCHAR(50),
    visit_date DATE
);

CREATE TABLE conversions (
    conversion_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    conversion_date DATE,
    revenue DECIMAL(10,2)
);

INSERT INTO user_visits (user_id, channel, visit_date) VALUES
(1, 'email', '2024-01-01'),
(1, 'social', '2024-01-05'),
(2, 'search', '2024-01-02'),
(2, 'email', '2024-01-10'),
(3, 'social', '2024-01-01'),
(4, 'search', '2024-01-05');

INSERT INTO conversions (user_id, conversion_date, revenue) VALUES
(1, '2024-01-10', 100.00),
(2, '2024-01-15', 75.00),
(3, '2024-01-20', 200.00);
```

### Your Task
Calculate first-touch attribution:
- For each converted user, find their first visit channel
- Sum revenue by first-touch channel

### Expected Output
```
channel | conversions | total_revenue
--------|-------------|--------------
email   | 1           | 100.00
search  | 1           | 75.00
social  | 1           | 200.00
```

### 💡 Hints
- Find first visit per user: `MIN(visit_date)`
- Join with conversions
- Group by channel
- Sum revenue

---

## Exercise 6: Churn Analysis

### Setup
Use the `user_activities` table from Exercise 2.

### Your Task
Identify churned users:
- Users with no activity in the last 30 days
- Show days since last activity
- Categorize as 'Active' or 'Churned'

### Expected Output
```
user_id | last_activity | days_since | status
--------|---------------|------------|--------
1       | 2024-02-01    | 30         | Active
2       | 2024-01-10    | 51         | Churned
3       | 2024-01-15    | 46         | Churned
4       | 2024-01-05    | 56         | Churned
```

### 💡 Hints
- Find MAX(activity_date) per user
- Calculate days: `DATEDIFF(CURRENT_DATE, last_activity)`
- Use CASE to categorize: > 30 days = Churned

---

## Exercise 7: A/B Test Analysis

### Setup
```sql
CREATE TABLE ab_test (
    user_id INT,
    variant VARCHAR(10),
    converted INT
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

### Your Task
Compare variants:
- Total users per variant
- Conversions per variant
- Conversion rate per variant
- Which variant performed better?

### Expected Output
```
variant | total_users | conversions | conversion_rate
--------|-------------|-------------|-----------------
A       | 5           | 2           | 40.00
B       | 5           | 4           | 80.00
```

### 💡 Hints
- Group by variant
- Count total users
- Sum conversions (converted = 1)
- Calculate rate: (conversions / total) * 100

---

## Exercise 8: Export Data for Tableau

### Setup
Use any query from previous exercises.

### Your Task
1. Create a view with your analysis results
2. Export the data to CSV format
3. Document the steps for Tableau import

### 💡 Hints
- Use `CREATE VIEW` to save your query
- In MySQL Workbench: Right-click results → Export
- Or use `INTO OUTFILE` (requires file permissions)
- Document column meanings for Tableau

---

## ✅ Practice Tips

1. **Understand the business question** before writing SQL
2. **Use CTEs** to break down complex queries
3. **Test with small data** first
4. **Export and visualize** in Tableau to see patterns
5. **Document your findings** - what do the numbers mean?

---

**Ready for solutions?** Check the [SOLUTIONS.md](./SOLUTIONS.md) file!


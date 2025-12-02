# Session 5: Full Project - Build a Complete SQL Case Study

## 🚀 Start Here: Step-by-Step Tutorial

**Want a guided walkthrough?** Follow the step-by-step guide:
👉 **[STEP_BY_STEP.md](./STEP_BY_STEP.md)** - Complete project walkthrough

## 📋 Session Overview

**Duration:** 3 hours (Capstone Project)  
**Focus:** End-to-end SQL solution for a real business problem

---

## 🎯 Learning Objectives

By the end of this session, you will:
- Design a complete database schema from business requirements
- Populate database with realistic simulated data
- Write complex analytical queries to answer business questions
- Create a comprehensive business dashboard
- Present insights as a data analyst

---

## 🎯 Capstone Project Overview

This is your final project where you'll build a complete SQL solution from scratch. You'll choose one case study and work through the entire data lifecycle:

1. **Schema Design** → Create tables and relationships
2. **Data Population** → Insert realistic simulated data
3. **Business Analysis** → Answer 10-15 business questions
4. **Dashboard Creation** → Compile insights into a report
5. **Presentation** → Present findings as a data analyst

---

## 📊 Case Study Options

Choose ONE case study to complete:

### Option 1: E-Commerce Company

**Business Context:**
You're the data analyst for an online retail company. The business needs insights on sales performance, customer behavior, product trends, and marketing effectiveness.

**Key Entities:**
- Customers, Products, Orders, Order Items
- Marketing Campaigns, Promotions
- Refunds, Returns
- Product Categories, Reviews

**Business Questions to Answer:**
1. Who are our top 10 customers by lifetime value?
2. What products have the highest return/refund rates?
3. Which marketing campaigns drive the most revenue?
4. What's the average order value by customer segment?
5. Identify customers at risk of churn (no purchase in 90+ days)
6. What's the repeat purchase rate?
7. Which product categories show seasonal trends?
8. Calculate customer acquisition cost by channel
9. What's the average time between first and second purchase?
10. Identify products that are frequently bought together
11. What's the revenue trend month-over-month?
12. Which regions have the highest sales?
13. What percentage of customers make repeat purchases?
14. Calculate the customer lifetime value distribution
15. Identify the best and worst performing products

[📁 E-Commerce Case Study Details](./case_studies/ecommerce/)

---

### Option 2: Ride-Sharing App

**Business Context:**
You're analyzing data for a ride-sharing platform. Focus on driver performance, trip patterns, pricing, and user satisfaction.

**Key Entities:**
- Drivers, Riders, Trips
- Vehicles, Ratings
- Payments, Promotions
- Cities, Zones

**Business Questions to Answer:**
1. What's the average trip duration by city?
2. Which drivers have the highest ratings and earnings?
3. Identify peak hours and days for ride demand
4. Calculate driver utilization rate (trips per hour)
5. What's the average fare by distance category?
6. Which zones have the highest demand?
7. Identify drivers at risk of leaving (low activity)
8. What's the cancellation rate by driver?
9. Calculate revenue per driver by month
10. Which time periods have surge pricing most often?
11. What's the customer retention rate (repeat riders)?
12. Identify the most profitable routes
13. Calculate average wait time by zone
14. What percentage of trips result in ratings?
15. Analyze driver earnings distribution

[📁 Ride-Sharing Case Study Details](./case_studies/ridesharing/)

---

### Option 3: Streaming Platform

**Business Context:**
You're working for a streaming service. Analyze content performance, user engagement, subscription trends, and content recommendations.

**Key Entities:**
- Users, Subscriptions, Content (Movies/TV Shows)
- Watch History, Ratings
- Genres, Actors, Directors
- Plans, Payments

**Business Questions to Answer:**
1. What's the most popular content by genre?
2. Calculate average watch time per user
3. Identify content with highest completion rates
4. What's the churn rate by subscription plan?
5. Which actors/directors appear in top-rated content?
6. Calculate user engagement score (sessions per week)
7. What's the revenue by subscription tier?
8. Identify users at risk of canceling
9. What content drives new subscriptions?
10. Calculate average session duration by device type
11. Which genres have the highest retention?
12. What's the content discovery pattern (how users find content)?
13. Analyze peak viewing hours
14. Calculate lifetime value by acquisition channel
15. Identify binge-watching patterns

[📁 Streaming Platform Case Study Details](./case_studies/streaming/)

---

### Option 4: Fitness App

**Business Context:**
You're analyzing a fitness tracking app. Focus on user engagement, workout patterns, goal achievement, and social features.

**Key Entities:**
- Users, Workouts, Exercises
- Goals, Achievements, Streaks
- Coaches, Programs
- Social Features (Friends, Challenges)

**Business Questions to Answer:**
1. What's the average workout frequency per user?
2. Which exercises are most popular?
3. Calculate goal completion rates
4. Identify users with longest workout streaks
5. What's the engagement rate by user cohort?
6. Which workout programs have highest completion rates?
7. Calculate average workout duration by type
8. Identify users at risk of churning (inactive 30+ days)
9. What's the social engagement (friends, challenges)?
10. Which coaches have the most active users?
11. Calculate user progression over time
12. What workout types show seasonal trends?
13. Identify power users (top 10% by activity)
14. Calculate achievement unlock rates
15. Analyze workout patterns by time of day

[📁 Fitness App Case Study Details](./case_studies/fitness/)

---

### Option 5: Banking Analytics

**Business Context:**
You're working for a bank analyzing transactions, fraud patterns, customer behavior, and product usage.

**Key Entities:**
- Customers, Accounts, Transactions
- Products (Checking, Savings, Credit Cards, Loans)
- Fraud Flags, Alerts
- Branches, ATMs

**Business Questions to Answer:**
1. What's the average transaction amount by transaction type?
2. Identify suspicious transaction patterns (fraud detection)
3. Calculate customer lifetime value
4. Which products have the highest adoption rates?
5. What's the average account balance by customer segment?
6. Identify customers with unusual spending patterns
7. Calculate transaction volume by day of week
8. Which branches have the most activity?
9. What's the credit card utilization rate?
10. Identify customers likely to default on loans
11. Calculate average deposits and withdrawals
12. Which ATMs are used most frequently?
13. Analyze transaction patterns by time of day
14. What's the product cross-sell rate?
15. Identify high-value customers (top 5% by assets)

[📁 Banking Analytics Case Study Details](./case_studies/banking/)

---

## 📋 Project Requirements

### Phase 1: Schema Design (30 min)

1. **Create ERD**
   - Design entity relationships
   - Show cardinality
   - Use diagramming tool

2. **Write DDL**
   - All CREATE TABLE statements
   - Primary keys, foreign keys
   - Constraints (UNIQUE, CHECK, NOT NULL)
   - Indexes on foreign keys and frequently queried columns

3. **Document Design Decisions**
   - Why you chose this structure
   - Normalization level
   - Key assumptions

### Phase 2: Data Population (30 min)

1. **Generate Realistic Data**
   - Use INSERT statements or data generation scripts
   - Minimum requirements:
     - 1,000+ customers/users
     - 5,000+ transactions/orders/trips
     - 100+ products/content items
   - Data should be realistic and varied

2. **Data Quality**
   - No NULLs where business logic requires values
   - Proper relationships maintained
   - Realistic date ranges
   - Varied amounts/quantities

### Phase 3: Business Analysis (60 min)

1. **Answer 10-15 Business Questions**
   - Use the questions provided for your case study
   - Write efficient, readable SQL queries
   - Use appropriate techniques:
     - Window functions
     - CTEs
     - Joins
     - Aggregations
     - Subqueries (when appropriate)

2. **Query Quality**
   - Well-commented
   - Optimized (consider indexes)
   - Results are meaningful

### Phase 4: Dashboard Creation (30 min)

1. **Compile Insights**
   - Create a summary query/view that shows key metrics
   - Organize results by category (e.g., Customer, Product, Revenue)

2. **Export Data**
   - Export results to CSV for visualization
   - Or create views for easy access

3. **Create Summary Report**
   - Key findings (2-3 pages)
   - Top insights
   - Recommendations

### Phase 5: Presentation (30 min)

1. **Prepare Presentation**
   - 5-10 minute presentation
   - Key insights
   - Visualizations (charts/tables)
   - Recommendations

2. **Deliverable Format**
   - SQL scripts (organized by phase)
   - Presentation slides or document
   - Data exports (CSV files)

---

## 📁 Project Structure

Organize your project like this:

```
Session_05_Case_Study/
├── your_case_study_name/
│   ├── 01_schema/
│   │   ├── erd.png (or link)
│   │   ├── create_tables.sql
│   │   └── design_document.md
│   ├── 02_data/
│   │   ├── insert_data.sql
│   │   └── data_generation_notes.md
│   ├── 03_queries/
│   │   ├── business_questions.sql
│   │   └── query_explanations.md
│   ├── 04_dashboard/
│   │   ├── dashboard_queries.sql
│   │   ├── key_metrics.csv
│   │   └── summary_report.md
│   └── 05_presentation/
│       ├── presentation_slides.pdf
│       └── insights_summary.md
```

---

## ✅ Evaluation Criteria

### Schema Design (25%)
- ✅ Proper normalization (3NF)
- ✅ Correct relationships
- ✅ Appropriate constraints
- ✅ Scalable design

### Data Quality (15%)
- ✅ Realistic data
- ✅ Sufficient volume
- ✅ Data integrity maintained

### Query Quality (30%)
- ✅ Correct results
- ✅ Efficient execution
- ✅ Readable and well-commented
- ✅ Uses advanced SQL techniques appropriately

### Business Insights (20%)
- ✅ Meaningful analysis
- ✅ Answers business questions
- ✅ Actionable recommendations

### Presentation (10%)
- ✅ Clear communication
- ✅ Professional format
- ✅ Visualizations where helpful

---

## 🚀 Getting Started

1. **Choose Your Case Study**
   - Review all options
   - Pick one that interests you
   - Read the detailed requirements

2. **Set Up Your Environment**
   - Create a new database
   - Set up your SQL client
   - Create project folder structure

3. **Start with Schema**
   - Don't rush this phase
   - Think through relationships
   - Get feedback if possible

4. **Work Iteratively**
   - Build schema → Test with sample data → Refine
   - Write queries → Test → Optimize
   - Build dashboard → Review → Enhance

5. **Document as You Go**
   - Don't wait until the end
   - Note decisions and assumptions
   - Keep queries organized

---

## 📚 Resources

- [Case Study Templates](./templates/)
- [Sample Solutions](./sample_solutions/) (review after completion)
- [Presentation Tips](./presentation_tips.md)
- [Common Pitfalls](./common_pitfalls.md)

---

## ✅ Final Checklist

Before submitting:

- [ ] Schema is normalized and well-designed
- [ ] All tables have proper constraints
- [ ] Data is realistic and sufficient
- [ ] All 10-15 business questions answered
- [ ] Queries are optimized and documented
- [ ] Dashboard queries created
- [ ] Summary report written
- [ ] Presentation prepared
- [ ] All files organized
- [ ] Code is clean and commented

---

## 🎓 Congratulations!

Completing this capstone project demonstrates you have:
- ✅ Advanced SQL skills
- ✅ Database design expertise
- ✅ Business analysis capabilities
- ✅ Professional presentation skills

**You're ready for real-world data analyst roles!** 🚀

---

**Course Complete!** Return to [Main README](../README.md) to review all sessions.


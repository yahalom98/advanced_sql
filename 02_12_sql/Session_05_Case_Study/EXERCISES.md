# Session 5: Case Study - Practice Exercises

These exercises prepare you for the complete case study project.

## Exercise 1: Design Schema for Online Store

### Your Task
Design a complete database schema for an online store with:
- Customers can place orders
- Orders contain multiple products
- Products belong to categories
- Customers can leave reviews
- Track inventory (stock levels)

**Requirements:**
- All tables in 3NF
- Proper primary and foreign keys
- Appropriate constraints
- Write the complete DDL

### 💡 Hints
- Start with main entities: customers, products, orders
- Think about relationships: one-to-many, many-to-many
- Don't forget: order_items table for many products per order
- Include: categories, reviews, inventory tracking

---

## Exercise 2: Generate Realistic Sample Data

### Setup
Use your schema from Exercise 1.

### Your Task
Write INSERT statements to populate your database with:
- At least 10 customers
- At least 20 products across 3+ categories
- At least 15 orders
- Realistic order items
- Some reviews

**Requirements:**
- Data should be realistic (names, dates, amounts)
- Vary the data (not all same values)
- Include edge cases (customer with no orders, product with no sales)

### 💡 Hints
- Use realistic names and emails
- Spread order dates over several months
- Vary order amounts
- Some products should be more popular than others
- Include some customers who haven't ordered yet

---

## Exercise 3: Top Customers Query

### Setup
Use your populated database from Exercise 2.

### Your Task
Write a query to find:
- Top 5 customers by total amount spent
- Include: customer name, total spent, number of orders, average order value

### Expected Output Format
```
customer_name | total_spent | order_count | avg_order_value
--------------|-------------|-------------|----------------
John Smith    | 2500.00     | 5           | 500.00
...
```

### 💡 Hints
- Join customers and orders
- Use SUM for total, COUNT for order count, AVG for average
- GROUP BY customer
- ORDER BY total DESC
- LIMIT 5

---

## Exercise 4: Product Performance Analysis

### Your Task
Write queries to answer:
1. Best selling products (by quantity)
2. Products with highest revenue
3. Products that haven't sold
4. Average order value by product category

### 💡 Hints
- Join products, order_items, orders
- Use SUM for totals, COUNT for counts
- LEFT JOIN to find products with no sales
- GROUP BY category for category analysis

---

## Exercise 5: Monthly Revenue Trend

### Your Task
Write a query showing:
- Revenue by month
- Month-over-month growth
- Compare to previous year (if you have data)

### Expected Output Format
```
month       | revenue    | prev_month | growth_pct
------------|------------|------------|------------
2024-01     | 5000.00    | NULL       | NULL
2024-02     | 5500.00    | 5000.00    | 10.00
...
```

### 💡 Hints
- Use DATE_FORMAT to group by month
- Use LAG() window function for previous month
- Calculate percentage: (current - previous) / previous * 100

---

## Exercise 6: Customer Segmentation

### Your Task
Segment customers into groups:
- High-value: Top 20% by spending
- Medium-value: Middle 60%
- Low-value: Bottom 20%

Show: segment name, customer count, average spending

### 💡 Hints
- Calculate total spent per customer
- Use NTILE(5) to divide into 5 groups (20% each)
- Or use percentiles
- Group 1 = high, groups 2-4 = medium, group 5 = low

---

## Exercise 7: Create Views for Dashboard

### Your Task
Create views for:
1. `customer_summary` - Key metrics per customer
2. `product_performance` - Sales metrics per product
3. `monthly_revenue` - Revenue trends by month

### 💡 Hints
- Views save complex queries
- Make them reusable
- Include commonly needed columns
- Test each view with SELECT *

---

## Exercise 8: Export and Prepare for Tableau

### Your Task
1. Export your views to CSV files
2. Document what each column means
3. Create a data dictionary

### Data Dictionary Template
```
Table: customer_summary
- customer_id: Unique customer identifier
- total_spent: Lifetime value in dollars
- order_count: Number of orders placed
- last_order_date: Date of most recent order
...
```

### 💡 Hints
- Use MySQL Workbench export feature
- Or use INTO OUTFILE (requires permissions)
- Document data types and meanings
- Note any calculations or aggregations

---

## Exercise 9: Write Business Insights

### Your Task
Based on your queries, write 3-5 key business insights:

**Example format:**
1. **Finding**: Top 20% of customers generate 60% of revenue
   - **Implication**: Focus retention efforts on high-value customers
   - **Recommendation**: Create VIP program

2. **Finding**: Electronics category has highest average order value
   - **Implication**: Customers spend more on electronics
   - **Recommendation**: Increase electronics inventory

### 💡 Hints
- Look for patterns in your data
- Compare segments (high vs low)
- Identify trends (growing/declining)
- Think about what actions to take

---

## Exercise 10: Create Presentation Outline

### Your Task
Create an outline for presenting your analysis:

1. **Introduction** (1 slide)
   - What business/problem you analyzed

2. **Data Overview** (1 slide)
   - Database schema
   - Data volume

3. **Key Findings** (3-5 slides)
   - Top customers
   - Product performance
   - Revenue trends
   - Customer segments

4. **Recommendations** (1-2 slides)
   - Action items
   - Next steps

### 💡 Hints
- Keep it simple and clear
- One main point per slide
- Use visuals (charts from Tableau)
- Tell a story with the data

---

## Exercise 11: Complete Mini Case Study

### Your Task
Put it all together:
1. Design schema (30 min)
2. Insert data (20 min)
3. Write 5 business questions and answer them (30 min)
4. Create 2 views (10 min)
5. Export data (10 min)
6. Write 3 insights (10 min)

**Total time: ~2 hours**

This simulates the full case study project!

### 💡 Hints
- Time yourself
- Focus on quality over quantity
- Test your queries
- Document as you go

---

## Exercise 12: Common Case Study Questions

### Your Task
Practice answering these common business questions:

1. **Who are our best customers?**
   - Query: Top customers by revenue
   - Include: Customer details, lifetime value, order frequency

2. **What products should we focus on?**
   - Query: Best and worst selling products
   - Include: Revenue, quantity, profit margin

3. **Are we growing?**
   - Query: Month-over-month revenue trend
   - Include: Growth rates, seasonality

4. **Which customers are at risk?**
   - Query: Customers with no recent orders
   - Include: Days since last order, previous spending

5. **What's our customer retention?**
   - Query: Repeat purchase rate
   - Include: % of customers with 2+ orders

### 💡 Hints
- These are the types of questions in real case studies
- Practice writing clean, efficient queries
- Think about what business wants to know
- Always include context (dates, filters, etc.)

---

## ✅ Preparation Checklist

Before starting the full case study, make sure you can:
- [ ] Design a normalized database schema
- [ ] Write INSERT statements for sample data
- [ ] Write complex queries with JOINs
- [ ] Use window functions for analysis
- [ ] Create views
- [ ] Export data to CSV
- [ ] Write business insights
- [ ] Present findings clearly

---

## 🎯 Case Study Success Tips

1. **Start with requirements** - Understand what's needed
2. **Design before coding** - Plan your schema first
3. **Test incrementally** - Test each part as you build
4. **Document as you go** - Notes help later
5. **Focus on insights** - Not just queries, but what they mean
6. **Practice presenting** - Explain your work clearly

---

**Ready for the full case study?** Follow the [STEP_BY_STEP.md](./STEP_BY_STEP.md) guide!


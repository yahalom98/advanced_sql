# E-Commerce Company Case Study

## Business Context

You're the data analyst for "ShopSmart", an online retail company selling electronics, clothing, home goods, and more. The company has been operating for 2 years and needs comprehensive insights to drive growth.

## Key Business Goals

1. Understand customer behavior and lifetime value
2. Optimize product mix and inventory
3. Improve marketing ROI
4. Reduce churn and increase retention
5. Identify growth opportunities

## Required Schema

### Core Tables

**customers**
- customer_id (PK)
- first_name, last_name, email
- registration_date
- customer_segment (e.g., 'VIP', 'Regular', 'New')
- city, country

**products**
- product_id (PK)
- product_name, description
- category_id (FK)
- price, cost
- stock_quantity
- created_date

**categories**
- category_id (PK)
- category_name
- parent_category_id (for subcategories)

**orders**
- order_id (PK)
- customer_id (FK)
- order_date
- status (pending, shipped, delivered, cancelled)
- shipping_address
- total_amount

**order_items**
- order_item_id (PK)
- order_id (FK)
- product_id (FK)
- quantity
- unit_price
- subtotal

**marketing_campaigns**
- campaign_id (PK)
- campaign_name
- channel (email, social, search, display)
- start_date, end_date
- budget

**campaign_customers**
- campaign_id (FK)
- customer_id (FK)
- conversion_date

**refunds**
- refund_id (PK)
- order_id (FK)
- refund_date
- refund_amount
- reason

**reviews**
- review_id (PK)
- product_id (FK)
- customer_id (FK)
- rating (1-5)
- review_text
- review_date

## Business Questions

1. **Top 10 customers by lifetime value**
   - Calculate total revenue per customer
   - Include customer details

2. **Products with highest return/refund rates**
   - Calculate refund rate by product
   - Identify problematic products

3. **Marketing campaign effectiveness**
   - Revenue by campaign
   - ROI by channel
   - Conversion rates

4. **Average order value by customer segment**
   - Compare VIP vs Regular vs New customers

5. **Churn analysis**
   - Customers with no purchase in 90+ days
   - Churn rate by segment

6. **Repeat purchase rate**
   - Percentage of customers who made 2+ purchases
   - Time between first and second purchase

7. **Seasonal trends by category**
   - Sales by month and category
   - Identify peak seasons

8. **Customer acquisition cost by channel**
   - Cost per acquisition
   - Lifetime value by channel

9. **Time to second purchase**
   - Average days between first and second purchase
   - By customer segment

10. **Frequently bought together**
    - Products often purchased in same order
    - Use for recommendations

11. **Revenue trends**
    - Month-over-month growth
    - Year-over-year comparison

12. **Regional sales analysis**
    - Top cities/countries by revenue
    - Average order value by region

13. **Repeat purchase percentage**
    - Overall repeat purchase rate
    - By category

14. **Customer lifetime value distribution**
    - Percentiles
    - Segmentation by CLV

15. **Product performance**
    - Best and worst selling products
    - Profit margins
    - Stock turnover

## Data Requirements

- **Minimum 1,000 customers**
- **Minimum 5,000 orders**
- **Minimum 500 products across 10+ categories**
- **2 years of historical data**
- **Multiple marketing campaigns**
- **Realistic refund rates (5-10%)**

## Deliverables

1. Complete schema (DDL)
2. Data population script
3. SQL queries for all 15 questions
4. Dashboard summary
5. Presentation with key insights

## Success Criteria

- Schema supports all business questions
- Queries are optimized and efficient
- Insights are actionable
- Presentation is clear and professional

Good luck! 🛒


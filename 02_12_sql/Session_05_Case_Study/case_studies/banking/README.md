# Banking Analytics Case Study

## Business Context

You're working for "SecureBank", analyzing transactions, customer behavior, fraud patterns, and product usage. The bank needs insights to improve customer experience, detect fraud, and optimize product offerings.

## Key Business Goals

1. Detect and prevent fraud
2. Understand customer behavior
3. Optimize product mix
4. Improve customer lifetime value
5. Reduce risk and defaults

## Required Schema

### Core Tables

**customers**
- customer_id (PK)
- first_name, last_name, email, phone
- date_of_birth
- registration_date
- customer_segment (premium, standard, basic)
- risk_score

**accounts**
- account_id (PK)
- customer_id (FK)
- account_type (checking, savings, business)
- account_number
- balance
- opened_date
- status (active, closed, frozen)

**products**
- product_id (PK)
- product_name (credit_card, loan, mortgage, etc.)
- product_type
- interest_rate
- minimum_balance

**customer_products**
- customer_id (FK)
- product_id (FK)
- opened_date
- status (active, closed)
- credit_limit (for credit cards)
- outstanding_balance (for loans)

**transactions**
- transaction_id (PK)
- account_id (FK)
- transaction_type (deposit, withdrawal, transfer, payment)
- amount
- transaction_date, transaction_time
- merchant_name (for purchases)
- category (groceries, gas, entertainment, etc.)
- status (completed, pending, failed)
- location (city, state)

**fraud_flags**
- flag_id (PK)
- transaction_id (FK)
- flag_type (suspicious_amount, unusual_location, velocity, etc.)
- flag_date
- severity (low, medium, high)
- status (investigating, cleared, confirmed)

**branches**
- branch_id (PK)
- branch_name
- address, city, state
- manager_name

**atms**
- atm_id (PK)
- location_address
- city, state
- transaction_count

**atm_transactions**
- transaction_id (PK)
- atm_id (FK)
- account_id (FK)
- transaction_type (withdrawal, deposit, balance_check)
- amount
- transaction_date, transaction_time

**loans**
- loan_id (PK)
- customer_id (FK)
- product_id (FK)
- loan_amount
- interest_rate
- term_months
- start_date
- monthly_payment
- outstanding_balance
- status (active, paid_off, defaulted)

**loan_payments**
- payment_id (PK)
- loan_id (FK)
- payment_date
- payment_amount
- status (on_time, late, missed)

## Business Questions

1. **Average transaction amount by type**
   - Deposits, withdrawals, transfers
   - By customer segment
   - Trends over time

2. **Suspicious transaction patterns (fraud detection)**
   - Unusual amounts
   - Rapid transactions (velocity)
   - Unusual locations
   - After-hours activity

3. **Customer lifetime value**
   - Total deposits
   - Product usage
   - Revenue per customer

4. **Product adoption rates**
   - Most popular products
   - Cross-sell opportunities
   - Product combinations

5. **Average account balance by segment**
   - Premium vs standard vs basic
   - By account type
   - Trends

6. **Unusual spending patterns**
   - Deviations from normal behavior
   - Large transactions
   - Category changes

7. **Transaction volume by day of week**
   - Peak days
   - Weekend vs weekday patterns
   - Seasonal trends

8. **Branch activity analysis**
   - Transactions per branch
   - Customer visits
   - Branch performance

9. **Credit card utilization rate**
   - Usage vs limit
   - High utilization customers
   - Risk indicators

10. **Loan default risk**
    - Payment history analysis
    - Late payment patterns
    - Default probability indicators

11. **Deposit and withdrawal patterns**
    - Average amounts
    - Frequency
    - Seasonal trends

12. **ATM usage analysis**
    - Most used ATMs
    - Transaction patterns
    - Location optimization

13. **Transaction patterns by time of day**
    - Peak hours
    - After-hours activity
    - Fraud indicators

14. **Product cross-sell rate**
    - Customers with multiple products
    - Product combinations
    - Upsell opportunities

15. **High-value customers**
    - Top 5% by assets
    - Product usage
    - Retention strategies

## Data Requirements

- **Minimum 5,000 customers**
- **Minimum 10,000 accounts**
- **Minimum 100,000 transactions**
- **12 months of historical data**
- **Realistic fraud rate (0.5-1%)**
- **Multiple product types**
- **Geographic diversity (multiple states)**

## Deliverables

1. Complete schema (DDL)
2. Data population script
3. SQL queries for all 15 questions
4. Dashboard summary
5. Presentation with key insights

## Success Criteria

- Schema supports fraud detection
- Queries handle time-series analysis
- Risk metrics are accurate
- Insights are actionable

## Important Notes

- **Data Privacy**: Use anonymized data
- **Fraud Detection**: Focus on patterns, not individual cases
- **Compliance**: Ensure queries respect data governance

Good luck! 🏦


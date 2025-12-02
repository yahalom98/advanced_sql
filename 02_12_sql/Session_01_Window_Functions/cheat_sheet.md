# Window Functions Cheat Sheet

## Quick Reference

### Basic Syntax
```sql
function_name() OVER (
    [PARTITION BY column1, column2, ...]
    [ORDER BY column1 [ASC|DESC], ...]
    [ROWS BETWEEN start AND end]
)
```

### Ranking Functions

| Function | Description | Example |
|----------|-------------|---------|
| `RANK()` | Rank with gaps (1,2,2,4) | `RANK() OVER (ORDER BY sales DESC)` |
| `DENSE_RANK()` | Rank without gaps (1,2,2,3) | `DENSE_RANK() OVER (ORDER BY sales DESC)` |
| `ROW_NUMBER()` | Sequential numbers (1,2,3,4) | `ROW_NUMBER() OVER (ORDER BY sales DESC)` |
| `NTILE(n)` | Divide into n groups | `NTILE(4) OVER (ORDER BY sales DESC)` |

### Value Functions

| Function | Description | Example |
|----------|-------------|---------|
| `LAG(column, n)` | Value n rows before | `LAG(sales, 1) OVER (ORDER BY date)` |
| `LEAD(column, n)` | Value n rows ahead | `LEAD(sales, 1) OVER (ORDER BY date)` |
| `FIRST_VALUE(column)` | First value in partition | `FIRST_VALUE(sales) OVER (PARTITION BY region)` |
| `LAST_VALUE(column)` | Last value in partition | `LAST_VALUE(sales) OVER (PARTITION BY region)` |

### Aggregate Functions (as Window Functions)

| Function | Description | Example |
|----------|-------------|---------|
| `SUM()` | Running total | `SUM(amount) OVER (ORDER BY date)` |
| `AVG()` | Moving average | `AVG(sales) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` |
| `COUNT()` | Count in window | `COUNT(*) OVER (PARTITION BY category)` |
| `MAX()` | Maximum in window | `MAX(price) OVER (PARTITION BY category)` |
| `MIN()` | Minimum in window | `MIN(price) OVER (PARTITION BY category)` |

### Window Frame Options

| Frame | Description |
|-------|-------------|
| `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` | From start to current |
| `ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING` | From current to end |
| `ROWS BETWEEN n PRECEDING AND m FOLLOWING` | n before, m after |
| `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` | Entire partition |

### Common Patterns

**Running Total:**
```sql
SUM(amount) OVER (PARTITION BY customer_id ORDER BY date)
```

**Moving Average (7 days):**
```sql
AVG(sales) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

**Month-over-Month:**
```sql
LAG(sales, 1) OVER (ORDER BY month)
```

**Top N per Group:**
```sql
SELECT * FROM (
    SELECT *, RANK() OVER (PARTITION BY category ORDER BY sales DESC) as rnk
    FROM products
) WHERE rnk <= 3
```

**Percentile:**
```sql
NTILE(100) OVER (ORDER BY sales DESC)
```


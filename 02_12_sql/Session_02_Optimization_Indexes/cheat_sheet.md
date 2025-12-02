# SQL Optimization Cheat Sheet

## EXPLAIN Commands

| Database | Command |
|----------|---------|
| PostgreSQL | `EXPLAIN ANALYZE SELECT ...` |
| MySQL | `EXPLAIN SELECT ...` |
| SQL Server | `SET SHOWPLAN_ALL ON; SELECT ...` |

## Index Types

### Clustered Index
- One per table
- Determines physical order
- Usually PRIMARY KEY

### Non-Clustered Index
- Multiple per table
- Separate structure
- Best for lookups

### Composite Index
```sql
CREATE INDEX idx_name ON table(col1, col2, col3);
-- Order matters! Leftmost columns used first
```

## Common Anti-Patterns

| ❌ Bad | ✅ Good |
|--------|---------|
| `SELECT *` | `SELECT col1, col2` |
| `WHERE YEAR(date) = 2024` | `WHERE date >= '2024-01-01'` |
| `WHERE col1 = 'A' OR col1 = 'B'` | `WHERE col1 IN ('A', 'B')` |
| Correlated subquery | JOIN with CTE |
| Implicit joins | Explicit JOIN syntax |

## Index Creation

```sql
-- Single column
CREATE INDEX idx_name ON table(column);

-- Composite
CREATE INDEX idx_name ON table(col1, col2);

-- Partial (subset of data)
CREATE INDEX idx_name ON table(column) WHERE condition;

-- Unique
CREATE UNIQUE INDEX idx_name ON table(column);
```

## When to Index

✅ **Good for:**
- WHERE clauses
- JOIN conditions
- ORDER BY
- Foreign keys

❌ **Avoid for:**
- Small tables (< 1000 rows)
- Low selectivity columns
- Frequently updated columns
- Very wide tables

## Query Optimization Checklist

- [ ] Use EXPLAIN to analyze
- [ ] Add indexes on WHERE/JOIN columns
- [ ] Avoid SELECT *
- [ ] Remove functions from WHERE
- [ ] Use explicit JOINs
- [ ] Convert subqueries to JOINs
- [ ] Use LIMIT when appropriate
- [ ] Filter early (WHERE before JOIN)


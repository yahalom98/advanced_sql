# Session 4: Database Design - Exercises

## Exercise 1: Identify Normalization Problems

### Setup
```sql
USE sql_course;

-- This is a BADLY designed table (on purpose!)
CREATE TABLE bad_orders (
    order_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2),
    quantity INT,
    order_date DATE
);
```

### Your Task
Identify ALL normalization problems in this table. List them and explain why they're problems.

### 💡 Hints
- Look for repeated data
- Look for data that depends on other data
- Think about what happens when you need to update customer email
- Think about what happens when a product price changes

---

## Exercise 2: Normalize to 1NF

### Setup
Use the `bad_orders` table from Exercise 1.

### Your Task
Redesign the table to satisfy First Normal Form (1NF).

**Requirements:**
- Each cell should have atomic values
- No repeating groups
- Each row should be unique

### 💡 Hints
- If one order can have multiple products, you need a separate table
- Create an `order_items` table
- Use primary keys and foreign keys

---

## Exercise 3: Normalize to 2NF

### Setup
Assume you've created these tables from Exercise 2:
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),  -- This is the problem!
    quantity INT
);
```

### Your Task
Identify the 2NF violation and fix it.

### 💡 Hints
- `product_name` depends on what? (product_id, not order_item_id)
- Create a separate `products` table
- Reference it with a foreign key

---

## Exercise 4: Normalize to 3NF

### Setup
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    category_description TEXT  -- This is the problem!
);
```

### Your Task
Identify the 3NF violation and fix it.

### 💡 Hints
- `category_description` depends on `category`, not `product_id`
- This is a transitive dependency
- Create a separate `categories` table

---

## Exercise 5: Design One-to-Many Relationship

### Your Task
Design tables for:
- **Customers** (one customer)
- **Orders** (many orders per customer)

Create the tables with proper foreign keys.

### 💡 Hints
- Which table gets the foreign key? (the "many" side)
- Orders table should have `customer_id`
- Use `FOREIGN KEY` constraint

---

## Exercise 6: Design Many-to-Many Relationship

### Your Task
Design tables for:
- **Students** (can enroll in many courses)
- **Courses** (can have many students)

### 💡 Hints
- You need a third table (junction/bridge table)
- Junction table has foreign keys to both tables
- Add `UNIQUE` constraint to prevent duplicate enrollments
- Can add additional columns like `enrollment_date`

---

## Exercise 7: Add Constraints

### Your Task
Create a `products` table with:
- Primary key
- Unique constraint on product code
- Not null on product name and price
- Check constraint: price must be > 0
- Check constraint: discount must be between 0 and 100

### 💡 Hints
- `PRIMARY KEY` for unique identifier
- `UNIQUE` for product code
- `NOT NULL` for required fields
- `CHECK` constraints for business rules (MySQL 8.0+)

---

## Exercise 8: Design Complete E-Commerce Schema

### Your Task
Design a complete normalized database for an e-commerce site with:
- Customers
- Products (with categories)
- Orders
- Order Items
- Reviews (customers can review products)

**Requirements:**
- All tables in 3NF
- Proper primary keys
- Foreign keys with appropriate constraints
- At least one many-to-many relationship (if applicable)

### 💡 Hints
- Start with entities (tables)
- Identify relationships
- Add foreign keys
- Consider: Can a customer have many orders? (Yes - one-to-many)
- Can a product be in many orders? (Yes - through order_items)
- Can a customer review many products? (Yes - one-to-many)
- Can a product have many reviews? (Yes - one-to-many)

---

## Exercise 9: Test Foreign Key Constraints

### Setup
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### Your Task
1. Insert a customer
2. Insert an order for that customer (should work)
3. Try to insert an order with a non-existent customer_id (should fail)
4. Test `ON DELETE CASCADE`: Delete a customer and see what happens to their orders

### 💡 Hints
- Foreign keys prevent invalid data
- `ON DELETE CASCADE` automatically deletes related rows
- Test both valid and invalid inserts

---

## Exercise 10: Fix a Real-World Design

### Setup
```sql
-- A real but poorly designed table
CREATE TABLE user_activity (
    user_id INT,
    activity_date DATE,
    page_views INT,
    clicks INT,
    purchases INT,
    revenue DECIMAL(10,2),
    user_name VARCHAR(100),
    user_email VARCHAR(100),
    page_name VARCHAR(100),
    page_category VARCHAR(50)
);
```

### Your Task
Redesign this to be properly normalized. Consider:
- What are the main entities?
- What are the relationships?
- What data is repeated?
- What depends on what?

### 💡 Hints
- Separate users, pages, and activities
- Activity table links users and pages
- Remove redundant user and page info from activity table

---

## ✅ Practice Tips

1. **Always identify entities first** - What are the main "things"?
2. **Then identify relationships** - How do they connect?
3. **Look for repeated data** - That's usually a normalization issue
4. **Think about updates** - What happens if you need to change data?
5. **Test your design** - Insert sample data and see if it makes sense

---

**Ready for solutions?** Check the [SOLUTIONS.md](./SOLUTIONS.md) file!


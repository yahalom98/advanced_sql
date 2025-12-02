# Session 4: Database Design - Solutions with Explanations

## Exercise 1: Identify Normalization Problems

### Problems Identified

1. **Customer data repeated** - `customer_name`, `customer_email`, `customer_phone` repeated for each order
   - **Problem**: If customer changes email, need to update many rows
   - **Problem**: Wastes storage space

2. **Product data repeated** - `product_name`, `product_category`, `product_price` repeated
   - **Problem**: If product price changes, need to update many rows
   - **Problem**: Historical orders would show wrong price

3. **Multiple products per order** - Can't easily store multiple products in one order
   - **Problem**: Would need multiple rows per order (violates 1NF if not done properly)

4. **No primary key** - `order_id` not defined as PRIMARY KEY
   - **Problem**: Can't uniquely identify rows

5. **No relationships** - No foreign keys
   - **Problem**: Can't enforce data integrity

### Explanation
This table violates all three normal forms:
- **1NF**: If an order has multiple products, you'd need multiple rows (but then customer data repeats)
- **2NF**: Product data depends on product, not order
- **3NF**: Category description depends on category, not product

---

## Exercise 2: Normalize to 1NF

### Solution
```sql
-- Separate customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20)
);

-- Separate orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Separate products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2)
);

-- Order items (handles multiple products per order)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Explanation
- **1NF requires**: Atomic values, no repeating groups, unique rows
- **Solution**: 
  - Separated into 4 tables
  - Each cell has one value
  - Multiple products per order handled by `order_items` table
  - Each row is unique (primary keys)

### Why This Works
By separating into multiple tables, we eliminate repeating groups. Each table has a single purpose, and relationships are handled through foreign keys. This satisfies 1NF.

---

## Exercise 3: Normalize to 2NF

### Solution
```sql
-- Products table (separate from order_items)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2)
);

-- Order items (references product, doesn't store product data)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,  -- Foreign key, not product_name!
    quantity INT,
    unit_price DECIMAL(10,2),  -- Store price at time of order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Explanation
- **2NF violation**: `product_name` in `order_items` depends only on `product_id`, not on `order_item_id`
- **This is a partial dependency** - the product name is not fully dependent on the order item's primary key
- **Solution**: Remove `product_name` from `order_items`, reference `products` table via `product_id`
- **Note**: We store `unit_price` in `order_items` to preserve historical pricing (price at time of order)

### Why This Works
2NF eliminates partial dependencies. Product information belongs in the `products` table, not repeated in `order_items`. The foreign key maintains the relationship without storing redundant data.

---

## Exercise 4: Normalize to 3NF

### Solution
```sql
-- Categories table (separate)
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    category_description TEXT
);

-- Products table (references category)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,  -- Foreign key, not category name!
    product_price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

### Explanation
- **3NF violation**: `category_description` depends on `category`, not on `product_id`
- **This is a transitive dependency** - category description is not directly about the product
- **Solution**: Create separate `categories` table, reference it via `category_id` foreign key

### Why This Works
3NF eliminates transitive dependencies. Category information belongs in the `categories` table. If category description changes, we update one place, not many product rows.

---

## Exercise 5: Design One-to-Many Relationship

### Solution
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,  -- Foreign key on the "many" side
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

### Explanation
- **One-to-Many**: One customer has many orders
- **Foreign key placement**: Goes on the "many" side (orders table)
- **Why**: Each order belongs to one customer, so `orders` table has `customer_id`
- **Relationship**: `customer_id` in `orders` references `customer_id` in `customers`

### Why This Works
In a one-to-many relationship, the foreign key always goes on the "many" side. This allows one customer to have multiple orders, but each order belongs to exactly one customer.

---

## Exercise 6: Design Many-to-Many Relationship

### Solution
```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    instructor VARCHAR(100)
);

-- Junction table (connects students and courses)
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE(student_id, course_id)  -- Prevent duplicate enrollments
);
```

### Explanation
- **Many-to-Many**: Students enroll in many courses, courses have many students
- **Junction table**: Required to connect the two tables
  - Has foreign keys to both tables
  - Can have additional columns (enrollment_date, grade)
- **UNIQUE constraint**: Prevents a student from enrolling in the same course twice
- **Primary key**: `enrollment_id` uniquely identifies each enrollment

### Why This Works
Many-to-many relationships require a third table (junction/bridge table) because you can't put a foreign key in either of the main tables (each would need to reference multiple rows). The junction table solves this by having foreign keys to both tables.

---

## Exercise 7: Add Constraints

### Solution
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) UNIQUE,  -- Unique constraint
    product_name VARCHAR(100) NOT NULL,  -- Not null
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),  -- Not null + check
    discount INT CHECK (discount >= 0 AND discount <= 100),  -- Check constraint
    description TEXT
);
```

### Explanation
- **PRIMARY KEY**: `product_id` - uniquely identifies each row
- **UNIQUE**: `product_code` - no two products can have the same code
- **NOT NULL**: `product_name` and `price` - required fields
- **CHECK constraints**: 
  - `price > 0` - price must be positive
  - `discount >= 0 AND discount <= 100` - discount must be valid percentage
- **Note**: CHECK constraints require MySQL 8.0.16+

### Why This Works
Constraints enforce data integrity at the database level. They prevent invalid data from being inserted, ensuring your data always follows business rules. This is better than checking in application code because it's enforced regardless of how data is inserted.

---

## Exercise 8: Design Complete E-Commerce Schema

### Solution
```sql
-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE
);

-- Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    description TEXT
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Reviews (one-to-many: customer to reviews, product to reviews)
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Explanation
- **All in 3NF**: 
  - Customer data in `customers` table
  - Product data in `products` table
  - Category data in `categories` table
  - No transitive dependencies
- **Relationships**:
  - Customer → Orders (one-to-many)
  - Order → Order Items (one-to-many)
  - Product → Order Items (one-to-many)
  - Category → Products (one-to-many)
  - Customer → Reviews (one-to-many)
  - Product → Reviews (one-to-many)
- **Primary keys**: All tables have auto-increment primary keys
- **Foreign keys**: All relationships properly defined

### Why This Works
This design is fully normalized and handles all relationships correctly. Each entity has its own table, relationships are through foreign keys, and there's no data redundancy. This makes the database efficient, maintainable, and scalable.

---

## Exercise 9: Test Foreign Key Constraints

### Solution

**Step 1: Insert customer**
```sql
INSERT INTO customers (name) VALUES ('Alice');
-- customer_id = 1 (auto-increment)
```

**Step 2: Insert order (should work)**
```sql
INSERT INTO orders (customer_id, order_date) 
VALUES (1, '2024-01-01');
-- ✅ Works! customer_id 1 exists
```

**Step 3: Insert order with invalid customer_id (should fail)**
```sql
INSERT INTO orders (customer_id, order_date) 
VALUES (999, '2024-01-01');
-- ❌ Error: Cannot add or update a child row: foreign key constraint fails
```

**Step 4: Test ON DELETE CASCADE**
```sql
-- First, recreate table with CASCADE
DROP TABLE orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE  -- Delete orders when customer deleted
);

-- Insert test data
INSERT INTO orders (customer_id, order_date) VALUES (1, '2024-01-01');

-- Delete customer
DELETE FROM customers WHERE customer_id = 1;

-- Check orders
SELECT * FROM orders;  -- Order is automatically deleted!
```

### Explanation
- **Foreign key constraints**: Prevent invalid data
  - Can't insert order with non-existent customer_id
  - Database enforces referential integrity
- **ON DELETE CASCADE**: Automatically deletes related rows
  - When customer deleted, their orders are deleted too
  - Alternative: `ON DELETE SET NULL` (sets foreign key to NULL)
  - Alternative: `ON DELETE RESTRICT` (prevents deletion if related rows exist)

### Why This Works
Foreign keys ensure data integrity. You can't have "orphaned" records (orders without customers). CASCADE options handle what happens when referenced rows are deleted, maintaining consistency automatically.

---

## Exercise 10: Fix a Real-World Design

### Solution
```sql
-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100),
    user_email VARCHAR(100)
);

-- Pages table
CREATE TABLE pages (
    page_id INT PRIMARY KEY AUTO_INCREMENT,
    page_name VARCHAR(100),
    page_category VARCHAR(50)
);

-- User activity table (links users and pages)
CREATE TABLE user_activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    page_id INT,
    activity_date DATE,
    page_views INT,
    clicks INT,
    purchases INT,
    revenue DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (page_id) REFERENCES pages(page_id)
);
```

### Explanation
- **Problems in original**:
  - User data repeated for each activity
  - Page data repeated for each activity
  - Mixing entities (users, pages, activities) in one table
- **Solution**:
  - Separate `users` table - user info stored once
  - Separate `pages` table - page info stored once
  - `user_activity` table - links users and pages, stores activity metrics
  - Foreign keys maintain relationships

### Why This Works
The original design violated normalization by mixing different entities. By separating into three tables, we eliminate redundancy and make the database more efficient. Activity data is now properly linked to users and pages through foreign keys.

---

## Key Takeaways

1. **1NF**: Atomic values, no repeating groups
2. **2NF**: No partial dependencies (all non-key columns depend on full primary key)
3. **3NF**: No transitive dependencies (non-key columns depend only on primary key)
4. **One-to-Many**: Foreign key on "many" side
5. **Many-to-Many**: Requires junction table
6. **Constraints**: Enforce data integrity (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK)

---

## Common Mistakes to Avoid

1. ❌ Putting foreign key on wrong side of one-to-many relationship
2. ❌ Forgetting junction table for many-to-many relationships
3. ❌ Storing calculated/derived data (like total_amount that should be SUM of items)
4. ❌ Not using foreign keys (losing referential integrity)
5. ❌ Over-normalizing (sometimes denormalization is okay for performance)

---

**Great job! You're now designing databases like a pro!** 🗄️


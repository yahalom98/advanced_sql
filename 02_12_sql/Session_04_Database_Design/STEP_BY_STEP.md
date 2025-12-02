# Session 4: Step-by-Step Tutorial - Database Design

## 🎯 Goal
Learn to design database schemas step-by-step with simple examples in MySQL.

---

## Step 1: Understanding Normalization (Simple)

### 1.1 The Problem: Bad Design
```sql
-- ❌ BAD: Everything in one table
CREATE TABLE bad_orders (
    order_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    product_name VARCHAR(100),
    product_price DECIMAL(10,2),
    quantity INT
);

-- Problems:
-- 1. Customer info repeated for each order
-- 2. Product info repeated
-- 3. Hard to update customer email
-- 4. Wastes space
```

### 1.2 The Solution: Good Design
```sql
-- ✅ GOOD: Separate tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

**Why this is better:**
- Customer info stored once
- Product info stored once
- Easy to update
- Saves space

---

## Step 2: First Normal Form (1NF)

### 2.1 Rule: One value per cell

**❌ BAD:**
```sql
CREATE TABLE bad_products (
    product_id INT,
    product_name VARCHAR(100),
    categories VARCHAR(200) -- "Electronics, Computers, Laptops"
);
```

**✅ GOOD:**
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

CREATE TABLE product_categories (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

---

## Step 3: Second Normal Form (2NF)

### 3.1 Rule: No partial dependencies

**❌ BAD:**
```sql
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    product_name VARCHAR(100), -- Depends only on product_id, not order_item_id!
    quantity INT
);
```

**✅ GOOD:**
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

**Why:** `product_name` belongs in `products` table, not `order_items`

---

## Step 4: Third Normal Form (3NF)

### 4.1 Rule: No transitive dependencies

**❌ BAD:**
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    category_description TEXT -- Depends on category, not product_id!
);
```

**✅ GOOD:**
```sql
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50),
    category_description TEXT
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

---

## Step 5: Relationships

### 5.1 One-to-Many (1:N)

**Example:** One customer has many orders

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

**How it works:**
- `customer_id` in `orders` table
- One customer → Many orders
- Foreign key links them

### 5.2 Many-to-Many (M:N)

**Example:** Students enroll in many courses, courses have many students

```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100)
);

-- Junction table (connects students and courses)
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE(student_id, course_id) -- Prevent duplicate enrollments
);
```

**How it works:**
- Need a third table (junction table)
- Links two tables together
- Can have additional columns (like enrollment_date)

---

## Step 6: Constraints

### 6.1 Primary Key
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100)
);
```

### 6.2 Foreign Key
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE  -- Delete orders when customer deleted
);
```

### 6.3 Unique
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE,  -- No duplicate emails
    username VARCHAR(50) UNIQUE
);
```

### 6.4 Not Null
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,  -- Must have a date
    customer_id INT NOT NULL
);
```

### 6.5 Check (MySQL 8.0+)
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(10,2) CHECK (price > 0),  -- Price must be positive
    discount INT CHECK (discount >= 0 AND discount <= 100)
);
```

---

## Step 7: Practice - Design a Simple E-Commerce Database

### 7.1 Requirements
- Customers can place orders
- Orders contain multiple products
- Products belong to categories
- Track order status

### 7.2 Your Design
```sql
-- Step 1: Create customers table
-- Write your SQL here

-- Step 2: Create categories table
-- Write your SQL here

-- Step 3: Create products table
-- Write your SQL here

-- Step 4: Create orders table
-- Write your SQL here

-- Step 5: Create order_items table
-- Write your SQL here
```

<details>
<summary>💡 Solution</summary>

```sql
-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_date DATE
);

-- Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

</details>

---

## Step 8: Test Your Design

### 8.1 Insert sample data
```sql
-- Insert customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@email.com'),
('Bob', 'bob@email.com');

-- Insert categories
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing');

-- Insert products
INSERT INTO products (product_name, price, category_id) VALUES
('Laptop', 1000.00, 1),
('T-Shirt', 20.00, 2);

-- Insert orders
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-01-01', 'completed'),
(2, '2024-01-02', 'pending');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 1, 1);
```

### 8.2 Test queries
```sql
-- Get order with customer and products
SELECT 
    o.order_id,
    c.name as customer_name,
    p.product_name,
    oi.quantity,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

---

## Step 9: Common Design Patterns

### 9.1 Status Tracking
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    status VARCHAR(20) DEFAULT 'pending',
    -- Or use enum:
    -- status ENUM('pending', 'processing', 'shipped', 'delivered')
);
```

### 9.2 Timestamps
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 9.3 Soft Deletes
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    deleted_at TIMESTAMP NULL  -- NULL = not deleted
);
```

---

## ✅ Check Your Understanding

1. What is normalization?
2. What's the difference between 1NF, 2NF, and 3NF?
3. How do you create a one-to-many relationship?
4. How do you create a many-to-many relationship?
5. What is a foreign key?

---

## 🎯 Next Steps

- Design your own database
- Try the exercises in the main README
- Practice with real scenarios

**Ready for Session 5?** Let's build a complete project!


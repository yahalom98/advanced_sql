# Session 4: Database Design + Normalization + Constraints

## 🚀 Start Here: Step-by-Step Tutorial

**New to database design?** Start with the step-by-step guide:
👉 **[STEP_BY_STEP.md](./STEP_BY_STEP.md)** - Simple, beginner-friendly tutorial

## 📋 Session Overview

**Duration:** 3 hours  
**Focus:** Database architecture, normalization, and schema design

---

## 🎯 Learning Objectives

By the end of this session, you will:
- Understand normalization forms (1NF, 2NF, 3NF)
- Design database schemas from product requirements
- Create proper relationships (one-to-many, many-to-many)
- Implement constraints and foreign keys
- Build ERDs (Entity Relationship Diagrams)
- Reverse engineer databases from real scenarios

---

## 📖 Mini-Lecture (20-30 min)

### Database Design Process

1. **Requirements Gathering**: Understand the business needs
2. **Entity Identification**: Find the main entities (tables)
3. **Relationship Mapping**: Define how entities relate
4. **Attribute Assignment**: Assign columns to entities
5. **Normalization**: Eliminate redundancy
6. **Constraint Definition**: Add rules and relationships

### Normalization Forms

#### First Normal Form (1NF)
**Rules:**
- Each column contains atomic values (no arrays/lists)
- Each row is unique
- No repeating groups

**Example - Violation:**
```sql
-- ❌ BAD: Multiple values in one column
CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(100),
    products VARCHAR(500) -- "Laptop, Mouse, Keyboard"
);
```

**Example - Fixed:**
```sql
-- ✅ GOOD: Separate table for order items
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);
```

#### Second Normal Form (2NF)
**Rules:**
- Must be in 1NF
- All non-key attributes fully depend on the primary key

**Example - Violation:**
```sql
-- ❌ BAD: product_name depends only on product_id, not order_id
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    product_name VARCHAR(100), -- Partial dependency!
    quantity INT
);
```

**Example - Fixed:**
```sql
-- ✅ GOOD: Separate products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

#### Third Normal Form (3NF)
**Rules:**
- Must be in 2NF
- No transitive dependencies (non-key attributes depend only on the primary key)

**Example - Violation:**
```sql
-- ❌ BAD: category_description depends on category, not product_id
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    category_description TEXT -- Transitive dependency!
);
```

**Example - Fixed:**
```sql
-- ✅ GOOD: Separate categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    category_description TEXT
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

### Relationship Types

#### One-to-Many (1:N)
**Example:** One customer has many orders
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

#### Many-to-Many (M:N)
**Example:** Students enroll in many courses, courses have many students
```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

-- Junction/Bridge table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE(student_id, course_id) -- Prevent duplicate enrollments
);
```

#### One-to-One (1:1)
**Example:** User has one profile
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    email VARCHAR(100)
);

CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY,
    user_id INT UNIQUE, -- UNIQUE ensures 1:1
    bio TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### Constraints

#### Primary Key
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    -- or
    product_id INT,
    PRIMARY KEY (product_id)
);
```

#### Foreign Key
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    -- With options:
    ON DELETE CASCADE  -- Delete orders when customer deleted
    ON UPDATE CASCADE  -- Update order.customer_id when customer.customer_id changes
);
```

#### Unique Constraint
```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    username VARCHAR(50) UNIQUE
);
```

#### Check Constraint
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    price DECIMAL(10,2) CHECK (price > 0),
    discount_percent INT CHECK (discount_percent >= 0 AND discount_percent <= 100)
);
```

#### Not Null Constraint
```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL
);
```

### ERD (Entity Relationship Diagram)

**Components:**
- **Entities**: Rectangles (tables)
- **Attributes**: Ovals (columns)
- **Relationships**: Diamonds (connections)
- **Cardinality**: 1, N, M (one, many)

**Tools:**
- Draw.io
- Lucidchart
- dbdiagram.io
- pgAdmin (for PostgreSQL)

---

## 💻 Hands-On Exercises (1.5-2 hours)

### Exercise 1: Design DB Schema for Netflix-like App

**Requirements:**
- Users can have multiple profiles
- Users can watch content (movies, TV shows)
- Content has genres, actors, directors
- Users can rate content
- Track watch history and progress

**Your Task:**
1. Identify entities
2. Define relationships
3. Create normalized schema (3NF)
4. Add appropriate constraints
5. Create ERD

[📝 Solution](./solutions/exercise_01_solution.sql)

---

### Exercise 2: Design Food Ordering System

**Requirements:**
- Restaurants offer multiple menu items
- Customers place orders with multiple items
- Orders have delivery addresses
- Track order status (pending, preparing, out for delivery, delivered)
- Customers can leave reviews for restaurants

**Your Task:**
1. Design complete schema
2. Handle many-to-many relationships
3. Include status tracking
4. Add constraints

[📝 Solution](./solutions/exercise_02_solution.sql)

---

### Exercise 3: Design CRM System

**Requirements:**
- Companies have multiple contacts
- Sales reps manage multiple accounts
- Track deals (opportunities) with stages
- Log activities (calls, emails, meetings)
- Products can be associated with deals

**Your Task:**
1. Design schema
2. Support sales pipeline
3. Activity tracking
4. Proper relationships

[📝 Solution](./solutions/exercise_03_solution.sql)

---

### Exercise 4: Identify and Fix Normalization Errors

**Task:** Given a poorly designed schema, identify violations and fix them.

**Given Schema:**
```sql
CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_address VARCHAR(200),
    order_date DATE,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2),
    quantity INT,
    total_amount DECIMAL(10,2)
);
```

**Your Task:**
1. Identify all normalization violations
2. Redesign to 3NF
3. Create proper relationships
4. Add constraints

[📝 Solution](./solutions/exercise_04_solution.sql)

---

### Exercise 5: Implement Constraints and Test Violations

**Task:** Create tables with constraints and test that violations are rejected.

**Your Task:**
1. Create schema with all constraint types
2. Insert valid data
3. Attempt to insert invalid data (should fail)
4. Test CASCADE rules on foreign keys

[📝 Solution](./solutions/exercise_05_solution.sql)

---

## 🎯 Final Challenge: Build ERD + Schema for a Product

**Objective:** Design a complete database schema for a real-world product from scratch.

### Choose One Product

#### Option 1: Social Media Platform
- Users, posts, comments, likes, follows
- Stories, messages, notifications
- Hashtags, trending topics

#### Option 2: E-Learning Platform
- Courses, lessons, instructors
- Student enrollments, progress tracking
- Quizzes, assignments, grades
- Certificates

#### Option 3: Fitness Tracking App
- Users, workouts, exercises
- Goals, achievements, streaks
- Social features (friends, challenges)
- Nutrition tracking

#### Option 4: Event Management System
- Events, venues, organizers
- Attendees, tickets, pricing tiers
- Check-ins, feedback
- Waitlists

### Requirements

1. **Complete ERD**
   - All entities and relationships
   - Cardinality clearly shown
   - Use a diagramming tool

2. **Normalized Schema (3NF)**
   - DDL for all tables
   - Proper primary keys
   - Foreign keys with appropriate CASCADE rules
   - Unique constraints where needed
   - Check constraints for business rules
   - Not NULL constraints

3. **Sample Data**
   - INSERT statements with realistic data
   - At least 5-10 rows per main table

4. **Documentation**
   - Explain design decisions
   - Justify normalization choices
   - Describe relationships
   - Note any assumptions

### Deliverable

Submit:
1. **ERD diagram** (image or link)
2. **Complete DDL script** (all CREATE TABLE statements)
3. **Sample data script** (INSERT statements)
4. **Design document** (2-3 pages explaining your design)

**Evaluation Criteria:**
- ✅ Proper normalization (3NF)
- ✅ Correct relationships
- ✅ Appropriate constraints
- ✅ Scalable design
- ✅ Clear documentation

[💡 Design Guidelines](./design_guidelines.md)

---

## 📚 Additional Resources

- [Database Design Fundamentals](./design_fundamentals.md)
- [Normalization Examples](./normalization_examples.md)
- [ERD Tools Guide](./erd_tools.md)

---

## ✅ Session Checklist

- [ ] Completed Exercise 1: Netflix Schema
- [ ] Completed Exercise 2: Food Ordering System
- [ ] Completed Exercise 3: CRM System
- [ ] Completed Exercise 4: Fix Normalization Errors
- [ ] Completed Exercise 5: Implement Constraints
- [ ] Completed Final Challenge: Product Schema Design
- [ ] Reviewed all solutions
- [ ] Understand normalization and design principles

---

**Next Session:** [Session 5 - Full Project Case Study](../Session_05_Case_Study/)


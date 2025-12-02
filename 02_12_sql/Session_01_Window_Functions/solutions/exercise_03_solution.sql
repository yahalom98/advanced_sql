-- Exercise 3 Solution: Top 3 Products per Category

-- Method 1: Using RANK() with subquery
SELECT 
    category,
    product_name,
    units_sold,
    rank_in_category
FROM (
    SELECT 
        category,
        product_name,
        units_sold,
        RANK() OVER (PARTITION BY category ORDER BY units_sold DESC) as rank_in_category
    FROM product_sales
) ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;

-- Method 2: Using DENSE_RANK() (handles ties differently)
SELECT 
    category,
    product_name,
    units_sold,
    dense_rank_in_category
FROM (
    SELECT 
        category,
        product_name,
        units_sold,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY units_sold DESC) as dense_rank_in_category
    FROM product_sales
) ranked
WHERE dense_rank_in_category <= 3
ORDER BY category, dense_rank_in_category;

-- Method 3: Using ROW_NUMBER() (no ties, arbitrary selection)
SELECT 
    category,
    product_name,
    units_sold,
    row_num
FROM (
    SELECT 
        category,
        product_name,
        units_sold,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY units_sold DESC) as row_num
    FROM product_sales
) ranked
WHERE row_num <= 3
ORDER BY category, row_num;


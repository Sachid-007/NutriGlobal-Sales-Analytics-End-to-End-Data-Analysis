-- ============================================
-- NutriGlobal Sales Analysis
-- Script 3: Data Cleaning
-- ============================================

-- Create cleaned table from raw
-- We standardize text columns (trim whitespace, proper casing)
-- and keep raw table untouched as source of truth

CREATE TABLE cleaned_supplement_sales AS
SELECT
    date,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    units_sold,
    price,
    revenue,
    discount,
    units_returned,
    TRIM(location) AS location,
    TRIM(platform) AS platform
FROM raw_supplement_sales;
-- new cleaned table created with standardized text columns and raw data preserved

-- verifying the cleaned table
SELECT COUNT(*)
FROM cleaned_supplement_sales;
-- 4384 total records in the cleaned table


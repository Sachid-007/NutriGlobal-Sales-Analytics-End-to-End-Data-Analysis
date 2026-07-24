--Checking sample of data format

SELECT *
FROM raw_supplement_sales
LIMIT 10

-- Counting total rows
SELECT COUNT(*) 
FROM raw_supplement_sales
-- 4384 rows counted

-- checking null values
SELECT
    COUNT(*) FILTER (WHERE date IS NULL) AS null_date,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_product,
    COUNT(*) FILTER (WHERE category IS NULL) AS null_category,
    COUNT(*) FILTER (WHERE units_sold IS NULL) AS null_units_sold,
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE revenue IS NULL) AS null_revenue,
    COUNT(*) FILTER (WHERE discount IS NULL) AS null_discount,
    COUNT(*) FILTER (WHERE units_returned IS NULL) AS null_units_returned,
    COUNT(*) FILTER (WHERE location IS NULL) AS null_location,
    COUNT(*) FILTER (WHERE platform IS NULL) AS null_platform
FROM raw_supplement_sales;
-- no null values found in any of the columns

-- checking for duplicate rows


SELECT date, product_name, location, platform, COUNT(*) AS duplicate_count
FROM raw_supplement_sales
GROUP BY date, product_name, location, platform
HAVING COUNT(*) > 1;
-- no duplicate found

-- checking distinct locations - confirming only USA, UK, Canada exist
SELECT 
DISTINCT location
FROM raw_supplement_sales;
--no other locations found, only USA, UK, Canada exist


-- Checking distinct platforms — confirming only Amazon, Walmart, iHerb:
SELECT 
DISTINCT platform 
FROM raw_supplement_sales;
-- no other platforms found, only Amazon, Walmart, iHerb exist

-- Checking distinct categories:
SELECT 
DISTINCT category 
FROM raw_supplement_sales;
-- no other categories found

-- Checking for negative or zero values — units sold and revenue can't be zero or negative:

SELECT COUNT(*) AS bad_units_sold
FROM raw_supplement_sales
WHERE units_sold <= 0;

SELECT COUNT(*) AS bad_revenue
FROM raw_supplement_sales
WHERE revenue <= 0;
-- no negative or zero values found in units_sold and revenue columns

-- Checking date range — confirming data covers 2020 to 2024:
SELECT 
MIN(date) AS earliest, 
MAX(date) AS latest
FROM raw_supplement_sales;
-- earliest date is 2020-01-06 and latest date is 2025-03-31

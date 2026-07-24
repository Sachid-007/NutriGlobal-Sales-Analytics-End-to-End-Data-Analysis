-- ============================================
-- NutriGlobal Sales Analysis
-- Script 5: Reporting Views
-- ============================================

-- View 1: Overall Sales Overview (vw_sales_overview)

CREATE OR REPLACE VIEW vw_sales_overview AS
SELECT
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM cleaned_supplement_sales;

-- View 2: Country Performance (vw_country_performance)

CREATE OR REPLACE VIEW vw_country_performance AS
SELECT
    location,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM cleaned_supplement_sales
GROUP BY location
ORDER BY total_revenue DESC;

-- View 3: Category Performance (vw_category_performance)

CREATE OR REPLACE VIEW vw_category_performance AS
SELECT
    category,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(
        SUM(revenue) * 100.0 /
        SUM(SUM(revenue)) OVER (),
        2
    ) AS revenue_pct
FROM cleaned_supplement_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- View 4: Platform Performance (vw_platform_performance)

CREATE OR REPLACE VIEW vw_platform_performance AS
SELECT
    platform,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM cleaned_supplement_sales
GROUP BY platform
ORDER BY total_revenue DESC;

-- View 5: Monthly Sales Trend (vw_monthly_sales_trend)

CREATE OR REPLACE VIEW vw_monthly_sales_trend AS
SELECT
    DATE_TRUNC('month', date)::date AS month,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned
FROM cleaned_supplement_sales
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

-- View 6: Product Performance (vw_product_performance)

CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    product_name,
    category,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(
        SUM(units_returned) * 100.0 / SUM(units_sold),
        2
    ) AS return_rate_pct
FROM cleaned_supplement_sales
GROUP BY product_name, category
ORDER BY total_revenue DESC;

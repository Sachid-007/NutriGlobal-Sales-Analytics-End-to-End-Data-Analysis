
--NutriGlobal Sales Analysis
 --Script 1: Database Schema, Table creation & Data Import





CREATE TABLE raw_supplement_sales (
    date DATE,
    product_name TEXT,
    category TEXT,
    units_sold INT,
    price NUMERIC(10,2),
    revenue NUMERIC(10,2),
    discount NUMERIC(10,2),
    units_returned INT,
    location TEXT,
    platform TEXT
);


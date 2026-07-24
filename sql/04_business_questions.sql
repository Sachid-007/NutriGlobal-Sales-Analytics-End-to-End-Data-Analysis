-- Sales Performance
-- 1. Total revenue and total units sold 

SELECT 
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned
FROM cleaned_supplement_sales;
 -- 22913280.45 total revenue, 658478 total units sold, 6714 total units returned

-- 2. Revenue by product — which products make the most money
SELECT 
    product_name,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold
FROM cleaned_supplement_sales
GROUP BY product_name
ORDER BY total_revenue DESC;
-- Biotin makes the most money and Zinc comes second

output:
product_name      | total_revenue     | total_units_sold
"Biotin"	        1486798.62	               41533
"Zinc"	            1482546.95	               41204
"Pre-Workout"	    1477183.78	               41287
"BCAA"	            1464819.63	               41027
"Fish Oil"	         1451065.87	               41325
"Green Tea Extract"	  1440900.05	           40743
"Collagen Peptides"	  1433297.24	           40856
"Creatine"	          1432518.40	           41236
"Iron Supplement"	  1431582.41	           41194
"Whey Protein"	      1422194.85	           41264
"Vitamin C"	         1421998.07	               40727
"Electrolyte Powder"  1411951.38            	41065
"Ashwagandha"	         1405700.79	            41408
"Melatonin"         	1397315.79	            41165
"Multivitamin"	         1391427.99	           41174
"Magnesium"         	1361978.63	            41270

-- 3. Revenue by category
SELECT 
    category,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (), 2) AS revenue_pct
FROM cleaned_supplement_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Vitamin is the top category and Mineral is the 2nd

output:
category           | total_revenue        | revenue_pct
"Vitamin"	          4300224.68	          18.77
"Mineral"	          4276107.99	          18.66
"Performance"	      2909702.18	          12.70
"Protein"	          2855492.09	          12.46
"Amino Acid"	      1464819.63	          6.39
"Omega"        	      1451065.87	          6.33
"Fat Burner"	      1440900.05	          6.29
"Hydration"	          1411951.38	          6.16
"Herbal"	          1405700.79	          6.13
"Sleep Aid"	           1397315.79	          6.10

-- Geographic Performance
-- 4. Revenue by country
SELECT 
    location,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM cleaned_supplement_sales
GROUP BY location
ORDER BY total_revenue DESC;

output:
location      | total_revenue     | total_units_sold | avg_order_value
"Canada"	    7848579.73	           226053	         5208.08
"UK"	        7703960.34	           221237	         5223.02
"USA"	        7360740.38	           211188	         5250.17


-- Marketplace Performance
-- 5. Revenue by platform:
SELECT 
    platform,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(revenue), 2) AS avg_order_value
FROM cleaned_supplement_sales
GROUP BY platform
ORDER BY total_revenue DESC;

output:
platform      | total_revenue     | total_units_sold | avg_order_value
"iHerb"	         7855261.05	            225427	          5240.33
"Amazon"	     7669451.78	            220623	          5206.69
"Walmart"	     7388567.62	            212428	           5232.70


-- Product Performance
--6. Return rate by product — identifies problem products:
SELECT 
    product_name,
    SUM(units_sold) AS total_units_sold,
    SUM(units_returned) AS total_units_returned,
    ROUND(SUM(units_returned) * 100.0 / SUM(units_sold), 2) AS return_rate_pct
FROM cleaned_supplement_sales
GROUP BY product_name
ORDER BY return_rate_pct DESC;

output:
product_name           | total_units_sold | total_units_returned | return_rate_pct
"Vitamin C"	                40727	                457	                1.12
"Electrolyte Powder"	    41065	                441	                1.07
"Collagen Peptides"	        40856	                427	                1.05
"Magnesium"	                41270	                431	                1.04
"BCAA"	                    41027	                428	                1.04
"Multivitamin"	            41174	                425                	1.03
"Iron Supplement"	        41194	                426	                1.03
"Pre-Workout"	            41287	                426	                1.03
"Green Tea Extract"	        40743	                417	                1.02
"Creatine"	                41236	                415	                1.01
"Melatonin"	                41165	                408	                0.99
"Whey Protein"	            41264	                409                	0.99
"Biotin"	                41533                   411                	0.99
"Fish Oil"	                41325	                407	                0.98
"Zinc"	                    41204	                394                	0.96
"Ashwagandha"	            41408	                392	                0.95


--Time Analysis
--7. Revenue by year — shows overall growth or decline:
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold
FROM cleaned_supplement_sales
GROUP BY year
ORDER BY year;

output:
year | total_revenue | total_units_sold
2020	4323393.22	     124657
2021	4294248.17	     124701
2022	4372808.55	     125167
2023	4470870.75	     125038
2024	4429367.35	     127707
2025	1022592.41	     31208


-- 8. Revenue by month across all years — reveals seasonality:
WITH monthly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM date)::INT AS year,
        EXTRACT(MONTH FROM date)::INT AS month_num,
        TO_CHAR(date, 'Month') AS month_name,
        SUM(revenue) AS total_revenue
    FROM cleaned_supplement_sales
    GROUP BY
        EXTRACT(YEAR FROM date),
        EXTRACT(MONTH FROM date),
        TO_CHAR(date, 'Month')
		),
ranked_months AS (
    SELECT
        year,
        month_num,
        month_name,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY total_revenue DESC) AS high_rank,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY total_revenue ASC) AS low_rank
    FROM monthly_revenue
)
SELECT
    year,
    MAX(CASE WHEN high_rank = 1 THEN month_name END) AS highest_revenue_month,
    MAX(CASE WHEN high_rank = 1 THEN total_revenue END) AS highest_revenue,
    MAX(CASE WHEN low_rank = 1 THEN month_name END) AS lowest_revenue_month,
    MAX(CASE WHEN low_rank = 1 THEN total_revenue END) AS lowest_revenue
FROM ranked_months
GROUP BY year
ORDER BY year;

output:
year | highest_revenue_month | highest_revenue | lowest_revenue_month | lowest_revenue
2020	"June     "	               422113.85	     "January  "	      290723.89
2021	"August   "                441547.72	     "April    "	      311530.28
2022	"January  "	               434031.13	     "April    "	      304012.58
2023	"May      "	               450800.65	     "November "	      309596.51
2024	"September"	               450081.31	     "February "	      322030.56
2025	"March    "	               375859.01	     "January  "	      304965.15


-- 9. Monthly revenue trend over time — full time series:
SELECT 
    DATE_TRUNC('month', date)::date AS month,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold
FROM cleaned_supplement_sales
GROUP BY 1
ORDER BY 1;

output:
month      | total_revenue | total_units_sold
"2020-01-01"	290723.89	9547
"2020-02-01"	355213.26	9493
"2020-03-01"	416547.17	12145
"2020-04-01"	326287.92	9605
"2020-05-01"	333210.99	9557
"2020-06-01"	422113.85	11972
"2020-07-01"	341776.22	9577
"2020-08-01"	413832.50	12085
"2020-09-01"	331064.85	9430
"2020-10-01"	346455.70	9550
"2020-11-01"	393011.54	12104
"2020-12-01"	353155.33	9592
"2021-01-01"	323560.24	9585
"2021-02-01"	319529.68	9735
"2021-03-01"	419063.37	12042
"2021-04-01"	311530.28	9602
"2021-05-01"	405967.09	12010
"2021-06-01"	351021.55	9606
"2021-07-01"	332591.32	9727
"2021-08-01"	441547.72	11801
"2021-09-01"	332949.51	9523
"2021-10-01"	332562.07	9544
"2021-11-01"	388195.58	11896
"2021-12-01"	335729.76	9630
"2022-01-01"	434031.13	12039
"2022-02-01"	390619.08	9705
"2022-03-01"	391316.67	9788
"2022-04-01"	304012.58	9515
"2022-05-01"	404822.95	12021
"2022-06-01"	346671.34	9617
"2022-07-01"	335384.71	9598
"2022-08-01"	388964.54	12084
"2022-09-01"	330708.62	9557
"2022-10-01"	366658.24	11973
"2022-11-01"	330093.60	9730
"2022-12-01"	349525.09	9540
"2023-01-01"	425781.96	11955
"2023-02-01"	343886.01	9634
"2023-03-01"	337161.73	9526
"2023-04-01"	324019.84	9678
"2023-05-01"	450800.65	12039
"2023-06-01"	377007.17	9763
"2023-07-01"	434431.88	11962
"2023-08-01"	327439.79	9521
"2023-09-01"	337633.31	9652
"2023-10-01"	448324.56	12087
"2023-11-01"	309596.51	9510
"2023-12-01"	354787.34	9711
"2024-01-01"	392903.68	12037
"2024-02-01"	322030.56	9331
"2024-03-01"	331078.45	9848
"2024-04-01"	419811.68	12244
"2024-05-01"	325279.53	9498
"2024-06-01"	330063.49	9597
"2024-07-01"	405247.71	12074
"2024-08-01"	354207.03	9631
"2024-09-01"	450081.31	12042
"2024-10-01"	322040.59	9525
"2024-11-01"	329894.33	9838
"2024-12-01"	446728.99	12042
"2025-01-01"	304965.15	9617
"2025-02-01"	341768.25	9542
"2025-03-01"	375859.01	12049

-- 10. Revenue and units by category AND location — which category dominates in which country:

SELECT 
    location,
    category,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (PARTITION BY location), 2) AS pct_of_country_revenue
FROM cleaned_supplement_sales
GROUP BY location, category
ORDER BY location, total_revenue DESC;

output:
location      | category       | total_revenue     | pct_of_country_revenue
"Canada"	    "Mineral"	        1441138.53	            18.36
"Canada"	    "Vitamin"	        1337436.14	            17.04
"Canada"	    "Performance"	    1099442.37	            14.01
"Canada"	    "Protein"	        1016496.18	            12.95
"Canada"	    "Omega"        	     543713.40	            6.93
"Canada"	    "Fat Burner"	     542900.94	            6.92
"Canada"	    "Sleep Aid"	         534602.84	            6.81
"Canada"	    "Hydration"	         464208.60	            5.91
"Canada"	    "Amino Acid"	     455781.66	            5.81
"Canada"	    "Herbal"	         412859.07	            5.26
"UK"	       "Vitamin"	        1507802.45	            19.57
"UK"	       "Mineral"	        1482123.32	            19.24
"UK"	      "Performance"	        941257.25	            12.22
"UK"	      "Protein"	            937786.17	            12.17
"UK"	      "Amino Acid"	        552018.61	            7.17
"UK"	      "Hydration"	         485932.74	            6.31
"UK"	      "Herbal"	            475818.15	            6.18
"UK"	      "Fat Burner"	        455270.68	            5.91
"UK"	       "Omega"	             446640.13	            5.80
"UK"	      "Sleep Aid"	         419310.84	            5.44
"USA"	      "Vitamin"	            1454986.09	            19.77
"USA"	      "Mineral"	            1352846.14	            18.38
"USA"	      "Protein"	            901209.74	            12.24
"USA"	      "Performance"	        869002.56	            11.81
"USA"	      "Herbal"	             517023.57	            7.02
"USA"	      "Hydration"	         461810.04	            6.27
"USA"	      "Omega"	             460712.34	            6.26
"USA"	      "Amino Acid"	        457019.36	            6.21
"USA"	      "Sleep Aid"	        443402.11	            6.02
"USA"	      "Fat Burner"	        442728.43	            6.01


-- 11. Platform performance by country — which platform dominates where:
SELECT 
    location,
    platform,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER (PARTITION BY location), 2) AS pct_of_country_revenue
FROM cleaned_supplement_sales
GROUP BY location, platform
ORDER BY location, total_revenue DESC;

output:
location      | platform      | total_revenue     | total_units_sold | pct_of_country
"Canada"	    "iHerb"	         2716096.38	            78084	          34.61
"Canada"	   "Amazon"	         2613844.28	            74802	          33.30
"Canada"	  "Walmart"	         2518639.07	            73167	          32.09
"UK"	      "Walmart"	         2637066.25	            75363	          34.23
"UK"	      "iHerb"	         2624222.86	            74238	          34.06
"UK"	     "Amazon"	         2442671.23	            71636	          31.71
"USA"	     "Amazon"	         2612936.27	            74185	          35.50
"USA"	     "iHerb"	         2514941.81	            73105	          34.17
"USA"	    "Walmart"	         2232862.30	            63898	          30.33

12. -- ========================================================
-- Trend Analysis 2: Year-over-Year (YoY) Performance Growth
-- NOTE: We filter out 2025 because it contains partial-year 
-- data (up to March 2025), which would skew annual trends.
-- ========================================================
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM date)::INT AS year,
        SUM(revenue) AS total_revenue
    FROM cleaned_supplement_sales
    WHERE EXTRACT(YEAR FROM date) < 2025 -- Excludes incomplete 2025 data
    GROUP BY year
)
SELECT
    year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year)) * 100.0 / 
        LAG(total_revenue) OVER (ORDER BY year), 
        2
    ) AS yoy_growth_pct
FROM yearly
ORDER BY year;

output:
year | total_revenue | prev_year_revenue | yoy_growth_pct
2020	4323393.22		
2021	4294248.17	     4323393.22	          -0.67
2022	4372808.55	     4294248.17	           1.83
2023	4470870.75	     4372808.55	           2.24
2024	4429367.35	     4470870.75	          -0.93


-- Discount Analysis
-- 13. Average discount by category — identifies which product categories rely most on discounts

SELECT
    category,
    ROUND(AVG(discount), 2) AS avg_discount,
    ROUND(MAX(discount), 2) AS max_discount,
    ROUND(MIN(discount), 2) AS min_discount
FROM cleaned_supplement_sales
GROUP BY category
ORDER BY avg_discount DESC;

output:
category           | avg_discount | max_discount | min_discount
"Mineral"	0.13	0.25	0.00
"Omega"	0.13	0.25	0.00
"Herbal"	0.13	0.25	0.00
"Vitamin"	0.13	0.25	0.00
"Fat Burner"	0.13	0.25	0.00
"Performance"	0.12	0.25	0.00
"Amino Acid"	0.12	0.25	0.00
"Protein"	0.12	0.25	0.00
"Sleep Aid"	0.12	0.25	0.00
"Hydration"	0.12	0.25	0.00

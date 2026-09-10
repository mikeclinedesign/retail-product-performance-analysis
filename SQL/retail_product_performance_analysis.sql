-- ============================================================
-- RETAIL PRODUCT PERFORMANCE ANALYSIS
-- SQL Portfolio Project
-- ============================================================


-- QUERY 1: DATASET OVERVIEW
-- Provides a high-level summary of the product dataset.

SELECT
    COUNT(*) AS total_products,
    SUM(total_units) AS total_units_sold,
    ROUND(AVG(average_per_store), 2) AS avg_units_per_store,
    ROUND(AVG(stores_carrying), 2) AS avg_stores_per_product
FROM retail_product_performance;


-- QUERY 2: TOP 20 PRODUCTS BY TOTAL UNITS SOLD
-- Identifies the highest-volume products across the entire company.

SELECT
    upc,
    description,
    total_units,
    average_per_store,
    stores_carrying
FROM retail_product_performance
ORDER BY total_units DESC
LIMIT 20;


-- QUERY 3: TOP 20 PRODUCTS BY AVERAGE UNITS PER CARRYING STORE
-- Finds products that perform especially well where they are currently sold.

SELECT
    upc,
    description,
    average_per_store,
    total_units,
    stores_carrying
FROM retail_product_performance
WHERE stores_carrying > 0
ORDER BY average_per_store DESC
LIMIT 20;


-- QUERY 4: HIGH-PERFORMING PRODUCTS WITH LIMITED DISTRIBUTION
-- Uses the same 1,500-unit performance benchmark explored in Tableau.
-- These products may warrant further review for expansion into additional stores.

SELECT
    upc,
    description,
    average_per_store,
    stores_carrying,
    total_units
FROM retail_product_performance
WHERE average_per_store >= 1500
  AND stores_carrying < 12
ORDER BY average_per_store DESC;


-- QUERY 5: LOW-PERFORMING PRODUCTS WITH BROAD DISTRIBUTION
-- Finds products carried in at least 12 stores but averaging fewer than
-- 1,500 units per carrying store.

SELECT
    upc,
    description,
    average_per_store,
    stores_carrying,
    total_units
FROM retail_product_performance
WHERE average_per_store < 1500
  AND stores_carrying >= 12
ORDER BY average_per_store ASC;


-- QUERY 6: EXPANSION OPPORTUNITIES WITH MISSING STORE LOCATIONS
-- Shows which specific stores do not currently carry strong products.

SELECT
    upc,
    description,
    average_per_store,
    stores_carrying,
    CONCAT_WS(', ',
        CASE WHEN a = 0 THEN 'A' END,
        CASE WHEN b = 0 THEN 'B' END,
        CASE WHEN c = 0 THEN 'C' END,
        CASE WHEN d = 0 THEN 'D' END,
        CASE WHEN e = 0 THEN 'E' END,
        CASE WHEN f = 0 THEN 'F' END,
        CASE WHEN g = 0 THEN 'G' END,
        CASE WHEN h = 0 THEN 'H' END,
        CASE WHEN i = 0 THEN 'I' END,
        CASE WHEN j = 0 THEN 'J' END,
        CASE WHEN k = 0 THEN 'K' END,
        CASE WHEN l = 0 THEN 'L' END,
        CASE WHEN m = 0 THEN 'M' END,
        CASE WHEN n = 0 THEN 'N' END,
        CASE WHEN o = 0 THEN 'O' END
    ) AS stores_not_carrying
FROM retail_product_performance
WHERE average_per_store >= 1500
  AND stores_carrying < 12
ORDER BY average_per_store DESC;


-- QUERY 7: PRODUCT DISTRIBUTION BY NUMBER OF STORES
-- Shows how many products are carried in 1 store, 2 stores, 3 stores, etc.

SELECT
    stores_carrying,
    COUNT(*) AS number_of_products,
    ROUND(AVG(average_per_store), 2) AS avg_product_performance
FROM retail_product_performance
GROUP BY stores_carrying
ORDER BY stores_carrying;


-- QUERY 8: TOTAL PRODUCT MOVEMENT BY STORE
-- Converts the 15 store columns into rows and compares total movement
-- across locations.

SELECT
    store,
    SUM(units) AS total_units
FROM retail_product_performance
CROSS JOIN LATERAL (
    VALUES
        ('A', a),
        ('B', b),
        ('C', c),
        ('D', d),
        ('E', e),
        ('F', f),
        ('G', g),
        ('H', h),
        ('I', i),
        ('J', j),
        ('K', k),
        ('L', l),
        ('M', m),
        ('N', n),
        ('O', o)
) AS store_data(store, units)
GROUP BY store
ORDER BY total_units DESC;
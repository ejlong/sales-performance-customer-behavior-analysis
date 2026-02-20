-- Data Overview

-- Orders Date Range
SELECT 
  MIN(created_at) AS min_date,
  MAX(created_at) AS max_date,
FROM `bigquery-public-data.thelook_ecommerce.orders`; 

-- Row Counts
SELECT 'orders' AS table_name, COUNT(*) AS row_count
FROM `bigquery-public-data.thelook_ecommerce.orders`
UNION ALL
SELECT 'order_items', COUNT(*)
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL
SELECT 'products', COUNT(*)
FROM `bigquery-public-data.thelook_ecommerce.products`
UNION ALL
SELECT 'users', COUNT(*)
FROM `bigquery-public-data.thelook_ecommerce.users`;

-- Revenue
SELECT
  ROUND(SUM(sale_price), 2) AS total_revenue,
  COUNT(*) AS total_items_sold,
  COUNT(DISTINCT order_id) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items`;

-- orders NULL check
SELECT
  COUNTIF(order_id IS NULL) AS null_order_id,
  COUNTIF(product_id IS NULL) AS null_product_id,
  COUNTIF(sale_price IS NULL) AS null_sale_price
FROM `bigquery-public-data.thelook_ecommerce.order_items`;


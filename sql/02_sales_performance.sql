-- =========================================
-- Sales Performance Analysis
-- Objective: Analyze revenue trends, product performance,
-- and order metrics for theLook eCommerce dataset.
-- =========================================

-- Monthly Orders & Revenue
SELECT 
  DATE_TRUNC(DATE(o.created_at), MONTH) AS order_month,
  ROUND(SUM(oi.sale_price),2) AS monthly_revenue,
  COUNT(DISTINCT o.order_id) AS monthly_orders,
  ROUND(SUM(oi.sale_price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_total
FROM `bigquery-public-data.thelook_ecommerce.orders` AS o
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  ON o.order_id = oi.order_id
WHERE o.status = 'Complete'
GROUP BY order_month
ORDER BY order_month;

-- Revenue & % of Total Revenue By Product Category
WITH category_revenue AS(
  SELECT
    p.category,
    SUM(oi.sale_price) AS revenue,
    COUNT(*) AS items_sold
  FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
  JOIN `bigquery-public-data.thelook_ecommerce.orders` o
    ON oi.order_id = o.order_id
  WHERE o.status = 'Complete'
  GROUP BY p.category
)
SELECT
  category,
  ROUND(revenue, 2) AS revenue,
  items_sold,
  ROUND(revenue / SUM(revenue) OVER (), 4) AS revenue_share
FROM category_revenue
ORDER BY revenue DESC;

-- Top 10 Products By Revenue
SELECT
  p.name,
  ROUND(SUM(oi.sale_price), 2) AS revenue,
  COUNT(*) AS units_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
  ON oi.product_id = p.id
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
WHERE o.status = 'Complete'
GROUP BY p.name
ORDER BY revenue DESC
LIMIT 10;


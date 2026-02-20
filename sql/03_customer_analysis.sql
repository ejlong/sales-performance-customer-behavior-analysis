-- =========================================
-- Customer Behavior Analysis
-- Objective: Analyze purchasing behavior and revenue concentration
-- across customers (lifetime view).
-- =========================================

-- General Customer Metrics
WITH customer_summary AS (
  SELECT
    o.user_id AS customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.sale_price),
    2 AS total_revenue,
    MIN(DATE(o.created_at)) AS first_order_date,
    MAX(DATE(o.created_at)) AS last_order_date
  FROM `bigquery-public-data.thelook_ecommerce.orders` o
  JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
    ON o.order_id = oi.order_id
  WHERE o.status = 'Complete'
  GROUP BY o.user_id
)

SELECT
  COUNT(*) AS total_customers,
  ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
  ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer,
  ROUND(SUM(total_revenue), 2) AS total_revenue
FROM customer_summary;

-- Repeat Purchase Rate
WITH customer_summary AS (
  SELECT
    user_id AS customer_id,
    COUNT(*) AS total_orders
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status = 'Complete'
  GROUP BY user_id
)

SELECT
  COUNT(*) AS total_customers,
  COUNTIF(total_orders > 1) AS repeat_customers,
  ROUND(COUNTIF(total_orders > 1) / COUNT(*), 4) AS repeat_rate
FROM customer_summary;

-- Revenue By Order Frequency
WITH customer_summary AS (
  SELECT
    o.user_id AS customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.sale_price) AS total_revenue
  FROM `bigquery-public-data.thelook_ecommerce.orders` o
  JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
    ON o.order_id = oi.order_id
  WHERE o.status = 'Complete'
  GROUP BY o.user_id
)

SELECT
  CASE
    WHEN total_orders = 1 THEN '1 Order'
    WHEN total_orders = 2 THEN '2 Orders'
    ELSE '3-4 Orders'
    END AS order_frequency_group,
  COUNT(*) AS customers,
  ROUND(SUM(total_revenue), 2) AS revenue,
  ROUND(SUM(total_revenue) / SUM(SUM(total_revenue)) OVER (), 4)
    AS revenue_share
FROM customer_summary
GROUP BY order_frequency_group
ORDER BY revenue DESC;

-- Distribution of Orders per Customer
WITH customer_orders AS (
  SELECT
    user_id AS customer_id,
    COUNT(*) AS total_orders
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status = 'Complete'
  GROUP BY user_id
)

SELECT
  total_orders,
  COUNT(*) AS customers,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS customer_share
FROM customer_orders
GROUP BY total_orders
ORDER BY total_orders;

-- E-commerce Delivery & Sales Performance Analysis
-- Dataset: simulated portfolio practice data (5,000 orders)
-- Database: SQLite
--
-- First, import data/ecommerce_orders.csv into a table named ecommerce_orders.
-- In SQLite CLI, one option is:
--   .mode csv
--   .import --skip 1 data/ecommerce_orders.csv ecommerce_orders
--
-- If importing with a GUI (DB Browser for SQLite), create the table from CSV
-- and name it ecommerce_orders. Ensure date columns are stored as YYYY-MM-DD.

-- 1. Check the number of records and unique order IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM ecommerce_orders;

-- 2. Count orders by status
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM ecommerce_orders), 2) AS pct_of_orders
FROM ecommerce_orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 3. Delivered revenue and average delivered order value
-- Revenue is calculated only from successfully delivered orders.
SELECT
    ROUND(SUM(order_amount_ngn), 2) AS delivered_revenue_ngn,
    ROUND(AVG(order_amount_ngn), 2) AS average_delivered_order_value_ngn
FROM ecommerce_orders
WHERE order_status = 'Delivered';

-- 4. Revenue by product category
SELECT
    product_category,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(order_amount_ngn), 2) AS delivered_revenue_ngn,
    ROUND(AVG(order_amount_ngn), 2) AS average_order_value_ngn
FROM ecommerce_orders
WHERE order_status = 'Delivered'
GROUP BY product_category
ORDER BY delivered_revenue_ngn DESC;

-- 5. Delivery and cancellation performance by city
SELECT
    delivery_city,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM ecommerce_orders
GROUP BY delivery_city
ORDER BY cancellation_rate_pct DESC;

-- 6. Average delivery time by city (delivered orders only)
SELECT
    delivery_city,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(delivery_days), 2) AS average_delivery_days
FROM ecommerce_orders
WHERE order_status = 'Delivered'
GROUP BY delivery_city
ORDER BY average_delivery_days DESC;

-- 7. Monthly delivered orders and revenue
SELECT
    strftime('%Y-%m', order_date) AS order_month,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(order_amount_ngn), 2) AS delivered_revenue_ngn
FROM ecommerce_orders
WHERE order_status = 'Delivered'
GROUP BY strftime('%Y-%m', order_date)
ORDER BY order_month;

-- 8. Most popular payment methods
SELECT
    payment_method,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM ecommerce_orders), 2) AS pct_of_orders
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY order_count DESC;

-- 9. Top 10 products by delivered revenue
SELECT
    product_name,
    product_category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(order_amount_ngn), 2) AS delivered_revenue_ngn
FROM ecommerce_orders
WHERE order_status = 'Delivered'
GROUP BY product_name, product_category
ORDER BY delivered_revenue_ngn DESC
LIMIT 10;

-- 10. Data quality: missing values in key fields
SELECT
    SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN order_date IS NULL OR TRIM(order_date) = '' THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN order_status IS NULL OR TRIM(order_status) = '' THEN 1 ELSE 0 END) AS missing_order_status
FROM ecommerce_orders;

-- Write your PostgreSQL query statement below
WITH customer_stats AS (
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    
    COUNT(*) FILTER (
        WHERE (order_timestamp::time >= '11:00:00' AND order_timestamp::time < '14:00:00')
           OR (order_timestamp::time >= '18:00:00' AND order_timestamp::time < '21:00:00')
    ) AS peak_orders,
    
    COUNT(order_rating) AS rated_orders,
    
    ROUND(AVG(order_rating),2) AS avg_rating
    
FROM restaurant_orders
GROUP BY customer_id
)

SELECT
    customer_id,
    total_orders,
    ROUND(peak_orders * 100.0 / total_orders) AS peak_hour_percentage,
    avg_rating AS average_rating
FROM customer_stats
WHERE
    total_orders >= 3
    AND peak_orders * 1.0 / total_orders >= 0.6
    AND rated_orders * 1.0 / total_orders >= 0.5
    AND avg_rating >= 4
ORDER BY average_rating DESC, customer_id DESC; 
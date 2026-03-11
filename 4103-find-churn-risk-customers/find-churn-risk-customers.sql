WITH ranked_events AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id 
               ORDER BY event_date DESC, event_id DESC
           ) AS rn
    FROM subscription_events
),

user_stats AS (
    SELECT 
        user_id,
        MIN(event_date) AS first_event_date,
        MAX(event_date) AS last_event_date,
        MAX(monthly_amount) FILTER (WHERE monthly_amount > 0) AS max_historical_amount,
        COUNT(*) FILTER (WHERE event_type = 'downgrade') AS downgrade_count
    FROM subscription_events
    GROUP BY user_id
)

SELECT 
    r.user_id,
    r.plan_name AS current_plan,
    r.monthly_amount AS current_monthly_amount,
    u.max_historical_amount,
    (u.last_event_date - u.first_event_date) AS days_as_subscriber
FROM ranked_events r
JOIN user_stats u
    ON r.user_id = u.user_id
WHERE r.rn = 1
AND r.event_type <> 'cancel'
AND u.downgrade_count > 0
AND r.monthly_amount < 0.5 * u.max_historical_amount
AND (u.last_event_date - u.first_event_date) >= 60
ORDER BY days_as_subscriber DESC, r.user_id ASC;
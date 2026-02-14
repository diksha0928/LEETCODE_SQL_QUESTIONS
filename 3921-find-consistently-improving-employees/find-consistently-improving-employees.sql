WITH ranked_reviews AS (
    SELECT
        employee_id,
        review_date,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id
            ORDER BY review_date DESC
        ) AS rn
    FROM performance_reviews
),
last_three AS (
    SELECT *
    FROM ranked_reviews
    WHERE rn <= 3
),
ordered AS (
    SELECT
        employee_id,
        review_date,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id
            ORDER BY review_date ASC
        ) AS seq
    FROM last_three
),
pivoted AS (
    SELECT
        employee_id,
        MAX(CASE WHEN seq = 1 THEN rating END) AS r1,
        MAX(CASE WHEN seq = 2 THEN rating END) AS r2,
        MAX(CASE WHEN seq = 3 THEN rating END) AS r3,
        COUNT(*) AS cnt
    FROM ordered
    GROUP BY employee_id
)
SELECT
    e.employee_id,
    e.name,
    (p.r3 - p.r1) AS improvement_score
FROM pivoted p
JOIN employees e
    ON e.employee_id = p.employee_id
WHERE
    p.cnt = 3
    AND p.r1 < p.r2
    AND p.r2 < p.r3
ORDER BY
    improvement_score DESC,
    e.name ASC;

-- Write your PostgreSQL query statement below
with highest_scores as(
    select student_id,
    subject,
    score,
    exam_date,
    first_value(score) over (
        partition by student_id, subject
        order by exam_date
    ) as first_score,
    last_value(score) over (
        partition by student_id, subject
        rows between unbounded preceding and unbounded following
    ) as latest_score,
    count(*) over (
        partition by student_id, subject
    ) as exam_count
from Scores
)

select student_id,
       subject,
       first_score,
       latest_score
from highest_scores
where exam_count >= 2
and latest_score > first_score
group by student_id, subject,first_score, latest_score
order by student_id, subject asc;
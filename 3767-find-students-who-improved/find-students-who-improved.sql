-- Write your PostgreSQL query statement below
select
      s.student_id,
      s.subject,
      min(case when s.exam_date = sc.first_date then s.score end) as first_score,
      min(case when s.exam_date = sc.last_date then s.score end) as latest_score
from Scores s
join (
    select student_id,
           subject,
           min(exam_date) as first_date,
           max(exam_date) as last_date
    from Scores
    group by student_id, subject
    having count(*) >= 2
)sc
on s.student_id = sc.student_id
and s.subject = sc.subject
group by s.student_id, 
         s.subject, 
         sc.first_date, 
         sc.last_date
having 
       min(case when s.exam_date = sc.last_date then s.score end) 
       >
       min(case when s.exam_date = sc.first_date then s.score end)
order by s.student_id, s.subject asc;
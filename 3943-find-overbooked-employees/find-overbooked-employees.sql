-- Write your PostgreSQL query statement below
with weekly_hours as(
    select employee_id,
    date_trunc('week', meeting_date) as week_start,
    sum(duration_hours) as total_hours
    from meetings
    group by employee_id, date_trunc('week', meeting_date)
),
meeting_hours as(
    select employee_id,
    count(*) as meeting_heavy_weeks
    from weekly_hours
    where total_hours > 20
    group by employee_id
    having count(*) >= 2
)
select e.employee_id,
       e.employee_name,
       e.department,
       m.meeting_heavy_weeks
from employees e
join meeting_hours m
on e.employee_id = m.employee_id
order by m.meeting_heavy_weeks desc,
         e.employee_name asc;

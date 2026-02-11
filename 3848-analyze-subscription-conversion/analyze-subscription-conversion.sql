-- Write your PostgreSQL query statement below
with user_converted as(
    select user_id
    from UserActivity
    group by user_id
    having 
        sum(case when activity_type = 'free_trial' then 1 else 0 end) > 0
        and
        sum(case when activity_type = 'paid' then 1 else 0 end) > 0
),
trial_avg as(
    select user_id,
    round(avg(activity_duration):: numeric,2) as trial_avg_duration
    from UserActivity
    where activity_type = 'free_trial'
    group by user_id
),
paid_avg as(
    select user_id,
    round(avg(activity_duration)::numeric,2) as paid_avg_duration
    from UserActivity
    where activity_type = 'paid'
    group by user_id
)

select u.user_id,
       t.trial_avg_duration,
       p.paid_avg_duration
from user_converted u
join trial_avg t on u.user_id = t.user_id
join paid_avg p on u.user_id = p.user_id
order by u.user_id;
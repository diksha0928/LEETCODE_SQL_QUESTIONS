-- Write your PostgreSQL query statement below
select 
round(
    count(distinct a.player_id)*1.0 
    /
    (select count(distinct player_id)  from     Activity), 2) as fraction
from Activity a
join(
    select player_id, min(event_date) as first_login
     from Activity
     group by player_id) f
on a.player_id = f.player_id
and a.event_date = f.first_login + interval '1 day';
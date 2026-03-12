-- Write your PostgreSQL query statement below
with user_count as (
    select user_id
    from reactions
    group by user_id
    having count(distinct content_id) >=5
),
reaction_count as(
    select user_id,
           reaction,
           count(*) as reac_count
           from reactions
           group by user_id, reaction
),
user_totals as(
    select user_id,
           count(*) as total_reactions
    from reactions
    group by user_id
),
ranked_reaction as (
    select rc.user_id,
           rc.reaction,
           rc.reac_count,
           ut.total_reactions,
           row_number() over( partition by rc.user_id
           order by rc.reac_count desc) as rn
    from reaction_count rc
    join user_totals ut
    on rc.user_id = ut.user_id
)

select r.user_id,
       r.reaction as dominant_reaction,
       round(r.reac_count *1.0 /r.total_reactions, 2) as reaction_ratio
from ranked_reaction r
join user_count uc
on r.user_id = uc.user_id
where r.rn=1
and r.reac_count * 1.0 / r.total_reactions >= 0.6
order by reaction_ratio desc, user_id asc;
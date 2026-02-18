-- Write your PostgreSQL query statement below
select t.id,
       case 
           when t.p_id is null then 'Root'
           when  not exists (
            select 1
            from tree t2
            where t2.p_id = t.id
           ) then 'Leaf'
           else 'Inner'
           end as type
from Tree t;
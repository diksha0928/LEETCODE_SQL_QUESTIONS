-- Write your PostgreSQL query statement below
select user_id, email
from Users
where email ~ '^[A-Za-z0-9_]+@[a-z]+\.com$'
order by user_id asc;
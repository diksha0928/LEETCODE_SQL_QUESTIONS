-- Write your PostgreSQL query statement below
-- Biggest Single Number
select max(num) as num
from (
   select num
   from MyNumbers
   group by num
   having count(*) = 1
);
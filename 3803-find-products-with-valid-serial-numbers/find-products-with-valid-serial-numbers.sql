-- Write your PostgreSQL query statement below
select product_id, product_name, description
from products
where description ~ '\ySN[0-9]{4}-[0-9]{4}\y'
order by product_id asc;
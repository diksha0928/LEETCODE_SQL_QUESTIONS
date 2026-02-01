-- Write your PostgreSQL query statement below
select c.customer_id
from Customer c
join Product p
on p.product_key = c.product_key
group by c.customer_id
having count(distinct p.product_key) =(
    select count(*) from Product
);
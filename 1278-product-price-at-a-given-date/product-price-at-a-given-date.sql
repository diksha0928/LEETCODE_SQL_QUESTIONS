-- Write your PostgreSQL query statement below
select p.product_id,
       coalesce(pt.new_price, 10) as price
from(
    select distinct product_id
    from Products
) p
left join(
    select product_id, new_price
    from Products
    where (product_id, change_date) in(
        select product_id, max(change_date)
        from Products
        where change_date <='2019-08-16'
        group by product_id
    )
)pt
on p.product_id = pt.product_id
order by p.product_id;
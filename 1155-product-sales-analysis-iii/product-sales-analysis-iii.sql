-- Write your PostgreSQL query statement below
select a.product_id,
       a.year as first_year,
       a.quantity,
       a.price
from Sales a
join (
    select product_id, min(year) as first_year
    from Sales
    group by product_id
) s
on a.product_id = s.product_id
and a.year = s.first_year;

-- Write your PostgreSQL query statement below
with prod_count as (
    select store_id
    from inventory
    group by store_id
    having count(distinct product_name) >= 3
),
maximum_price as(
    select store_id, product_name as most_exp_product, quantity as max_quantity
    from inventory
    where(store_id, price) in (
        select store_id, max(price)
        from inventory
        group by store_id
    )
),
minimum_price as (
    select store_id, product_name as cheapest_product, quantity as min_quantity
    from inventory
    where(store_id, price) in (
        select store_id, min(price) 
        from inventory
        group by store_id
    )
)

select s.store_id,
       s.store_name,
       s.location,
       mx.most_exp_product,
       mn.cheapest_product,
       round(mn.min_quantity*1.0 / mx.max_quantity, 2) as imbalance_ratio
from stores s
join prod_count pc on pc.store_id = s.store_id
join maximum_price mx on mx.store_id = s.store_id
join minimum_price mn on mn.store_id = s.store_id
where mx.max_quantity < mn.min_quantity
order by imbalance_ratio desc, store_name asc;
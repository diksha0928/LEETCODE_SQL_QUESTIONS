-- Write your PostgreSQL query statement below
with products_pair as (
    select p1.user_id,
    p1.product_id as product1_id,
    p2.product_id as product2_id
    from ProductPurchases p1
    join ProductPurchases p2
    on p1.user_id = p2.user_id
    and p1.product_id < p2.product_id
),
pairs_count as (
    select count(distinct user_id) as customer_count,
    product1_id,
    product2_id
    from products_pair
    group by product1_id, product2_id
    having count(distinct user_id) >= 3
)

select pr.product1_id,
       pr.product2_id,
       pi1.category as product1_category,
       pi2.category as product2_category,
       pr.customer_count
from pairs_count pr
join ProductInfo pi1 on pr.product1_id = pi1.product_id
join ProductInfo pi2 on pr.product2_id = pi2.product_id
order by
      pr.customer_count desc,
      pr.product1_id asc,
      pr.product2_id asc;

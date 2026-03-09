-- Write your PostgreSQL query statement below
select customer_id 
from customer_transactions
group by customer_id
having 
       count(*) filter (where transaction_type = 'purchase') >=3
       and max(transaction_date)-min(transaction_date) >=30
       and (count(*) filter(where transaction_type = 'refund')::decimal
       / count(*)) <0.2
order by customer_id;
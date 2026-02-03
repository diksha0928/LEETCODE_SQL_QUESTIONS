-- Write your PostgreSQL query statement below
select e.name
from Employee e
left join Employee emp
on e.id = emp.managerId
group by e.name, e.id
having count(*) >=5
order by e.id;
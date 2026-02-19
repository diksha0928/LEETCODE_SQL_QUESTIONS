-- Write your PostgreSQL query statement below
select d.name as Department,
       e.name as Employee,
       e.salary as Salary
from (
    select id,
           name,
           salary,
           departmentId,
           dense_rank() over (
           partition by departmentId 
           order by salary desc
           ) as rank
        from Employee
) e
join Department d
on e.departmentId = d.id
where e.rank <= 3;
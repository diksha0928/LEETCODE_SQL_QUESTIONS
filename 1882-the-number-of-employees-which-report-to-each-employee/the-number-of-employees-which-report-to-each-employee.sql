-- Write your PostgreSQL query statement below
select e.employee_id, e.name,
count(emp.reports_to) as reports_count,
round(avg(emp.age)) as average_age
from Employees e
join Employees emp
on e.employee_id = emp.reports_to
group by e.employee_id, e.name
order by e.employee_id;
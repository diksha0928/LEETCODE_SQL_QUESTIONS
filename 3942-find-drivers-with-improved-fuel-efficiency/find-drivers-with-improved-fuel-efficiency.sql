-- Write your PostgreSQL query statement below
select d.driver_id,
       d.driver_name,
       round(first_half_avg,2) as first_half_avg,
       round(second_half_avg,2) as second_half_avg,
       round(second_half_avg - first_half_avg,2) as efficiency_improvement
from(
    select driver_id,
           avg(
            case 
                when extract(month from trip_date) between 1 and 6
                then distance_km / fuel_consumed
                end) as first_half_avg,
            avg(
                case
                    when extract(month from trip_date) between 7 and 12
                    then distance_km / fuel_consumed
                    end) as second_half_avg
from trips
group by driver_id
having 
      count(case when extract(month from trip_date) between 1 and 6 then 1 end)>0
      and
      count(case when extract(month from trip_date) between 7 and 12 then 1 end)>0
      and
          avg(case
         when extract(month from trip_date) between 7 and 12
         then distance_km / fuel_consumed
         end)
         >
      avg(case
         when extract(month from trip_date) between 1 and 6
         then distance_km / fuel_consumed
         end)
) t
join drivers d
on d.driver_id = t.driver_id
order by 
efficiency_improvement desc,
d.driver_name asc;
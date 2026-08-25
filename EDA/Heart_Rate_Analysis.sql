-- Over View of data 
select count(distinct Id) from heartrate_data ;

select MIN(Value) as min_heartrate , max(Value) as max_heartrate , avg(Value) as avg_heart_rate from heartrate_data;

select min(Recorded_Time_Cleaned) as min_time_stamp , max(Recorded_Time_Cleaned) as max_time_stamp from heartrate_data;

-- disribution 
select 
case
  when value < 50 then '<50'
  when value between 50 and 59 then '50-59'
  when value between 60 and 69 then '60-69'
  when value between 70 and 79 then '70-79'
  when value between 80 and 89 then '80-89'
  when value between 90 and 99 then '90-99'
  when value between 100 and 109 then '100-109'
  when value between 110 and 119 then '110-119'
  when value between 120 and 129 then '120-129'
  else '130+'
end as hr_range,
count(*) as readings , round(count(*) * 100.0 / (select count(*) from heartrate_data),2) as percentage 
from heartrate_data 
group by hr_range 
order by MIN(Value)
;

-- Heart Rate VS ACtivity 
-- create table heartrate_minute as 
-- select Id, date_format(Recorded_Time_Cleaned, '%Y-%m-%d %H:%i:00') as activity_minute ,
-- avg(Value) as avg_hr 
-- from heartrate_data 
-- group by Id , date_format(Recorded_Time_Cleaned,'%Y-%m-%d %H:%i:00');
with
activity_minute as (
select Id , ActivityMinute , Steps from minute_activity ),
heartrate as (
select Id , activity_minute , avg_hr from  heartrate_minute)
 
select a.Id , a.ActivityMinute , a.Steps ,b.avg_hr
from activity_minute a join heartrate b on a.Id = b.Id and a.ActivityMinute=b.activity_minute;


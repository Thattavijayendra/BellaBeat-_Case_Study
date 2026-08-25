-- Over all inactive time  full data set ........................

select
sum(sedentaryminutes) as total_sedentary_minutes,
sum(lightlyactiveminutes) as total_light_minutes,
sum(fairlyactiveminutes) as total_fairly_active_minutes,
sum(veryactiveminutes) as total_very_active_minutes,
sum(
sedentaryminutes
+ lightlyactiveminutes
+ fairlyactiveminutes
+ veryactiveminutes
) as total_recorded_minutes
from daily_activity;

-- Percentage of inactive time in data set 

select
round(
sum(sedentaryminutes) * 100.0 /
sum(
sedentaryminutes
+ lightlyactiveminutes
+ fairlyactiveminutes
+ veryactiveminutes
),
2
) as sedentary_percentage,
round(
sum(lightlyactiveminutes) * 100.0 /
sum(
sedentaryminutes
+ lightlyactiveminutes
+ fairlyactiveminutes
+ veryactiveminutes
),
2
) as lightly_active_percentage,
round(
sum(fairlyactiveminutes) * 100.0 /
sum(
sedentaryminutes
+ lightlyactiveminutes
+ fairlyactiveminutes
+ veryactiveminutes
),
2
) as fairly_active_percentage,
round(
sum(veryactiveminutes) * 100.0 /
sum(
sedentaryminutes
+ lightlyactiveminutes
+ fairlyactiveminutes
+ veryactiveminutes
),
2
) as very_active_percentage
from daily_activity;

-- Most inactive time of the day 

select
hour(activityminute) as hour,
count(*) as recorded_minutes,
sum(
case when steps = 0 then 1
else 0 end
) as inactive_minutes,
round(
sum( case when steps = 0 then 1 else 0
end ) * 100.0 / count(*),
2 ) as inactive_percentage
from minute_activity
group by
hour(activityminute)
order by
hour;

-- inactive episodes analysis 

with consecutive_zeros as 
(
select Id , ActivityMinute , 
DATE_SUB( ActivityMinute,
INTERVAL ROW_NUMBER() OVER(partition by Id Order By ActivityMinute ) MINUTE ) as grp 
from minute_activity 
WHERE Steps = 0 ),

inactive_period AS (
select Id , MIN(ActivityMinute) AS inactivity_start , 
MAX(ActivityMinute ) AS inactivity_end ,
timestampdiff(MINUTE , MIN(ActivityMinute) , MAX(ActivityMinute) ) as inactive_minutes
from consecutive_zeros 
group by Id , grp ) 

-- select Id , inactivity_start , 
-- inactivity_end ,
-- inactive_minutes 
-- from inactive_period where inactive_minutes >= 30  ;
select 
CASE when inactive_minutes >=90 then '90+ minutes'
when inactive_minutes >=60 then '60-90 miutes' 
else '30 - 59 minutes'
end as inactivity_category , 
count(*) as inactivity_episodes ,
count(distinct Id) as unique_users 
from inactive_period 
where inactive_minutes >=30 
group by inactivity_category 
;

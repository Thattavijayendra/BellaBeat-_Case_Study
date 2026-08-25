-- types of activites  percntage 

with total_activity as (
  select
    sum(lightlyactiveminutes) as light_mins,
    sum(fairlyactiveminutes) as moderate_mins,
    sum(veryactiveminutes) as high_mins,
    (sum(lightlyactiveminutes) + sum(fairlyactiveminutes) + sum(veryactiveminutes)) as total_mins
  from daily_activity
)
select
  round(light_mins, 2) as light_minutes,
  round(moderate_mins, 2) as moderate_minutes,
  round(high_mins, 2) as high_intensity_minutes,
  
  round(light_mins * 100.0 / total_mins, 2) as light_percentage,
  round(moderate_mins * 100.0 / total_mins, 2) as moderate_percentage,
  round(high_mins * 100.0 / total_mins, 2) as high_intensity_percentage
from total_activity; 

-- Logged Activity vs Automatic Activity 
select round(sum(TrackerDIstance),2) as tracker_distance , 
round(sum(LoggedActivitiesDistance),2) as logged_distance , 
round(sum(TrackerDistance)*100.0/(sum(TrackerDistance)+sum(LoggedActivitiesDistance)),2)as tracker_percentage ,
round(sum(LoggedActivitiesDistance)*100.0/(sum(TrackerDistance) + sum(LoggedActivitiesDistance)),2) as logged_percentage 
from daily_activity;

-- weight _log tracking 
select
'activity' as feature,
count(distinct id) as users
from daily_activity
union all
select
'sleep' as feature,
count(distinct id) as users
from sleep_activity
union all
select
'weight' as feature,
count(distinct id) as users
from weight_log_activity;

-- IsManual Distribution 
select IsManualReport , count(*) as records , 
count(distinct Id) as users from weight_log_activity group by IsManualReport;


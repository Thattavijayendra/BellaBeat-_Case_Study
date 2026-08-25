-- checking over all sleep quality 

select round(avg(TotalTimeInBed),2) as avg_time_in_bed ,
round(avg(TotalMinuteAsleep),2) as avg_time_asleep  , 
round(avg(TotalTimeInBed - TotalMinuteAsleep),2) as avg_awake_time
 from sleep_activity;
 
 -- Sleep Effiecincy 
 select round(avg(TotalTimeInBed),2) as avg_time_in_bed ,
round(avg(TotalMinuteAsleep),2) as avg_time_asleep  , 
round(avg(TotalTimeInBed - TotalMinuteAsleep),2) as avg_awake_time, 
round(avg(TotalMinuteAsleep *100.0 / NULLIF(TotalTimeInBed,0)),2) avg_sleep_efficiency
 from sleep_activity;
 
-- Checking Sleep Consistency....................
  -- checking the structure ....
  
  with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(second, min(ActivityMinute) , max(ActivityMinute))/3600,2) as sleep_duration_hours
  from sleep_data 
  group by Id , LogId)
  select Id , LogId ,sleep_start,sleep_end, sleep_duration_hours from sleep_summary;
  
  -- Checking Consistency user wise .......
  with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(second, min(ActivityMinute) , max(ActivityMinute))/3600,2) as sleep_duration_hours
  from sleep_data 
  group by Id , LogId)
  select Id , round(avg(sleep_duration_hours),2) as avg_sleep_duration_hours ,
round(stddev_samp(sleep_duration_hours),2) as sleep_duration_stddev 
from sleep_summary group by Id ;

-- sleep sessions by starting hour 

with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(second, min(ActivityMinute) , max(ActivityMinute))/3600,2) as sleep_duration_hours
  from sleep_data 
  group by Id , LogId)
  select hour(sleep_start) as sleep_start , count(*) as sleep_sessions,
  count(distinct Id) as users 
  from sleep_summary 
  group by hour(sleep_start) ;
  
  
  -- classifing Night Sleep and Afternoon Sleep 
  
  with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(minute, min(ActivityMinute) , max(ActivityMinute)),2) as duration_minutes
  from sleep_data 
  group by Id , LogId) ,
  
  classifed_sleep as 
  (
  select Id , LogId, sleep_start , sleep_end, duration_minutes ,
 

case
-- afternoon sleep: starts between 12 PM and 5 PM (< 3 hours)
when time(sleep_start) between '12:00:00' and '16:59:59' 
 and duration_minutes < 180 then 'afternoon sleep'

-- evening sleep: starts between 5 PM and 7 PM (< 3 hours)
when time(sleep_start) between '17:00:00' and '18:59:59' 
 and duration_minutes < 180 then 'evening sleep'

-- normal night sleep: starts between 7 PM and midnight
when time(sleep_start) >= '19:00:00' then 'normal night sleep'

-- late night sleep: goes to bed after midnight (between 12 AM and 5 AM)
when time(sleep_start) < '05:00:00' then 'late night sleep'

else 'others'
end as sleep_type
  from sleep_summary )
  
  select sleep_type , 
  count(*) as sessions ,
  count(distinct id) as users from classifed_sleep 
  group by sleep_type;
  
  -- checking the night sleep ......................................... 
  
   with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(minute, min(ActivityMinute) , max(ActivityMinute)),2) as duration_minutes
  from sleep_data 
  group by Id , LogId) ,
  
  classifed_sleep as 
  (
  select Id , LogId, sleep_start , sleep_end, duration_minutes ,
 

case
-- afternoon sleep: starts between 12 PM and 5 PM (< 3 hours)
when time(sleep_start) between '12:00:00' and '16:59:59' 
 and duration_minutes < 180 then 'afternoon sleep'

-- evening sleep: starts between 5 PM and 7 PM (< 3 hours)
when time(sleep_start) between '17:00:00' and '18:59:59' 
 and duration_minutes < 180 then 'evening sleep'

-- normal night sleep: starts between 7 PM and midnight
when time(sleep_start) >= '19:00:00' then 'normal night sleep'

-- late night sleep: goes to bed after midnight (between 12 AM and 5 AM)
when time(sleep_start) < '05:00:00' then 'late night sleep'

else 'others'
end as sleep_type
  from sleep_summary ),
  
  -- night_sleep as (
--   select Id , LogId , sleep_start , sleep_end , duration_minutes from classifed_sleep
--   where sleep_type in ('normal night sleep','late night sleep') ) 

night_sleep AS (
    SELECT
        Id,
        LogId,
        sleep_start,
        sleep_end,
        duration_minutes

    FROM classifed_sleep

    WHERE sleep_type IN (
        'normal night sleep',
        'late night sleep'
    )

    AND duration_minutes BETWEEN 240 AND 720
)
  
 select Id , count(*) as night_sleep_sessions , 
 round(avg(duration_minutes)/60,2) as avg_sleep_hours ,
round(STDDEV_SAMP(duration_minutes) / 60,2) as sleep_duration_stddev_hours 
from night_sleep 
group by Id ;

-- checking Onset consistency ................................. 

with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(minute, min(ActivityMinute) , max(ActivityMinute)),2) as duration_minutes
  from sleep_data 
  group by Id , LogId) ,
  
  classifed_sleep as 
  (
  select Id , LogId, sleep_start , sleep_end, duration_minutes ,
 

case
-- afternoon sleep: starts between 12 PM and 5 PM (< 3 hours)
when time(sleep_start) between '12:00:00' and '16:59:59' 
 and duration_minutes < 180 then 'afternoon sleep'

-- evening sleep: starts between 5 PM and 7 PM (< 3 hours)
when time(sleep_start) between '17:00:00' and '18:59:59' 
 and duration_minutes < 180 then 'evening sleep'

-- normal night sleep: starts between 7 PM and midnight
when time(sleep_start) >= '19:00:00' then 'normal night sleep'

-- late night sleep: goes to bed after midnight (between 12 AM and 5 AM)
when time(sleep_start) < '05:00:00' then 'late night sleep'

else 'others'
end as sleep_type
  from sleep_summary ),
  
  -- night_sleep as (
--   select Id , LogId , sleep_start , sleep_end , duration_minutes from classifed_sleep
--   where sleep_type in ('normal night sleep','late night sleep') ) 

night_sleep AS (
    SELECT
        Id,
        LogId,
        sleep_start,
        sleep_end,
        duration_minutes,
        case when time(sleep_start) >= '19:00:00' then hour(sleep_start)*60 + minute(sleep_start) 
        else (hour(sleep_start)+24)*60 + minute(sleep_start) 
        end as onset_minutes 

    FROM classifed_sleep

    WHERE sleep_type IN (
        'normal night sleep',
        'late night sleep'
    )

    AND duration_minutes BETWEEN 240 AND 720
),

sleep_consistensy as (
select Id , count(*) as night_sleep_sessions , 
round(avg(onset_minutes),2) as avg_onset_minutes ,
round(stddev_samp(onset_minutes) ,2) as sleep_onset_stddev_hours 
from night_sleep 
group by Id 
having count(*) >= 2 
)

select 
case
when sleep_onset_stddev_hours <= 30 then 'highly regular'
when sleep_onset_stddev_hours <= 45 then 'relatively regular'
when sleep_onset_stddev_hours <= 75 then 'moderate variation'
else 'substantial variation'
end as sleep_regularity_group , count(*) as users , round(count(*) * 100.0 / (select count(*) from sleep_consistensy),2) from sleep_consistensy group by sleep_regularity_group ;


-- Checking the wake-up consistansy 

with sleep_summary as 
  (
  select Id, LogId , min(ActivityMinute) as sleep_start , max(ActivityMinute) as sleep_end , 
  round(timestampdiff(minute, min(ActivityMinute) , max(ActivityMinute)),2) as duration_minutes
  from sleep_data 
  group by Id , LogId) ,
  
  classifed_sleep as 
  (
  select Id , LogId, sleep_start , sleep_end, duration_minutes ,
 

case
-- afternoon sleep: starts between 12 PM and 5 PM (< 3 hours)
when time(sleep_start) between '12:00:00' and '16:59:59' 
 and duration_minutes < 180 then 'afternoon sleep'

-- evening sleep: starts between 5 PM and 7 PM (< 3 hours)
when time(sleep_start) between '17:00:00' and '18:59:59' 
 and duration_minutes < 180 then 'evening sleep'

-- normal night sleep: starts between 7 PM and midnight
when time(sleep_start) >= '19:00:00' then 'normal night sleep'

-- late night sleep: goes to bed after midnight (between 12 AM and 5 AM)
when time(sleep_start) < '05:00:00' then 'late night sleep'

else 'others'
end as sleep_type
  from sleep_summary ),
  
  -- night_sleep as (
--   select Id , LogId , sleep_start , sleep_end , duration_minutes from classifed_sleep
--   where sleep_type in ('normal night sleep','late night sleep') ) 

night_sleep AS (
    SELECT
        Id,
        LogId,
        sleep_start,
        sleep_end,
        duration_minutes,
        case when time(sleep_start) >= '19:00:00' then hour(sleep_start)*60 + minute(sleep_start) 
        else (hour(sleep_start)+24)*60 + minute(sleep_start) 
        end as onset_minutes 

    FROM classifed_sleep

    WHERE sleep_type IN (
        'normal night sleep',
        'late night sleep'
    )

    AND duration_minutes BETWEEN 240 AND 720
) , 
wake_time as 
(
select Id, LogId , sleep_start, sleep_end, duration_minutes , 
case when time(sleep_end) < '12:00:00' then hour(sleep_end) * 60 + minute(sleep_end) 
else hour(sleep_end) *60 +minute(sleep_end) 
end as wake_minutes 
from night_sleep
) ,
summary_table as (
select Id , Count(*) as night_sleep_records , round(avg(wake_minutes),2) as avg_wake_minutes , 
round(stddev_samp(wake_minutes),2) as wake_time_minutes from wake_time group by Id 
having count(*) >=2 ) 

select case when wake_time_minutes <=30 then 'Highly regular' 
when wake_time_minutes <=45 then 'Relatively regular'
when wake_time_minutes <=75 then 'Moderate varition' 
else 'Substantial varition'
end as wake_type 
, count(*) as users,
round(count(*) *  100.0 /( select count(*) from summary_table ),2)from summary_table  
group by wake_type;

-- ACtivity and Sleep Relation 

with activity_summary as (
select Id , round(avg(VeryActiveMinutes),2) as avg_very_active_minutes , 
round(avg(FairlyActiveMinutes),2) as avg_fair_active_minutes ,
round(avg(LightlyActiveMinutes),2) as avg_lightly_active_minutes 
from daily_activity 
group by Id ),
sleep_summary as (
select Id , round(avg(TotalMinuteAsleep),2) as avg_sleep_minutes ,
round(avg(TotalTimeInBed),2) as avg_time_in_bed , round(avg(TotalTimeInBed - TotalMinuteAsleep),2) as avg_awake_minutes 
from sleep_activity group by Id ),
user_level as (
select a.Id, 
a.avg_very_active_minutes,
a.avg_fair_active_minutes,
a.avg_lightly_active_minutes,

s.avg_sleep_minutes ,
s.avg_time_in_bed ,
s.avg_awake_minutes 
from activity_summary  a 
inner  join sleep_summary s on a.Id = s.Id 
),
stats as (
select
avg(avg_very_active_minutes) as mean_very,
avg(avg_fair_active_minutes) as mean_fair,
avg(avg_lightly_active_minutes) as mean_light,
avg(avg_sleep_minutes) as mean_sleep
from user_level
)
-- select round(corr(avg_very_active_minutes, avg_sleep_minutes),2) as very_active_vs_sleep ,
-- round(corr(avg_fair_active_minutes,avg_sleep_minutes),2) as fairly_active_vs_sleep , 
-- round(corr(avg_lightly_active_minutes,avg_sleep_minutes),2) as lightly_active_vs_sleep from user_level;


-- for correlation of sleep and activity ............................ 
select
round(
sum((u.avg_very_active_minutes - s.mean_very) * (u.avg_sleep_minutes - s.mean_sleep)) /
sqrt(sum(pow(u.avg_very_active_minutes - s.mean_very, 2)) * sum(pow(u.avg_sleep_minutes - s.mean_sleep, 2))),
2
) as very_active_vs_sleep,
round(
sum((u.avg_fair_active_minutes - s.mean_fair) * (u.avg_sleep_minutes - s.mean_sleep)) /
sqrt(sum(pow(u.avg_fair_active_minutes - s.mean_fair, 2)) * sum(pow(u.avg_sleep_minutes - s.mean_sleep, 2))),
2
) as fairly_active_vs_sleep,
round(
sum((u.avg_lightly_active_minutes - s.mean_light) * (u.avg_sleep_minutes - s.mean_sleep)) /
sqrt(sum(pow(u.avg_lightly_active_minutes - s.mean_light, 2)) * sum(pow(u.avg_sleep_minutes - s.mean_sleep, 2))),
2
) as lightly_active_vs_sleep
from user_level u
cross join stats s;


-- time in bed vs activity 

with activity_summary as (
select id , round(avg(VeryActiveMinutes),2) as avg_very_active_minutes , 
round(avg(FairlyActiveMinutes),2) as avg_fair_active_minutes ,
round(avg(LightlyActiveMinutes),2) as avg_lightly_active_minutes 
from daily_activity 
group by id ),
sleep_summary as (
select id , round(avg(TotalMinuteAsleep),2) as avg_sleep_minutes ,
round(avg(TotalTimeInBed),2) as avg_time_in_bed , round(avg(TotalTimeInBed - TotalMinuteAsleep),2) as avg_awake_minutes 
from sleep_activity group by id ),
user_level as (
select a.id, 
a.avg_very_active_minutes,
a.avg_fair_active_minutes,
a.avg_lightly_active_minutes,
s.avg_sleep_minutes ,
s.avg_time_in_bed ,
s.avg_awake_minutes 
from activity_summary  a 
inner  join sleep_summary s on a.id = s.id 
),
stats as (
select
avg(avg_very_active_minutes) as mean_very,
avg(avg_fair_active_minutes) as mean_fair,
avg(avg_lightly_active_minutes) as mean_light,
avg(avg_time_in_bed) as mean_time_in_bed,
avg(avg_awake_minutes) as mean_awake_minutes
from user_level
)
select
  round(sum((u.avg_very_active_minutes - a.mean_very) * (u.avg_awake_minutes - a.mean_awake_minutes)) / 
    sqrt(sum(pow(u.avg_very_active_minutes - a.mean_very, 2)) * sum(pow(u.avg_awake_minutes - a.mean_awake_minutes, 2))), 3) as very_active_vs_awake,

  round(sum((u.avg_fair_active_minutes - a.mean_fair) * (u.avg_awake_minutes - a.mean_awake_minutes)) / 
    sqrt(sum(pow(u.avg_fair_active_minutes - a.mean_fair, 2)) * sum(pow(u.avg_awake_minutes - a.mean_awake_minutes, 2))), 3) as fairly_active_vs_awake,

  round(sum((u.avg_lightly_active_minutes - a.mean_light) * (u.avg_awake_minutes - a.mean_awake_minutes)) / 
    sqrt(sum(pow(u.avg_lightly_active_minutes - a.mean_light, 2)) * sum(pow(u.avg_awake_minutes - a.mean_awake_minutes, 2))), 3) as lightly_active_vs_awake,

  round(sum((u.avg_very_active_minutes - a.mean_very) * (u.avg_time_in_bed - a.mean_time_in_bed)) / 
    sqrt(sum(pow(u.avg_very_active_minutes - a.mean_very, 2)) * sum(pow(u.avg_time_in_bed - a.mean_time_in_bed, 2))), 3) as very_active_vs_time_in_bed,

  round(sum((u.avg_fair_active_minutes - a.mean_fair) * (u.avg_time_in_bed - a.mean_time_in_bed)) / 
    sqrt(sum(pow(u.avg_fair_active_minutes - a.mean_fair, 2)) * sum(pow(u.avg_time_in_bed - a.mean_time_in_bed, 2))), 3) as fairly_active_vs_time_in_bed,

  round(sum((u.avg_lightly_active_minutes - a.mean_light) * (u.avg_time_in_bed - a.mean_time_in_bed)) / 
    sqrt(sum(pow(u.avg_lightly_active_minutes - a.mean_light, 2)) * sum(pow(u.avg_time_in_bed - a.mean_time_in_bed, 2))), 3) as lightly_active_vs_time_in_bed

from user_level u
cross join stats a;

-- Very active	 -0.125	  -0.230	-0.177
-- Fairly active	-0.138	+0.156	-0.058
-- Lightly active	-0.263	-0.175	-0.270

-- night sleep frequency

with sleep_summary as (select id,
logid, min(activityminute) as sleep_start, max(activityminute) as sleep_end,
timestampdiff(
minute, min(activityminute), max(activityminute) ) as duration_minutes
from sleep_data
group by id, logid ),

classified_sleep as (
select
id,
logid,
sleep_start,
sleep_end,
duration_minutes,

case
when time(sleep_start) between '12:00:00' and '16:59:59'
and duration_minutes < 180
then 'afternoon sleep'

when time(sleep_start) between '17:00:00' and '18:59:59'
and duration_minutes < 180
then 'evening sleep'

when time(sleep_start) >= '19:00:00'
then 'normal night sleep'

when time(sleep_start) < '05:00:00'
then 'late night sleep'

else 'others'
end as sleep_type

from sleep_summary
),

night_sleep as (
select
id,
logid,
sleep_start,
sleep_end,
duration_minutes
from classified_sleep
where sleep_type in (
'normal night sleep',
'late night sleep'
)
and duration_minutes between 240 and 720
)

select
case
when duration_minutes < 300 then '<5 hours'
when duration_minutes < 360 then '5–6 hours'
when duration_minutes < 420 then '6–7 hours'
when duration_minutes < 480 then '7–8 hours'
when duration_minutes < 540 then '8–9 hours'
else '9+ hours'
end as sleep_duration_group,

count(*) as nights,
count(distinct id) as users,

round(
count(*) * 100.0 / (select count(*) from night_sleep),
2
) as percentage

from night_sleep
group by sleep_duration_group
order by min(duration_minutes);

 -- night sleep frequency by user 
 
 with sleep_summary as (
select
id,
logid,
min(activityminute) as sleep_start,
max(activityminute) as sleep_end,
timestampdiff(
minute,
min(activityminute),
max(activityminute)
) as duration_minutes
from sleep_data
group by id, logid
),

classified_sleep as (
select
id,
logid,
sleep_start,
sleep_end,
duration_minutes,
case
when time(sleep_start) between '12:00:00' and '16:59:59'
and duration_minutes < 180
then 'afternoon sleep'

when time(sleep_start) between '17:00:00' and '18:59:59'
and duration_minutes < 180
then 'evening sleep'

when time(sleep_start) >= '19:00:00'
then 'normal night sleep'

when time(sleep_start) < '05:00:00'
then 'late night sleep'

else 'others'
end as sleep_type
from sleep_summary
),

night_sleep as (
select
id,
logid,
sleep_start,
sleep_end,
duration_minutes
from classified_sleep
where sleep_type in ('normal night sleep', 'late night sleep')
and duration_minutes between 240 and 720
),

user_sleep as (
select
id,
count(*) as total_night_sessions,

sum(
case
when duration_minutes < 360 then 1
else 0
end
) as short_sleep_sessions,

round(
sum(
case
when duration_minutes < 360 then 1
else 0
end
) * 100.0 / count(*),
2
) as short_sleep_percentage

from night_sleep
group by id
having count(*) > 15
),

segmented as (
select
id,
total_night_sessions,
short_sleep_sessions,
short_sleep_percentage,

case
when short_sleep_percentage >= 30
then 'Frequent short-sleep'

when short_sleep_percentage >= 15
then 'Moderate short-sleep'

else 'Infrequent short-sleep'
end as sleep_group

from user_sleep
)

select
sleep_group,
count(*) as users,

round(
count(*) * 100.0 / sum(count(*)) over (),
2
) as user_percentage

from segmented
group by sleep_group;

-- avg of frequency
with sleep_summary as (
select id, logid, min(activityminute) as sleep_start, max(activityminute) as sleep_end, timestampdiff(minute, min(activityminute), max(activityminute)) as duration_minutes
from sleep_data group by id, logid
),
classified_sleep as (
select id, logid, sleep_start, sleep_end, duration_minutes,
case
when time(sleep_start) between '12:00:00' and '16:59:59' and duration_minutes < 180 then 'afternoon sleep'
when time(sleep_start) between '17:00:00' and '18:59:59' and duration_minutes < 180 then 'evening sleep'
when time(sleep_start) >= '19:00:00' then 'normal night sleep'
when time(sleep_start) < '05:00:00' then 'late night sleep'
else 'others'
end as sleep_type
from sleep_summary
),
night_sleep as (
select id, logid, sleep_start, sleep_end, duration_minutes,
case when time(sleep_start) >= '19:00:00' then hour(sleep_start) * 60 + minute(sleep_start) else (hour(sleep_start) + 24) * 60 + minute(sleep_start) end as onset_minutes,
case when time(sleep_end) < '12:00:00' then hour(sleep_end) * 60 + minute(sleep_end) else hour(sleep_end) * 60 + minute(sleep_end) end as wake_minutes
from classified_sleep
where sleep_type in ('normal night sleep', 'late night sleep') and duration_minutes between 240 and 720
),
user_sleep as (
select id, count(*) as total_night_sessions,
sum(case when duration_minutes < 360 then 1 else 0 end) as short_sleep_sessions,
round(sum(case when duration_minutes < 360 then 1 else 0 end) * 100.0 / count(*), 2) as short_sleep_percentage,
round(stddev_samp(onset_minutes), 2) as onset_stddev_minutes,
round(stddev_samp(wake_minutes), 2) as wake_stddev_minutes
from night_sleep group by id having count(*) > 15
),
segmented as (
select *,
case
when short_sleep_percentage >= 30 then 'Frequent short-sleep'
when short_sleep_percentage >= 15 then 'Moderate short-sleep'
else 'Infrequent short-sleep'
end as sleep_group
from user_sleep
)
select sleep_group, count(*) as users,
round(avg(short_sleep_percentage), 2) as avg_short_sleep_percentage,
round(avg(onset_stddev_minutes), 2) as avg_onset_variation_minutes,
round(avg(wake_stddev_minutes), 2) as avg_wake_variation_minutes
from segmented group by sleep_group
order by case sleep_group when 'Frequent short-sleep' then 1 when 'Moderate short-sleep' then 2 when 'Infrequent short-sleep' then 3 end;


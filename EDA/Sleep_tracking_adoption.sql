-- activity users vs sleep users 

with mar_apr_data as(
select 'Activity' as data_type ,count(distinct Id) as users from daily_activity
where DATE(ActivityDate) < '2016-04-12'
union all
select 'Sleep' as data_type,count(distinct Id) as users_of_sleep from sleep_activity
where DATE(SleepDay) < '2016-04-12'),
apr_may_data as (
select 'Activity' as data_type ,count(distinct Id) as users from daily_activity
where DATE(ActivityDate) >= '2016-04-12'
union all
select 'Sleep' as data_type, count(distinct Id) as users_of_slee from sleep_activity
where DATE(SleepDay) >= '2016-04-12')
select a.data_type ,a.users as mar_apr_users , b.users as apr_may_users from mar_apr_data a
inner join apr_may_data b on a.data_type = b.data_type ;

-- User level sleep adoption 

with mar_apr_sleep as (
select
id,
count(distinct sleepday) as sleep_days
from sleep_activity
where date(sleepday) < '2016-04-12'

group by id
),
mar_apr_adoption as (
select
id,
sleep_days,
round(sleep_days * 100.0 / 31, 2) as sleep_adoption_percentage,
case
when sleep_days < 16 then 'low'
when sleep_days <= 25 then 'moderate'
else 'high'
end as sleep_adoption_level
from mar_apr_sleep
),
apr_may_sleep as (
select
id,
count(distinct sleepday) as sleep_days
from sleep_activity
where date(sleepday) >= '2016-04-12'

group by id
),
apr_may_adoption as (
select
id,
sleep_days,
round(sleep_days * 100.0 / 30, 2) as sleep_adoption_percentage,
case
when sleep_days < 16 then 'low'
when sleep_days <= 25 then 'moderate'
else 'high'
end as sleep_adoption_level
from apr_may_sleep
)
select
coalesce(a.id, b.id) as id,
a.sleep_days as mar_apr_sleep_days,
a.sleep_adoption_percentage as mar_apr_percentage,
a.sleep_adoption_level as mar_apr_level,
b.sleep_days as apr_may_sleep_days,
b.sleep_adoption_percentage as apr_may_percentage,
b.sleep_adoption_level as apr_may_level
from mar_apr_adoption as a
left join apr_may_adoption as b
on a.id = b.id
order by id;


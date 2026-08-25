-- checking the start and end of dates .............................

select min(activitydate) as start_date, max(activitydate) as end_date,
count(distinct activitydate) as total_recorded_dates,
count(distinct id) as total_users
from daily_activity;

-- Active days per user mar - apr ............................................

with user_activity as (
select id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate) between '2016-03-12' and '2016-04-11'
group by id
)
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage
from user_activity
order by active_days desc;

-- Active days per user apr - mar  ............................................

with user_activity as (
select id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate) between '2016-04-12' and '2016-05-11'
group by id
)
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage
from user_activity
order by active_days desc;

-- comparision of data of may and apr / apr - may .........................
with user_activity as (
select id,
count(distinct activitydate) as active_days
from daily_activity
where date(activitydate) < '2016-04-12'
group by id
),

engagement as (
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage,
case
when active_days < 16 then 'low'
when active_days < 25 then 'moderate'
else 'high'
end as engagement_level
from user_activity
),

user_activity_2 as (
select id,
count(distinct activitydate) as active_days
from daily_activity
where date(activitydate) >= '2016-04-12'
group by id
),

engagement_2 as (
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage,
case
when active_days < 16 then 'low'
when active_days < 25 then 'moderate'
else 'high'
end as engagement_level
from user_activity_2
)

select a.id,
a.active_days as mar_apr_active_days,
a.engagement_percentage as mar_apr_percentage,
b.active_days as apr_may_active_days,
b.engagement_percentage as apr_may_percentage
from engagement as a
left join engagement_2 as b
on a.id = b.id
order by a.id;



-- Distributio in may - apr data 
with user_activity as (
select id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate)
between '2016-03-12' and '2016-04-11'
group by id
),

engagement as (
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage,
case
when active_days < 16 then 'low'
when active_days < 25 then 'moderate'
else 'high'
end as engagement_level
from user_activity
)

select engagement_level,
count(*) as users,
round(
count(*) * 100.0 /
(select count(*) from engagement),
2
) as user_percentage
from engagement
group by engagement_level
order by
case
when engagement_level = 'low' then 1
when engagement_level = 'moderate' then 2
else 3
end;

-- Distribution in apr - may data 

with user_activity as (
select id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate) >= '2016-04-12'
group by id
),

engagement as (
select id,
active_days,
31 - active_days as inactive_days,
round(active_days * 100.0 / 31, 2) as engagement_percentage,
case
when active_days < 16 then 'low'
when active_days < 25 then 'moderate'
else 'high'
end as engagement_level
from user_activity
)

select engagement_level,
count(*) as users,
round(
count(*) * 100.0 /
(select count(*) from engagement),
2
) as user_percentage
from engagement
group by engagement_level
order by
case
when engagement_level = 'low' then 1
when engagement_level = 'moderate' then 2
else 3
end;
    

with mar_apr as (
select
id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate)
between '2016-03-12' and '2016-04-11'
group by id
),
apr_may as (
select
id,
count(distinct date(activitydate)) as active_days
from daily_activity
where date(activitydate)
between '2016-04-12' and '2016-05-12'
group by id
),
user_comparison as (
select
m.id,
m.active_days as mar_apr_days,
a.active_days as apr_may_days,
round(m.active_days * 100.0 / 31, 2) as mar_apr_percentage,
round(a.active_days * 100.0 / 31, 2) as apr_may_percentage
from mar_apr as m
inner join apr_may as a
on m.id = a.id
) ,
summary_table as (select
id,
mar_apr_days,
apr_may_days,
mar_apr_percentage,
apr_may_percentage,
round(apr_may_percentage - mar_apr_percentage, 2) as percentage_point_change,
case
when apr_may_percentage > mar_apr_percentage then 'increased'
when apr_may_percentage < mar_apr_percentage then 'decreased'
else 'no change'
end as engagement_change
from user_comparison
order by percentage_point_change desc) 

select engagement_change as category , count(*) from summary_table group by engagement_change ;
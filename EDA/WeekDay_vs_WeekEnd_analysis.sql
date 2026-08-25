-- Weekend vs weekday comparision of activites 
select case when dayofweek(ActivityDate) in (1,7) then 'Weekend' else 'Weekday' end as day_types ,
round(avg(TotalSteps),2) as avg_total_steps ,
round(avg(TotalDistance),2) as avg_total_distance ,
round(avg(VeryActiveDistance) ,2) as avg_very_active_dis,
round(avg(ModeratelyActiveDistance) ,2) as avg_Moderate_active_dis,
round(avg(LightActivityDistance),2) as avg_light_active_dis,
round(avg(SedentaryActiveDistance) ,2) as avg_inactive_active_dis,
round(avg(VeryActiveMinutes) ,2) as avg_very_active_minutes ,
round(avg(FairlyActiveMinutes) ,2) as avg_fairly_active_minutes ,
round(avg(LightlyActiveMinutes) ,2) as avg_light_active_minutes ,
round(avg(SedentaryMinutes) ,2) as avg_inactive_minutes 
from daily_activity  
group by day_types ;

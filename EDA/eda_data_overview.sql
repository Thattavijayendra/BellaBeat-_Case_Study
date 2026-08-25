use fit_bit_analysis_cleaned ;

describe daily_activity;

-- Table Overview
select * from daily_activity limit 10;

-- Rows and Users 
select count(*) as No_of_Rows , count(distinct Id) as No_Unique_Id from daily_activity;

-- Date Ranges
select min(ActivityDate) as StartDate , max(ActivityDate) as EndDate from daily_activity;

-- Checking Duplicates
select Id , ActivityDate , count(*) from daily_activity 
group by Id , ActivityDate 
having count(*) > 1;
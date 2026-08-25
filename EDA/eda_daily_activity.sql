-- Daily Activity EDA ..............................................



-- Overall activity statistics
SELECT
    ROUND(AVG(TotalSteps), 2) AS avg_steps,
    MIN(TotalSteps) AS min_steps,
    MAX(TotalSteps) AS max_steps,

    ROUND(AVG(Calories), 2) AS avg_calories,
    MIN(Calories) AS min_calories,
    MAX(Calories) AS max_calories,

    ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active,
    ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active,
    ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active,
    ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary
FROM daily_activity;


-- Activity-level distribution 

SELECT 
    CASE 
        WHEN TotalSteps < 2500 THEN 'Inactive'
        WHEN TotalSteps < 5000 THEN 'Low'
        WHEN TotalSteps < 10000 THEN 'Moderate'
        ELSE 'High'
    END AS activity_level,

    COUNT(*) AS total_days,

    ROUND(AVG(TotalSteps), 2) AS avg_steps,

    ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes,

    ROUND(AVG(LightlyActiveMinutes), 2) AS avg_lightly_active_minutes,

    ROUND(AVG(FairlyActiveMinutes), 2) AS avg_fairly_active_minutes,

    ROUND(AVG(VeryActiveMinutes), 2) AS avg_very_active_minutes,

    ROUND(AVG(Calories), 2) AS avg_calories

FROM daily_activity

GROUP BY activity_level

ORDER BY 
    CASE 
        WHEN activity_level = 'Inactive' THEN 1
        WHEN activity_level = 'Low' THEN 2
        WHEN activity_level = 'Moderate' THEN 3
        ELSE 4
    END;
    
    
-- User-level behavior
 SELECT
    Id,
    ROUND(AVG(TotalSteps), 0) AS avg_steps,
    ROUND(AVG(Calories), 0) AS avg_calories,
    ROUND(AVG(SedentaryMinutes), 0) AS avg_sedentary_minutes,
    ROUND(AVG(VeryActiveMinutes), 1) AS avg_very_active_minutes,
    COUNT(*) AS recorded_days
FROM daily_activity
GROUP BY Id
ORDER BY avg_steps DESC;

-- Activity vs sedentary behavior
SELECT 
    CASE 
        WHEN TotalSteps < 2500 THEN 'Inactive'
        WHEN TotalSteps < 5000 THEN 'Low'
        WHEN TotalSteps < 10000 THEN 'Moderate'
        ELSE 'High'
    END AS activity_level, 

    ROUND(AVG(SedentaryMinutes), 2) AS avg_sedentary_minutes, 
    ROUND(AVG(Calories), 2) AS avg_calories 

FROM daily_activity 

GROUP BY activity_level 

ORDER BY 
    CASE 
        WHEN activity_level = 'Inactive' THEN 1
        WHEN activity_level = 'Low' THEN 2
        WHEN activity_level = 'Moderate' THEN 3
        ELSE 4
    END;
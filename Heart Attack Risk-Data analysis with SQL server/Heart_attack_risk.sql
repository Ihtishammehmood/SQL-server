select*

from heart_attack_risk

--1. Can you provide an overview of the age distribution within the dataset? How does age correlate with heart attack risk?

select
age, count(*) as count_per_age
from heart_attack_risk
where [Heart Attack Risk] = 1

group by Age
order by Age

--group wise heart attack risk

select
[Age Group], count(*) as count_per_age
from heart_attack_risk
where [Heart Attack Risk] = 1

group by [Age Group]
order by [Age Group]

--2What is the gender distribution among the patients, and how does gender influence heart attack risk?



select 
Sex,
count(*) as CountPerGender


from heart_attack_risk
where [Heart Attack Risk] = 1
group by 
Sex

--3Could you explain the relationship between cholesterol levels and heart attack risk? Are there specific thresholds that indicate higher risk?
--a.average cholesterol level for patients
select 
avg(case when [Heart Attack Risk] = 1 then Cholesterol end) as AvgCholesterol_HighRisk,
  AVG(CASE WHEN [Heart Attack Risk] = 0 THEN [Cholesterol] END) AS AvgCholesterol_LowRisk

from heart_attack_risk

--b.identify specific cholesterol thresholds that indicate higher heart attack risk.
select 
[Heart Attack Risk],
avg(Cholesterol) as avg_cholesterol

from heart_attack_risk

group by [Heart Attack Risk]

--4.How does blood pressure (systolic and diastolic) correlate with the risk of heart attack?
select 
[Heart Attack Risk],
avg([Systolic BP]) as avgSystolicBP,
avg([Diastolic BP] ) as avgDiastolicBP

from 
heart_attack_risk
group by [Heart Attack Risk]
--5. Are there any notable patterns or correlations between heart rate and the risk of a heart attack?

select 
[Heart Attack Risk],
avg([Heart Rate]) as avg_heartrate

from heart_attack_risk

group by [Heart Attack Risk]
--6.What can we learn about the impact of diabetes on heart attack risk within this dataset?

select 
Diabetes,[Heart Attack Risk],
count(*)  as patinet_count

from heart_attack_risk
group by 

Diabetes, [Heart Attack Risk]

--7.Is there a significant difference in heart attack risk between smokers and non-smokers?
select 
Smoking,
[Heart Attack Risk],
count(*) PatientCount,
cast(count(*) as float) / sum(count(*)) over (partition by smoking) as RiskPercentage

from heart_attack_risk

group by Smoking,[Heart Attack Risk]

--8.How does obesity, as indicated by BMI, relate to heart attack risk in this dataset?

select 
case
when BMI <18.5 then 'underweight'
when BMI >=18.5 and BMI< 24.9 then 'normal weight'
when BMI>= 25 and BMI<29.9 then 'overweight'
when BMI> = 30 then 'obese'
else 'Unknown/invalid BMI'
end as BMI_Category,
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over (partition by case
															when BMI <18.5 then 'underweight'
															when BMI >=18.5 and BMI< 24.9 then 'normal weight'
															when BMI>= 25 and BMI<29.9 then 'overweight'
															when BMI> = 30 then 'obese'
															else 'Unknown/invalid BMI'
															end) as RiskPercentage

from heart_attack_risk
group by 
case
when BMI <18.5 then 'underweight'
when BMI >=18.5 and BMI< 24.9 then 'normal weight'
when BMI>= 25 and BMI<29.9 then 'overweight'
when BMI> = 30 then 'obese'
else 'Unknown/invalid BMI'
end,
[Heart Attack Risk]
order by BMI_Category 

-- 9.Do patients with a family history of heart-related problems have a higher risk of experiencing a heart attack?

select 
[Family History],
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over (partition by [Family History]) as RiskPercentage

from heart_attack_risk

group by [Family History],[Heart Attack Risk]

--11.Can you analyze the influence of exercise hours per week on heart attack risk?

select 
case 
when [Exercise Hours Per Week]<1 then 'none/less than 1 hour'
when [Exercise Hours Per Week]>= 1 and [Exercise Hours Per Week] <3 then '1-3 hours'
when [Exercise Hours Per Week]>=3 and [Exercise Hours Per Week]	<5 then '3-5 hours'
when [Exercise Hours Per Week] >= 5 then '5+ hours'
else 'unknown'
end as ExerciceHoursCategory,
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over(partition by

case
when [Exercise Hours Per Week]<1 then 'none/less than 1 hour'
when [Exercise Hours Per Week]>= 1 and [Exercise Hours Per Week] <3 then '1-3 hours'
when [Exercise Hours Per Week]>=3 and [Exercise Hours Per Week]	<5 then '3-5 hours'
when [Exercise Hours Per Week] >= 5 then '5+ hours'
else 'unknown'
end) as RiskPercentage

from heart_attack_risk

group by 
case 
when [Exercise Hours Per Week]<1 then 'none/less than 1 hour'
when [Exercise Hours Per Week]>= 1 and [Exercise Hours Per Week] <3 then '1-3 hours'
when [Exercise Hours Per Week]>=3 and [Exercise Hours Per Week]	<5 then '3-5 hours'
when [Exercise Hours Per Week] >= 5 then '5+ hours'
else 'unknown'
end,
[Heart Attack Risk]

--12.What is the effect of stress levels on heart attack risk in this dataset?

select 
[Stress Level],
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over(partition by [Stress Level]) as RiskPercentage
from heart_attack_risk
group by [Stress Level],[Heart Attack Risk]
order by [Heart Attack Risk] asc

--13.Are there any geographical or regional patterns regarding heart attack risk among patients in different countries or continents?

SELECT
    ISNULL([Country], 'Unknown') AS Location,
    ISNULL([Continent], 'Unknown') AS Continent,
    [Heart Attack Risk],
    COUNT(*) AS PatientCount,
    CAST(COUNT(*) AS FLOAT) / SUM(COUNT(*)) OVER (PARTITION BY ISNULL([Country], 'Unknown')) AS RiskPercentage
FROM
    heart_attack_risk
GROUP BY
    [Country], [Continent], [Heart Attack Risk]

	order by PatientCount desc


--14How does income level correlate with heart attack risk?

SELECT
    CASE
        WHEN Income < 30000 THEN 'Low Income'
        WHEN Income >= 30000 AND Income < 60000 THEN 'Moderate Income'
        WHEN Income >= 60000 AND Income < 90000 THEN 'Upper Moderate Income'
        WHEN Income >= 90000 THEN 'High Income'
        ELSE 'Unknown/Invalid Income'
    END AS IncomeCategory,
    [Heart Attack Risk],
    COUNT(*) AS PatientCount
    
FROM
    heart_attack_risk
GROUP BY
    CASE
        WHEN Income < 30000 THEN 'Low Income'
        WHEN Income >= 30000 AND Income < 60000 THEN 'Moderate Income'
        WHEN Income >= 60000 AND Income < 90000 THEN 'Upper Moderate Income'
        WHEN Income >= 90000 THEN 'High Income'
        ELSE 'Unknown/Invalid Income'
    END,
    [Heart Attack Risk];


	
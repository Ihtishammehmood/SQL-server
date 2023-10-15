**Table of Content**
- [Data Analysis with SQL Server(Heart Attack Risk)](#data-analysis-with-sql-serverheart-attack-risk)
    - [1. Can you provide an overview of the age distribution within the dataset? How does age correlate with heart attack risk?](#1-can-you-provide-an-overview-of-the-age-distribution-within-the-dataset-how-does-age-correlate-with-heart-attack-risk)
    - [2.What is the gender distribution among the patients, and how does gender influence heart attack risk?](#2what-is-the-gender-distribution-among-the-patients-and-how-does-gender-influence-heart-attack-risk)
    - [3.Could you explain the relationship between cholesterol levels and heart attack risk? Are there specific thresholds that indicate higher risk?](#3could-you-explain-the-relationship-between-cholesterol-levels-and-heart-attack-risk-are-there-specific-thresholds-that-indicate-higher-risk)
    - [4. How does blood pressure (systolic and diastolic) correlate with the risk of heart attack?](#4-how-does-blood-pressure-systolic-and-diastolic-correlate-with-the-risk-of-heart-attack)
    - [5. Are there any notable patterns or correlations between heart rate and the risk of a heart attack?](#5-are-there-any-notable-patterns-or-correlations-between-heart-rate-and-the-risk-of-a-heart-attack)
    - [6.What can we learn about the impact of diabetes on heart attack risk within this dataset?](#6what-can-we-learn-about-the-impact-of-diabetes-on-heart-attack-risk-within-this-dataset)
    - [7.Is there a significant difference in heart attack risk between smokers and non-smokers?](#7is-there-a-significant-difference-in-heart-attack-risk-between-smokers-and-non-smokers)
    - [8. How does obesity, as indicated by BMI, relate to heart attack risk in this dataset?](#8-how-does-obesity-as-indicated-by-bmi-relate-to-heart-attack-risk-in-this-dataset)
    - [9. Do patients with a family history of heart-related problems have a higher risk of experiencing a heart attack?](#9-do-patients-with-a-family-history-of-heart-related-problems-have-a-higher-risk-of-experiencing-a-heart-attack)
    - [10.Can you analyze the influence of exercise hours per week on heart attack risk?](#10can-you-analyze-the-influence-of-exercise-hours-per-week-on-heart-attack-risk)
    - [11.What is the effect of stress levels on heart attack risk in this dataset](#11what-is-the-effect-of-stress-levels-on-heart-attack-risk-in-this-dataset)
    - [12.Are there any geographical or regional patterns regarding heart attack risk among patients in different countries or continents?](#12are-there-any-geographical-or-regional-patterns-regarding-heart-attack-risk-among-patients-in-different-countries-or-continents)
    - [13.How does income level correlate with heart attack risk?](#13how-does-income-level-correlate-with-heart-attack-risk)
  - [Corralation matrix](#corralation-matrix)








# Data Analysis with SQL Server(Heart Attack Risk)

In utilizing SQL Server for data analysis on a dataset pertaining to heart rate risk, a comprehensive examination of the dataset was conducted to extract valuable insights and patterns related to heart rate and associated risks. SQL queries were employed to aggregate and summarize heart rate data, calculate averages, standard deviations, and other relevant statistical metrics. Additionally, filtering and grouping functions in SQL were used to categorize heart rate data based on predefined risk levels, facilitating a thorough analysis of how heart rate correlates with varying risk factors. This approach allowed for a deeper understanding of the dataset, enabling the identification of potential correlations between heart rate, risk factors, and the overall assessment of cardiovascular health. The insights gained from this analysis can be instrumental in formulating strategies for risk mitigation, personalized healthcare plans, or research initiatives focused on improving heart health.

**[Click here to access Article](https://www.linkedin.com/posts/ihtishammehmood_predictiveanalytics-descriptiveanalytics-activity-7116823766046785536-ZMjZ?utm_source=share&utm_medium=member_desktop)**
>[Data Source](httpswww.kaggle.comdatasetsiamsouravbanerjeeheart-attack-prediction-dataset)

> [Click here to see visualization](https://public.tableau.com/app/profile/ihtisham.mehmood/viz/HeartAttackRiskDashboard_16964318022960/Dashboard1)

The SQL server has been used to answer some insightful question. These Question are as follows:

### 1. Can you provide an overview of the age distribution within the dataset? How does age correlate with heart attack risk?

``````sql
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
``````

The first SQL query counts the occurrences of individuals with a heart attack risk (Heart Attack Risk = 1) based on their age, providing a count for each age group. The second query does a similar count but groups the data by age groups, summarizing the heart attack risk occurrences in each age group. These queries aim to analyze heart attack risk distribution in the dataset by age and age groups, facilitating a better understanding of risk patterns and potential interventions.

### 2.What is the gender distribution among the patients, and how does gender influence heart attack risk?

This SQL query counts and summarizes the occurrences of heart attack risk (where Heart Attack Risk = 1) based on gender (Sex), providing a count for each gender. It helps analyze how heart attack risk is distributed among different genders in the dataset.

``````sql
select 
Sex,
count(*) as CountPerGender
from heart_attack_risk
where [Heart Attack Risk] = 1
group by 
Sex
``````
Sex | CountPerGender
|---| ------|
Male | 2195
Female | 944

### 3.Could you explain the relationship between cholesterol levels and heart attack risk? Are there specific thresholds that indicate higher risk?

> Average cholesterol level for patients

``````sql
select 
avg(case when [Heart Attack Risk] = 1 then Cholesterol end) as AvgCholesterol_HighRisk,
  AVG(CASE WHEN [Heart Attack Risk] = 0 THEN [Cholesterol] END) AS AvgCholesterol_LowRisk
from heart_attack_risk
``````

This SQL query calculates the average cholesterol levels for individuals categorized into high risk (Heart Attack Risk = 1) and low risk (Heart Attack Risk = 0) groups. It provides insights into the average cholesterol levels for each risk category, aiding in understanding the potential correlation between cholesterol levels and heart attack risk.

AvgCholesterol_HighRisk | AvgCholesterol_LowRisk
------------------------|-----------------------
261.970372730169 | 258.708926031294

> Identify specific cholesterol thresholds that indicate higher heart attack risk.

``````sql
select 
[Heart Attack Risk],
avg(Cholesterol) as avg_cholesterol
from heart_attack_risk
group by [Heart Attack Risk]
``````

This SQL code is retrieving information from a table named "heart_attack_risk." It calculates the average cholesterol levels for individuals based on their heart attack risk, categorizing the data into two groups: heart attack risk of 0 and heart attack risk of 1. The AVG function computes the average cholesterol for each group. The GROUP BY clause groups the data based on the heart attack risk, allowing for separate calculations for each risk category. The resulting output shows the heart attack risk (0 or 1) and the corresponding average cholesterol level for each risk category.

Heart Attack Risk | avg_cholesterol
------------------|----------------
0 | 258.708926031294
1 | 261.970372730169

### 4. How does blood pressure (systolic and diastolic) correlate with the risk of heart attack?

This SQL code is querying a table named "heart_attack_risk." It calculates the average systolic blood pressure (avgSystolicBP) and average diastolic blood pressure (avgDiastolicBP) for individuals based on their heart attack risk, categorizing the data into two groups: heart attack risk of 0 and heart attack risk of 1. The AVG function is used to compute the averages for each blood pressure measure within each risk group. The GROUP BY clause organizes the data by heart attack risk, facilitating separate calculations for each risk category. The resulting output displays the heart attack risk (0 or 1) and the corresponding average systolic and diastolic blood pressure for each risk category. This information helps analyze the relationship between blood pressure and heart attack risk.

``````sql
select 
[Heart Attack Risk],
avg([Systolic BP]) as avgSystolicBP,
avg([Diastolic BP] ) as avgDiastolicBP
from 
heart_attack_risk
group by [Heart Attack Risk]
``````

Heart Attack Risk | avgSystolicBP | avgDiastolicBP
------------------|---------------|---------------
0 | 134.709815078236 | 85.2384423897582
1 | 135.731124561962 | 85.0086014654349

### 5. Are there any notable patterns or correlations between heart rate and the risk of a heart attack?

``````sql
select 
[Heart Attack Risk],
avg([Heart Rate]) as avg_heartrate
from heart_attack_risk
group by [Heart Attack Risk]
``````

In this SQL query, we're examining data from a table called "heart_attack_risk." We want to analyze the average heart rate for individuals in two distinct groups based on heart attack risk: those with a heart attack risk of 0 (low risk) and those with a heart attack risk of 1 (high risk).

We're using the AVG function to calculate the average heart rate for each risk group. The AVG function takes the heart rate data and calculates the mean value for heart rate within each risk category.

The GROUP BY clause is crucial here because it allows us to aggregate the data and group it based on heart attack risk. This means we'll get separate average heart rate values for the low-risk and high-risk groups.

The resulting output will display two rows: one for the low-risk group (heart attack risk = 0) and one for the high-risk group (heart attack risk = 1), each showing the corresponding average heart rate for that particular risk category. This information provides valuable insights into potential correlations between heart rate and heart attack risk.

### 6.What can we learn about the impact of diabetes on heart attack risk within this dataset?

This SQL code counts the number of patients based on whether they have diabetes and their heart attack risk . We're organizing the count of patients into groups based on these factors using the GROUP BY clause. The resulting output provides counts for each combination of diabetes status and heart attack risk, helping to understand the distribution of patients in different risk categories based on diabetes.

``````sql
select 
Diabetes,[Heart Attack Risk],
count(*)  as patinet_count
from heart_attack_risk
group by 
Diabetes, [Heart Attack Risk]
``````

### 7.Is there a significant difference in heart attack risk between smokers and non-smokers?

``````sql
select 
Smoking,
[Heart Attack Risk],
count(*) PatientCount,
cast(count(*) as float) / sum(count(*)) over (partition by smoking) as RiskPercentage
from heart_attack_risk
group by Smoking,[Heart Attack Risk]
``````

Smoking | Heart Attack Risk | PatientCount | RiskPercentage
--------|-------------------|--------------|---------------
0 | 0 | 575 | 0.636061946902655
0 | 1 | 329 | 0.363938053097345
1 | 0 | 5049 | 0.642448148619417
1 | 1 | 2810 | 0.357551851380583

This SQL code counts the number of patients based on their smoking status and heart attack risk. We're calculating the patient count and the risk percentage for each combination of smoking and heart attack risk using the GROUP BY clause. The RiskPercentage is calculated by dividing the patient count for each smoking status by the total count for that smoking status, providing insights into the proportion of patients at risk within each smoking category.

### 8. How does obesity, as indicated by BMI, relate to heart attack risk in this dataset?

In this SQL code, we're categorizing patients based on their Body Mass Index (BMI) into different BMI categories: underweight, normal weight, overweight, obese, or an unknown/invalid BMI. We're also considering their heart attack risk (0 or 1).

The CASE statement evaluates each patient's BMI and assigns them to the appropriate BMI category. We're then counting the number of patients in each BMI category and calculating the risk percentage for each category. The RiskPercentage is calculated by dividing the count of patients in a specific BMI category by the total count of patients within that BMI category.

The GROUP BY clause groups the data by BMI category and heart attack risk, allowing us to calculate patient counts and risk percentages for each BMI category and heart attack risk combination.

Finally, we're ordering the results by the BMI categories to present the information in a structured manner, making it easier to analyze the data. This SQL query provides valuable insights into how BMI categories relate to heart attack risk percentages.

``````sql
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
``````
BMI_Category | Heart Attack Risk | PatientCount | RiskPercentage
-------------|-------------------|--------------|---------------
normal weight | 0 | 1620 | 0.627663696241767
normal weight | 1 | 961 | 0.372336303758233
obese | 0 | 2486 | 0.64055655758825
obese | 1 | 1395 | 0.35944344241175
overweight | 1 | 696 | 0.343873517786561
overweight | 0 | 1328 | 0.656126482213439
underweight | 1 | 59 | 0.28921568627451
underweight | 0 | 145 | 0.71078431372549
Unknown/invalid BMI | 1 | 28 | 0.383561643835616
Unknown/invalid BMI | 0 | 45 | 0.616438356164384


### 9. Do patients with a family history of heart-related problems have a higher risk of experiencing a heart attack?

``````sql
select 
[Family History],
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over (partition by [Family History]) as RiskPercentage
from heart_attack_risk
group by [Family History],[Heart Attack Risk
``````

Family History | Heart Attack Risk | PatientCount | RiskPercentage
---------------|-------------------|--------------|---------------
0 | 0 | 2848 | 0.641008327706505
0 | 1 | 1595 | 0.358991672293495
1 | 0 | 2776 | 0.642592592592593
1 | 1 | 1544 | 0.357407407407407

In this SQL code, we're examining patients based on their family history of heart conditions and their respective heart attack risk . We're interested in understanding how family history might relate to heart attack risk.

Using the GROUP BY clause, we're organizing the data into groups based on family history and heart attack risk. For each group, we're calculating the patient count and the risk percentage, which tells us the proportion of patients at risk within each family history category.

The RiskPercentage is computed by dividing the count of patients in a specific family history and heart attack risk group by the total count of patients within that family history group. This allows us to assess the risk percentage for each family history scenario, providing valuable insights into potential correlations between family history and heart attack risk.

### 10.Can you analyze the influence of exercise hours per week on heart attack risk?

``````sql
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
``````

This SQL code categorizes patients based on their weekly exercise hours into different exercise hour categories: none/less than 1 hour, 1-3 hours, 3-5 hours, 5+ hours, or an unknown category. We're also considering their heart attack risk.

The CASE statement evaluates each patient's exercise hours per week and assigns them to the appropriate exercise hour category. We're then counting the number of patients in each exercise hour category and calculating the risk percentage for each category. The RiskPercentage is calculated by dividing the count of patients in a specific exercise hour category by the total count of patients within that category.

The GROUP BY clause groups the data by exercise hour category and heart attack risk, allowing us to calculate patient counts and risk percentages for each exercise hour category and heart attack risk combination.

This analysis provides valuable insights into how exercise hours per week might relate to heart attack risk, offering a clear understanding of the risks associated with varying levels of physical activity.

ExerciceHoursCategory | Heart Attack Risk | PatientCount | RiskPercentage
----------------------|-------------------|--------------|---------------
1-3 hours | 1 | 281 | 0.334126040428062
1-3 hours | 0 | 560 | 0.665873959571938
3-5 hours | 0 | 561 | 0.63677639046538
3-5 hours | 1 | 320 | 0.36322360953462
5+ hours | 0 | 4211 | 0.641236485457591
5+ hours | 1 | 2356 | 0.358763514542409
none/less than 1 hour | 1 | 182 | 0.383966244725738
none/less than 1 hour | 0 | 292 | 0.616033755274262


### 11.What is the effect of stress levels on heart attack risk in this dataset

In this SQL code, we're examining patients based on their reported stress levels and their respective heart attack risk. The goal is to understand if there's a correlation between stress levels and heart attack risk.

Using the GROUP BY clause, we're organizing the data into groups based on stress levels and heart attack risk. For each group, we're calculating the patient count and the risk percentage, which tells us the proportion of patients at risk within each stress level category.

The RiskPercentage is computed by dividing the count of patients in a specific stress level and heart attack risk group by the total count of patients within that stress level group. This allows us to assess the risk percentage for each stress level, aiding in identifying potential connections between stress levels and heart attack risk.

Lastly, we're ordering the results by heart attack risk in ascending order, which helps to present the information in a structured manner for easier analysis. This SQL query provides valuable insights into 
how stress levels might relate to heart attack risk.

`````` sql

select 
[Stress Level],
[Heart Attack Risk],
count(*) as PatientCount,
cast(count(*) as float) / sum(count(*)) over(partition by [Stress Level]) as RiskPercentage
from heart_attack_risk
group by [Stress Level],[Heart Attack Risk]
order by [Heart Attack Risk] asc
``````

Stress Level | Heart Attack Risk | PatientCount | RiskPercentage
-------------|-------------------|--------------|---------------
1 | 0 | 562 | 0.64971098265896
2 | 0 | 583 | 0.63855421686747
3 | 0 | 551 | 0.634792626728111
4 | 0 | 597 | 0.656043956043956
5 | 0 | 543 | 0.631395348837209
6 | 0 | 533 | 0.623391812865497
7 | 0 | 567 | 0.627906976744186
8 | 0 | 568 | 0.646188850967008
9 | 0 | 584 | 0.658399098083427
10 | 0 | 536 | 0.651275820170109
10 | 1 | 287 | 0.348724179829891
9 | 1 | 303 | 0.341600901916573
8 | 1 | 311 | 0.353811149032992
6 | 1 | 322 | 0.376608187134503
7 | 1 | 336 | 0.372093023255814
5 | 1 | 317 | 0.368604651162791
3 | 1 | 317 | 0.365207373271889
4 | 1 | 313 | 0.343956043956044
2 | 1 | 330 | 0.36144578313253
1 | 1 | 303 | 0.35028901734104


### 12.Are there any geographical or regional patterns regarding heart attack risk among patients in different countries or continents?

``````sql
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
``````

In this SQL code, we're analyzing patients based on their location (country and continent) and their respective heart attack risk. The goal is to understand the distribution of heart attack risk across different locations.

The ISNULL function is used to replace any null values in the 'Country' and 'Continent' columns with 'Unknown' to ensure clarity and consistency in the results.

Using the GROUP BY clause, we're organizing the data into groups based on location and heart attack risk. For each group, we're calculating the patient count and the risk percentage, which tells us the proportion of patients at risk within each location.

The RiskPercentage is computed by dividing the count of patients in a specific location and heart attack risk group by the total count of patients within that location. This allows us to assess the risk percentage for each location, aiding in understanding how heart attack risk is distributed globally or regionally.

Lastly, we're ordering the results by patient count in descending order (hence 'desc'), allowing us to identify the locations with the highest patient counts, which might be of particular interest for further analysis. This SQL query provides valuable insights into the distribution of heart attack risk across different locations.


### 13.How does income level correlate with heart attack risk?

``````sql
ELECT
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
    [Heart Attack Risk]
``````

IncomeCategory | Heart Attack Risk | PatientCount
---------------|-------------------|-------------
High Income | 0 | 4175
High Income | 1 | 2342
Upper Moderate Income | 1 | 355
Low Income | 1 | 110
Moderate Income | 1 | 332
Upper Moderate Income | 0 | 601
Low Income | 0 | 234
Moderate Income | 0 | 614

This SQL code categorizes patients into income categories (Low Income, Moderate Income, Upper Moderate Income, High Income, or Unknown/Invalid Income) based on their income levels. It also considers their heart attack risk (0 or 1). The CASE statement evaluates each patient's income and assigns them to the appropriate income category. Using the GROUP BY clause, the data is organized into groups based on income category and heart attack risk. For each group, the code calculates the patient count, providing insights into the distribution of patients across income categories and their respective heart attack risk. This analysis helps in understanding the potential relationship between income levels and heart attack risk.

## Corralation matrix

![Alt text](<correlation matrix-1.PNG>)

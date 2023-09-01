## Table of Contetns
- [SQL Queries for data Retrieval](#sql-queries-for-data-retrieval)
  - [Detecting outliers with(IQR)](#detecting-outliers-withiqr)
  - [How has net worth changed over the years?](#how-has-net-worth-changed-over-the-years)
  - [Are there any trends in terms of business industries that tend to have more self-made individuals?](#are-there-any-trends-in-terms-of-business-industries-that-tend-to-have-more-self-made-individuals)
  - [Which countries have the highest average net worth among their citizens?](#which-countries-have-the-highest-average-net-worth-among-their-citizens)
  - [What percentage of individuals in the dataset are classified as self-made?](#what-percentage-of-individuals-in-the-dataset-are-classified-as-self-made)
  - [Is there a difference in net worth between genders within the same age group?](#is-there-a-difference-in-net-worth-between-genders-within-the-same-age-group)




# SQL Queries for data Retrieval


An SQL query is a statement built by putting together various SQL commands. These SQL commands together perform a specific task to access, manage, modify, update, control, and organize your data stored in a database and managed via a DBMS
In this project severael SQL queries has been initiated to retrieve tha data from the data database  which is creating on a [Dataset](https://www.kaggle.com/datasets/guillemservera/forbes-billionaires-1997-2023)

> [See data visualization here](https://public.tableau.com/app/profile/ihtisham.mehmood/viz/Forbes-billionaires1997-2023/Story1)

## Detecting outliers with(IQR)

IQR is  one of the common and effective tecniques to identify the outlier and to cap and remove the outlier so to reduce the skewness of data. Outliers deeply effect the overall population when mean is takken 

``````sql
select 
case 
when net_worth is null  then null
when net_worth < q1 - 1.5 * iqr or net_worth > q3 + 1.5 *iqr then 'outliers'
else 'not outlier' end 
from ( select *,
PERCENTILE_CONT(0.25) within group(order by net_worth) over () as q1,
PERCENTILE_CONT(0.75) within group (order by net_worth) over () as q3,
PERCENTILE_CONT(0.75) within group (order by net_worth) over ()-
PERCENTILE_CONT(0.25) within group(order by net_worth) over () as iqr
from FB)  as data_with_percentiles
``````

In this query the IQR formula has put to a use which is a follows:
> IQR = Q3-Q1


1. The inner subquery calculates three important statistics for the net worth values in a table called "FB":

- q1: The first quartile, which is the 25th percentile (25% of the data is below this value).
- q3: The third quartile, which is the 75th percentile (75% of the data is below this value).
- iqr: The interquartile range, which is the difference between q3 and q1. It represents the middle 50% of the data.

2. The outer query uses a CASE statement to evaluate each net worth value  
   

- If a net worth value is NULL, it returns NULL, meaning there's no classification for it.
- If a net worth value is less than q1 - 1.5 times the interquartile range (iqr) or greater than q3 + 1.5 times iqr, it is classified as an "outlier."
-Otherwise, if the net worth value falls within the range defined by 1.5 times iqr around the interquartile range, it is classified as "not an outlier.

## How has net worth changed over the years?

To answer this question the folliwng query has been used:

``````sql
select top 5
year ,full_name,
avg(net_worth) as average_net_worth
from FB
where  outlier_status = 'not outlier' 
group by year,full_name
order by average_net_worth desc
``````

In this query the avarge of Networth is taken it is grouped by year to check the change at invidual year. I have excluded that outliers from the data set
to get more sacalable results

> Resulting when outliers are included are as follows:

Year | Full name | Net_worth(BN)
------- | ------- | -------
   | 
2021 | Alexander Abramov | 7.6
2018 | Alexei Kuzmichev | 7.6
2006 | Alexey Mordashov | 7.6
2017 | Aloys Wobben | 7.6
2010 | Ananda Krishnan | 7.6

>Resulting when outliers are excluded are as follows:

year | full_name | average_net_worth(BN)
------- | ------- | -------
 |  | 
2022 | Elon Musk | 219
2023 | Bernard Arnault & family | 211
2023 | Elon Musk | 180
2021 | Jeff Bezos | 177
2022 | Jeff Bezos | 171

By looking at this change we clearly see that oultier has significant impact on the data set and impact on our analysis

## Are there any trends in terms of business industries that tend to have more self-made individuals?

In order to get the answer of this question the following query has been used:
``````sql
select business_industries,
count(*) as total_individuals,
 SUM(CASE WHEN self_made = '1' THEN 1 ELSE 0 END) AS self_made_count,
    (SUM(CASE WHEN self_made ='1' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS self_made_percentage
from FB
where  outlier_status = 'not outlier' 
group by business_industries
order by self_made_percentage desc
``````

This SQL query calculates the total number of individuals, counts the number of self-made individuals, and calculates the percentage of self-made individuals within each business industry group, but it only considers individuals who are not classified as outliers. The results are then sorted to show industries with the highest percentages of self-made individuals first.

## Which countries have the highest average net worth among their citizens?

country_of_citizenship | avg_networth(BN)
-----------------------|-----------------
|
Eswatini (Swaziland) | 4.8
Georgia | 4.6
Denmark | 3.94347826086956
Swaziland | 3.92857142857143
Algeria | 3.89
South Africa | 3.56044776119403
Colombia | 3.45
Nigeria | 3.28571428571429
Portugal | 3.25961538461538
New Zealand | 3.25416666666667

This is the out which we receive when we run 
``````sql
select top 10
country_of_citizenship,
avg(net_worth) as avg_networth
from FB
where outlier_status = 'not outlier'
group by country_of_citizenship
order by avg_networth  desc
``````
this query

## What percentage of individuals in the dataset are classified as self-made?

This is a very important question and answer this first Let me show you that output.

total_individuals | self_made_count | inherited_percentage | self_made_percentage
------- | ------- | ------- | -------
 |  |  | 
23734 | 15320 | 64.548748630656 | 35.451251369343

The following Results has been ahcieved with the help of following query:

``````sql
SELECT 
    COUNT(*) AS total_individuals,
    SUM(CASE WHEN self_made = '1' THEN 1 ELSE 0 END) AS self_made_count,
    (SUM(CASE WHEN self_made = '1' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS self_made_percentage,
	 (SUM(CASE WHEN self_made = '0' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS inherited_percentage
FROM 
   FB
   WHERE 
  outlier_status = 'not outlier'
  ``````
  
  This SQL query calculates the total number of individuals in the dataset, counts the number of self-made individuals, and calculates both the percentage of self-made individuals and the percentage of those who inherited wealth. It only considers individuals who are not classified as outliers.

 ## Is there a difference in net worth between genders within the same age group?

 The question reqires some uniqe kind of query to get the answer
 .First let me show you the answer.

gender | age_group | avg_networth(BN)
------- | ------- | -------
 |  | 
Female | 18-29 | 1.48695652173913
Male | 18-29 | 2.31153846153846
Female | 30-29 | 2.37264957264957
Male | 30-29 | 2.32085020242915
Female | 40-49 | 2.21849315068493
Male | 40-49 | 2.19327782290821
Female | 50+ | 2.68313253012049
Male | 50+ | 2.5268571585419

This table gives a good summary about the age group and within particular age group we can see average networth(BN)

``````sql
select 
gender, age_group,
avg(net_worth) as avg_networth
from ( 
select gender , 
case when age >=18 and age<30 then '18-29'
when age >=30 and age< 40 then '30-29'
when age >= 40 and age<50 then '40-49'
else '50+' end as age_group,net_worth
from FB
where outlier_status = 'not outlier'
) as age_gender_data
group by gender,age_group
order by age_group,gender 
``````

This query is explaining its self.
Different age group is being created with the case statement and and gouping the result

- The inner subquery starts by selecting two columns: "gender" and a derived column "age_group." The "age_group" column is calculated based on the "age" column's values using a CASE statement. It categorizes individuals into different age groups: '18-29' for ages 18 to 29, '30-39' for ages 30 to 39, '40-49' for ages 40 to 49, and '50+' for ages 50 and above. It also selects the "net_worth" column.

 this SQL query groups individuals by their gender and age groups, calculates the average net worth for each group, and presents the results in an ordered format. It only considers individuals who are not classified as outliers in the "FB" dataset.
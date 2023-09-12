# Contents
- [Contents](#contents)
  - [The Oscars](#the-oscars)
    - [**Analyze Changes in Number of Films or Nominations Over the Years**](#analyze-changes-in-number-of-films-or-nominations-over-the-years)
    - [**Identify Individuals Winning Multiple Times in Different Categories or Films**](#identify-individuals-winning-multiple-times-in-different-categories-or-films)
    - [**Analyze Patterns in Winning**](#analyze-patterns-in-winning)
    - [**Films with Most Awards**](#films-with-most-awards)
    - [**Correlation between Nominations and Awards**](#correlation-between-nominations-and-awards)
    - [**Trend of Multiple Awards in a Single Ceremony**](#trend-of-multiple-awards-in-a-single-ceremony)
    - [**Categories with Most Nominations and Awards**](#categories-with-most-nominations-and-awards)
    - [**Identifying Frequent Nominees with 0 Wins**](#identifying-frequent-nominees-with-0-wins)
    - [**Nomination to win relationship**](#nomination-to-win-relationship)
    - [**Exploring Correlation between Longevity and Winning**](#exploring-correlation-between-longevity-and-winning)
    
   






----------------------------

## The Oscars

The dataset under consideration is a comprehensive collection of information related to awards ceremonies in the film industry.In order to gain meaningful insights from this dataset, SQL Server is utilized. SQL Server allowed me to perform structured queries on the dataset, enabling me to unravel trends, correlations, and patterns that might be hidden within the vast amount of information.
>[Data Source](https://www.kaggle.com/datasets/unanimad/the-oscar-award)

### **Analyze Changes in Number of Films or Nominations Over the Years**

``````sql
select year_film, count(*) as number_of_entries
from [The oscars]
group by year_film
order by year_film
``````

The query retrieves data from the dataset  to show how many films were entered in award ceremonies each year. It groups the data by the "year_film" column, calculates the count of entries for each year, and presents the results in chronological order. This helps us understand the distribution of films over different years and identify trends in film participation within award ceremonies.

### **Identify Individuals Winning Multiple Times in Different Categories or Films**

This query analyzes the dataset [The oscars] to find award winners who have won in multiple categories or films. It calculates the distinct counts of categories and films for each winner, focusing on rows where "winner" is 1.

``````sql
select name, count(distinct category) as distinct_category_count, 
count(distinct film) as distinct_film_count
from  [The oscars]
where winner =1
group by name
having count(distinct category)>1 or count(distinct film) >1
order by name
``````

The results are grouped by the individuals' names and filtered to include only those with counts greater than 1 for either category or film. The outcome is ordered by name, helping us recognize individuals with diverse award achievements.

### **Analyze Patterns in Winning**

This query calculates the total wins and total entries for each individual. By using these counts, it computes the win percentage by dividing the total wins by the total entries and multiplying by 100. The results are grouped by individuals' names and ordered in descending order of win percentage. This query helps understand which individuals have high win percentages in award ceremonies, giving insight into their success in the film industry.

``````sql
select
name, count(case when winner =1  then 1 else null end) as total_wins,
count(*) as total_entries,
(count(case when winner = 1 then 1 else null end) * 100) / count(*) as win_percentage
from [The oscars]
group by name 
order by win_percentage desc
``````

### **Films with Most Awards**

This query highlight the top 10 films that have received the most awards. It calculates the total number of awards for each film, considering only rows where "winner" is 1.

``````sql
select top 10
film, count(*) as Total_awards,year_film
from [The oscars]
where winner = 1
group by film,year_film
order by Total_awards desc
``````

The results are grouped by film and the year the film was released. The outcome is then ordered in descending order based on the total awards. In essence, this query helps us identify the films that have won the most awards and their corresponding release years, offering insights into notable achievements in the film industry.

### **Correlation between Nominations and Awards**

``````sql
select film, 
sum(case when winner = 1 then 1 else 0 end) as total_wins,
count(*) total_nominations
from [The oscars]
group by film
order by total_nominations desc
``````

This query is used to analyze films' success in award ceremonies. It calculates the total wins by summing the cases where "winner" is 1 and counts the total nominations for each film. The results are grouped by film and ordered in descending order based on the total nominations. This query helps us understand which films have the highest number of nominations and wins, providing insights into their performance in award events.

### **Trend of Multiple Awards in a Single Ceremony**

this query helps us pinpoint ceremonies with multiple award winners, revealing instances of shared recognition within an event.

``````sql
select ceremony,count(*) as total_multiple_winners
from
( select ceremony,film,count(*) as wins_in_ceremony
from [The oscars]
where winner = 1
group by ceremony,film
having count(*) >1) as multiple_wins
group by ceremony
order by ceremony
``````

### **Categories with Most Nominations and Awards**

``````sql
select
category,
sum(case when winner = 1 then 1 else 0 end) as total_wins,
count(*) as total_nominations
from [The oscars]
group by category
order by total_wins desc, total_nominations desc
``````

This query is used to understand award categories' success. It calculates the total wins  by summing the cases where "winner" is 1 and counts the total nominations  for each category. The results are grouped by category and ordered in descending order based on total wins and total nominations. This helps us identify which categories have the most wins and nominations, providing insights into popular and celebrated award fields.

### **Identifying Frequent Nominees with 0 Wins**

This query is used to find individuals who have received multiple nominations but haven't won any awards. It counts the total nominations  and calculates the total wins  where "winner" is 1, grouped by both film and individual's name.

``````sql
select name, film,
count(*) as total_nominations,
sum(case when winner = 1 then 1 else 0 end) as total_wins
from [The oscars]
group by film,name
having count(*) >1  and sum(case when winner = 1 then 1 else 0 end) = 0
order by total_nominations desc
``````

It filters the results to include only those with more than one nomination and zero wins. The outcome is ordered by total nominations in descending order, helping us identify frequent nominees who haven't achieved victories.

### **Nomination to win relationship**

This query It calculates the total wins  and the count of only nominations  for each category, based on whether "winner" is 1 or 0. The results are grouped by category and ordered in descending order based on total wins. This query helps us understand which categories have the most wins and nominations without victories, offering insights into the distribution of awards and nominations in different fields.

``````sql
select 
category,
sum(case when winner =1 then 1 else 0 end) as  total_wins,
sum(case when winner =0 then 1 else 0 end) as only_nominations 
from [The oscars]
group by 
category
order by total_wins desc
``````

### **Exploring Correlation between Longevity and Winning**

``````sql
select name,min(year_film) as first_year_niminated,
max(year_film) as last_year_nominated,
count(distinct year_film) as total_year_nominated,
count(distinct case when winner =1 then year_film  end) as  total_years_won
from [The oscars]
group by name
having count(distinct year_film)>1
order by total_years_won desc , total_year_nominated desc
``````

This query has been helpful in  examining the award journey of individuals. It calculates the earliest year nominated ("first_year_nominated"), the latest year nominated ("last_year_nominated"), the count of different nominated years ("total_year_nominated"), and the count of years won ("total_years_won") where "winner" is 1. The results are grouped by individual's name and filtered to include only those with nominations in more than one year. The outcomes are then ordered by years won and total nominated years in descending order. This query helps identify individuals with sustained involvement and successful achievements in the awards landscape.



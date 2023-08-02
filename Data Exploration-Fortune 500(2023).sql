


--companies at 1,2,3 rank in a year 2023
select 
rank, year, name, revenue_mil


from [500]
where year ='2023' and rank in ('1','2','3')
order by rank asc
---which company remaind on top rank more than the other(1996-2023)


select
rank, count(name),name
from [500]

where rank = 1

group by name,rank

update [500]
set name = replace(name,'General Motors Company', 'General Motors')

where name = 'General Motors Company'

select name

from [500]

where name like '%walmart%'


--top performing industry?
with cte as (
select 
industry,rank,revenue_mil,
count(industry) over (partition by industry) as industry_repetation,
row_number() over (partition by industry order by rank desc )as r_n

from [500]
where rank <= 5 
and year>= '2015' and year<= '2023'
)
select *

from cte 

where r_n = 1 

order by revenue_mil desc


-- seems like petrolium industry has been in top industry since its been remained in top 3 rank 32th time which is more than 
--any other industry

select top 1
industry,
count(industry) over (partition by industry) as industry_repetation


from [500]
where rank <= 3
order by industry_repetation desc

--Is there a correlation between the size of a company (measured by metrics like market value, revenue, or assets) and its profitability or rank?
--Ans)Ans: After exploring the data, the change of ranking is highly reliant on revenue earned in a fiscal year. The company
--which has earned higehst revenue each fiscal has its place to the top means being 1st in the rank.
select year, count(name),name,rank, revenue_mil,market_value_mil,asset_mil

from [500]

where year>= 2015  and year<= 2023 and market_value_mil is not null

group by year, name, revenue_mil,market_value_mil,asset_mil,rank

order by rank asc
--How many companies in the Fortune 500 have their founders serving as CEOs? Do founder-led companies perform differently from non-founder-led ones?
-- ANS) The Companies who are having founders as Ceo are showing relatively more reveneue and profit on average basis compare to non founder ceos.

SELECT 
        CASE WHEN founder_is_ceo = 'yes' THEN 'founder_is_ceo'
             WHEN founder_is_ceo = 'no' THEN 'founder_not_ceo'
             ELSE 'Unknown' END AS ceo_type,
        AVG(convert(float,revenue_mil)) AS avg_revenue,
    AVG(convert(float,profit_mil)) AS avg_profit,
    AVG(convert(float,market_value_mil)) AS avg_market_value,
    AVG(convert(float,asset_mil)) AS avg_asset,
    AVG(convert(float,employees)) AS avg_employees
    FROM [500]

	group by founder_is_ceo
------What is the representation of female CEOs in the Fortune 500? Are there any trends or changes over the years in the number of female CEOs?

	select count(year) ceo_count ,year, female_ceo,
	
	case when female_ceo ='yes' then 'female_ceo'
	when female_ceo = 'no' then 'male_ceo'
	end as ceo_type
	from [500]
	
	where female_ceo is not null 
	group by female_ceo,year
	order by year asc
	
	-----Which companies are new to the Fortune 500 list? What are the characteristics of these newcomers, and how do they compare to companies that have been on the list for a longer time?
	----ANS) seems like new to fortune five hundered are those companies which are not old enough.still these comanies are making alot of effort to gain a good pace 
	select
	avg(convert(float,revenue_mil)) as avg_revenue,
	avg(convert(float,profit_mil)) as avg_profit,
	avg(convert(float,market_value_mil)) as avg_mrkt_value,
	avg(convert(float,asset_mil)) as avg_assets,
	avg(convert(float,employees)) as avg_employees,
	case 
	when newcomer_to_fortune_500 = 'yes' then 'newbie'
	when newcomer_to_fortune_500 = 'no' then 'veteran'
	else 'unkown'
	end as company_catagory
	from [500]

	group by 
	newcomer_to_fortune_500

	----How many of the Fortune 500 companies are also part of the Global 500 list? Is there a correlation between global representation and financial performance?
	---ANS) There are total of 983 companies which are part of global 500
	SELECT
    CASE WHEN global_500 = 'yes' THEN 'Part of Global 500'
	when global_500 = 'no' then 'not part of global 500'
         ELSE 'unknown' END AS global_status,
    AVG(convert(float,revenue_mil)) AS avg_revenue,
    AVG(convert(float,profit_mil)) AS avg_profit,
    AVG(convert(float,market_value_mil)) AS avg_market_value,
    AVG(convert(float,asset_mil)) AS avg_asset,
    AVG(convert(float,employees)) AS avg_employees
FROM [500] 
GROUP BY global_500;
---calculating total fortune 500 which are part of global 500
with cte as(
select count(name) as total,name

from [500]

where global_500 = 'yes'
group by name)

select sum(total) as global_500

from cte

---Are there any specific industries or sectors that have high revenue but low profitability or vice versa? Which industries are the most profitable?

select 
industry,sector,
avg(convert(float,revenue_mil))as avg_revenue,
avg(convert(float,profit_mil))as avg_profit

from [500]
where year >= 2015 and year <= 2023

group by industry,sector
order by avg_profit desc
----Has the composition or performance of the Fortune 500 companies been affected by global events (e.g., economic downturns, pandemics)?
----Ans) seems like there is a slight impact on a reveneue in 2020 and again it boomed up in 2021
select year, avg(convert(float,revenue_mil)) as avg_revenue_mil

from [500]

where year in('2019', '2020','2021')

group by year

order by year asc

----Can we identify any unique characteristics or trends specific to certain sectors within the Fortune 500 list?

select
sector, avg(convert(float,revenue_mil)) as avg_revenue_mil,
avg(convert(float, profit_mil)) as avg_profit_mil

from [500]
where year>=2015 and year<=2023
group by sector
order by avg_revenue_mil desc

---Is there a correlation between diversity in leadership (e.g., having female CEOs) and a company's financial performance?

select female_ceo, avg(convert(float, revenue_mil)) as avg_revenue_mil,
avg(convert(float,profit_mil)) as avg_profit_mil,count(year) as total_count,year

from [500]
where female_ceo = 'yes'
group by year,female_ceo

order by total_count asc


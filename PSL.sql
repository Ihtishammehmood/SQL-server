--highest scorer in the match

select top 1
striker, sum(runs_off_bat) as scores

from psl

where match_id = '1247036'

group by 
striker
order by
scores
desc

---highest wicket taker in the match

select top 1
count(player_dismissed) as player_out ,bowler

from PSL

where match_id = '1247036'

group by bowler

order by player_out
desc

--who won the match?
select 
 match_id,
MAX(team_score) AS team_score,
 MAX(CASE WHEN team_score = max_score THEN batting_team END) AS winning_team
FROM 
(SELECT 
        match_id,
        batting_team,
        SUM(runs_off_bat + extras) AS team_score,
        MAX(SUM(runs_off_bat + extras)) OVER (PARTITION BY match_id) AS max_score
    FROM 
        PSL
    WHERE 
        innings IN ('1', '2') 
    GROUP BY 
        match_id, batting_team) AS subquery
GROUP BY 
    match_id;

	---inserting data into a newly created table
	

	insert into team_won (match_id , team_score, winning_team)
	select 
 match_id,
MAX(team_score) AS team_score,
 MAX(CASE WHEN team_score = max_score THEN batting_team END) AS winning_team
FROM 
(SELECT 
        match_id,
        batting_team,
        SUM(runs_off_bat + extras) AS team_score,
        MAX(SUM(runs_off_bat + extras)) OVER (PARTITION BY match_id) AS max_score
    FROM 
        PSL
    WHERE 
        innings IN ('1', '2') 
    GROUP BY 
        match_id, batting_team) AS subquery
GROUP BY 
    match_id;
---Total wins by teams in each PSL season (1-7)

select *

from PSL as t1

inner join team_won as  t2
on t1.match_id = t2.match_id



select t2.match_id    , t1.season, count(distinct t2.winning_team) as total_wins , t2.winning_team

from PSL as t1

inner join team_won as  t2
on t1.match_id = t2.match_id


group by t2.match_id,t1.season,t2.winning_team

order by t2.winning_team



--Top striker in winnnig team in each match(from s1 to s8)

WITH CTE AS (
    SELECT t2.winning_team, t1.striker, SUM(t1.runs_off_bat) AS total_runs, t1.date_only,
           ROW_NUMBER() OVER (PARTITION BY t1.match_id ORDER BY SUM(t1.runs_off_bat) DESC) AS rn
    FROM PSL AS t1
    INNER JOIN team_won AS t2 ON t1.match_id = t2.match_id
    WHERE t1.date_only = date_only
    GROUP BY t2.winning_team, t1.striker, t1.date_only, t1.match_id
)
SELECT winning_team, striker, total_runs, date_only
FROM CTE
WHERE rn = 1


---top three grounds with highest sixes in all seasons (1-7)

select top 3
venue, runs_off_bat, count(venue) as total_sixes

from PSL

where runs_off_bat = '6'
group by 
venue , runs_off_bat 

order by total_sixes desc

---highest sixes in a ground in each season

with CTE as ( select 

venue, season, runs_off_bat ,
count(runs_off_bat) over(partition by season) as total_sixes,
row_number() over(partition by season order by season desc) as r_n

 from PSL
  where runs_off_bat = '6' 
  )

  select venue, season, runs_off_bat, total_sixes, r_n

  from CTE
  where r_n = '1'



 

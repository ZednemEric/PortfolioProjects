--This data exploration exercises are used to display data manipulation skills for analysis
-- Find the number of venues for Euro Cup2016 --
Select COUNT(venue_id)
From [dbo].[soccer_venue]

--Write a query in SQL to find the number countries participated in the EURO cup 2016. (player_mast)
Select COUNT(DIstinct(team_id))
FROM [dbo].[player_mast];

--Write a query in SQL to find the number goals scored in EURO cup 2016 within normal play schedule.(goal_details)--
SELECT COUNT(*) 
FROM goal_details;

--Write a query in SQL to find the number of matches ended with a result in WIN.--
SELECT COUNT(*) 
FROM match_mast 
WHERE results='WIN';

--Write a query in SQL to find the number of matches ended with draws.
SELECT COUNT(*) 
FROM match_mast 
WHERE results='DRAW';

--Write a query in SQL to find the date when did Football EURO cup 2016 begin.(match_mast)--
SELECT play_date "Beginning Date"
FROM match_mast
WHERE match_no  = 1;

--Write a query in SQL to find the number of self-goals scored in EURO cup 2016.( goal_details)--
Select COUNT(goal_type)
FROM goal_details
WHERE goal_type = 'O'

--Write a query in SQL to count the number of matches ended with a win in group stage. (match_mast)--
Select COUNT(play_stage)
FROM match_mast
WHERE results = 'WIN' and play_stage = 'G'

--  Write a query in SQL to find the number of matches got a result by penalty shootout. (penalty_shootout)--
Select COUNT(Distinct(match_no))
FROM penalty_shootout;

-- Write a query in SQL to find the number of matches were decided on penalties in the Round of 16. (match_mast)--
SELECT COUNT(decided_by)
FROM match_mast
WHERE decided_by = 'P'
and play_stage = 'R';
-- Write a query in SQL to find the number of goal scored in every match within normal play schedule. (goal_details)--
Select match_no, COUNT(goal_id) as 'Goal Count'
FROM goal_details
WHERE goal_schedule = 'NT'
GROUP BY match_no 
ORDER BY match_no;

--Write a query in SQL to find the match no, date of play, and goal scored for that match in which no stoppage time have been added in 1st half of play. (match_mast)-
Select match_no, play_date, goal_score
FROM match_mast
WHERE stop1_sec = 0;

--Write a query in SQL to find the number of matches ending with a goalless draw in group stage of play. (match_details)--
SELECT COUNT(DISTINCT(match_no)) -- finding unique match ID because there is a result recorded for the winner and lose--
FROM [dbo].[match_details]
WHERE win_lose = 'D' and goal_score = 0
AND play_stage = 'G';

--Write a query in SQL to find the number of matches ending in WIN with only one goal win except those matches which was decided by penalty shootout.(match_details)--
SELECT COUNT(match_no)
FROM match_details
WHERE win_lose = 'W' and goal_score = 1 and decided_by = 'N'; 

--Write a query in SQL to find the total number of players replaced in the tournament. (player_in_out)--
SELECT COUNT(match_no) as 'Player Replaced'
FROM[dbo].[player_in_out]
WHERE in_out = 'I';

--write a SQL query to count the total number of players replaced during normal playtime. Return number of players as "Player Replaced". --
SELECT COUNT(match_no) as 'Player Replaced'
FROM[dbo].[player_in_out]
WHERE in_out = 'I'
and play_schedule = 'NT';

--write a SQL query to count the number of players who were replaced during the stoppage time. Return number of players as "Player Replaced".--
SELECT COUNT(match_no) as 'Player Replaced'
FROM[dbo].[player_in_out]
WHERE in_out = 'I'
and play_schedule = 'ST';

-- Write a query in SQL to find the total number of palyers replaced within normal time of play.(player_in_out)--
SELECT COUNT(match_no) as 'Player Replaced'
FROM[dbo].[player_in_out]
WHERE in_out = 'I'
and play_half = 1
and play_schedule = 'NT';

--write a SQL query to count the total number of goalless draws played in the entire tournament. Return number of goalless draws. --
SELECT COUNT(DISTINCT match_no) 
FROM match_details 
WHERE win_lose='D' 
AND goal_score=0;

--write a SQL query to count the total number of goalless draws played in the entire tournament. Return number of goalless draws. --
SELECT COUNT(match_no) 
FROM player_in_out
WHERE in_out = 'I' AND play_schedule = 'ET';

--write a SQL query to count the number of substitutes during various stages of the tournament. Sort the result-set in ascending order by play-half, play-schedule and number of substitute happened. Return play-half, play-schedule, number of substitute happened--
SELECT play_half, play_schedule, COUNT(*) SUBS_MADE
FROM player_in_out
WHERE in_out = 'I'
GROUP by play_half, play_schedule
ORDER BY play_half, play_schedule, COUNT(*) DESC;

--write a SQL query to count the number of shots taken in penalty shootouts matches. Number of shots as "Number of Penalty Kicks"--
SELECT COUNT(kick_no)
FROM penalty_shootout

--write a SQL query to count the number of shots that were scored in penalty shootouts matches. Return number of shots scored goal as "Goal Scored by Penalty Kicks"--
SELECT COUNT(score_goal)
FROM penalty_shootout
WHERE score_goal = 'Y';

--write a SQL query to count the number of shots missed or saved in penalty shootout matches. Return number of shots missed as "Goal missed or saved by Penalty Kicks". --
SELECT COUNT(score_goal)
FROM penalty_shootout
WHERE score_goal = 'N';

--  From the following table, write a SQL query to find the players with shot numbers they took in penalty shootout matches. Return match_no, Team, player_name, jersey_no, score_goal, kick_no.--
SELECT ps.match_no, 
c.country_name as Team, 
pm.player_name, 
pm.jersey_no,
ps.score_goal, 
ps.kick_no
FROM penalty_shootout ps, [Soccer Country] as c, player_mast pm
WHERE ps.team_id = c.country_id
AND pm.player_id = ps.player_id
ORDER BY match_no


--write a SQL query to count the number of bookings in each half of play within the normal play schedule. Return play_half, play_schedule, number of booking happened.--
SELECT play_half,
play_schedule,
COUNT(*) number_of_booking
FROM player_booked
WHERE play_schedule = 'NT'
GROUP BY play_half, play_schedule;

--write a SQL query to count the number of bookings during stoppage time--
SELECT COUNT(*)
FROM player_booked
WHERE play_schedule = 'ST';

--write a SQL query to count the number of bookings during EXTRA time--
SELECT COUNT(*)
FROM player_booked
WHERE play_schedule = 'ET';

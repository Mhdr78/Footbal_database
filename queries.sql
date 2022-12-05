-- 1
SELECT First_name, Middle_name, Last_name
	FROM MATCH, GAMEPLAN, PERSON
	WHERE MATCH.Home_id=GAMEPLAN.Home_id AND
		  MATCH.Away_id=GAMEPLAN.Away_id AND
		  MATCH.Date=GAMEPLAN.Date AND
		  GAMEPLAN.Player_id=PERSON.Person_id;

-- 2
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name, TEAM.Short_name AS Team_name, GAMEPLAN_GOAL.Time
	FROM MATCH, GAMEPLAN_GOAL, TEAM, PERSON
	WHERE MATCH.Home_id=GAMEPLAN_GOAL.Home_id AND
		  MATCH.Away_id=GAMEPLAN_GOAL.Away_id AND
		  MATCH.Date=GAMEPLAN_GOAL.Date AND
		  GAMEPLAN_GOAL.Team_id=Team.Team_id AND
		  GAMEPLAN_GOAL.Player_id=PERSON.Person_id;

-- 3
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name, TEAM.Short_name AS Team_name,
	   GAMEPLAN_CARD.Time, GAMEPLAN_CARD.Is_red
	FROM MATCH, GAMEPLAN_CARD, TEAM, PERSON
	WHERE MATCH.Home_id=GAMEPLAN_CARD.Home_id AND
		  MATCH.Away_id=GAMEPLAN_CARD.Away_id AND
		  MATCH.Date=GAMEPLAN_CARD.Date AND
		  GAMEPLAN_CARD.Team_id=Team.Team_id AND
		  GAMEPLAN_CARD.Player_id=PERSON.Person_id;

-- 4
SELECT *
	FROM (SELECT PERSON.First_name AS Out_first_name, PERSON.Last_name AS Out_last_name,
	   MATCH.Home_id, MATCH.Away_id, MATCH.Date, TEAM.Short_name AS Team_name
	FROM MATCH, SUBSTITUTE, PERSON, TEAM
	WHERE MATCH.Home_id=SUBSTITUTE.Home_id AND
		  MATCH.Away_id=SUBSTITUTE.Away_id AND
		  MATCH.Date=SUBSTITUTE.Date AND
		  SUBSTITUTE.Out_id=PERSON.Person_id) AS PLAYER_OUT
		  NATURAL JOIN
		  (SELECT PERSON.First_name AS In_first_name, PERSON.Last_name AS In_last_name,
	   MATCH.Home_id, MATCH.Away_id, MATCH.Date, TEAM.Short_name AS Team_name
	FROM MATCH, SUBSTITUTE, PERSON, TEAM
	WHERE MATCH.Home_id=SUBSTITUTE.Home_id AND
		  MATCH.Away_id=SUBSTITUTE.Away_id AND
		  MATCH.Date=SUBSTITUTE.Date AND
		  SUBSTITUTE.In_id=PERSON.Person_id) AS PLAYER_IN;

-- 6
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name,
	PRE_TEAM.Full_name AS Previous_team_name, DEST_TEAM.Start_date, DEST_TEAM.Duration, DEST_TEAM.Salary
	FROM
		(SELECT *
		FROM CONTRACT, TEAM
		WHERE CONTRACT.Start_date+CONTRACT.Duration BETWEEN '2018-01-01' AND '2020-01-01' AND
			  TEAM.Full_name='x' AND
			  TEAM.Team_id=CONTRACT.Destination_team_id AND
			  CONTRACT.Is_player=TRUE) AS DEST_TEAM, TEAM AS PRE_TEAM, PERSON
			  WHERE DEST_TEAM.Previous_team_id=PRE_TEAM.Team_id AND
			  		DEST_TEAM.Team_member_id=PERSON.Person_id;

-- 7
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name,
	PRE_TEAM.Full_name AS Previous_team_name, 
	DEST_TEAM.Full_name AS Destination_team_name,
	DEST_TEAM.Start_date, DEST_TEAM.Duration, DEST_TEAM.Salary
	FROM
		(SELECT *
		FROM CONTRACT, TEAM
		WHERE CONTRACT.Start_date+CONTRACT.Duration BETWEEN '2018-01-01' AND '2020-01-01' AND
			  TEAM.Team_id=CONTRACT.Destination_team_id AND
			  CONTRACT.Is_player=TRUE) AS DEST_TEAM, TEAM AS PRE_TEAM, PERSON
			  WHERE (DEST_TEAM.Previous_team_id=PRE_TEAM.Team_id OR DEST_TEAM.Previous_team_id=NULL) AND
			  		DEST_TEAM.Team_member_id=PERSON.Person_id;

-- 8
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name,
	PRE_TEAM.Full_name AS Previous_team_name, 
	DEST_TEAM.Full_name AS Destination_team_name,
	DEST_TEAM.Start_date, DEST_TEAM.Duration, DEST_TEAM.Salary
	FROM
		(SELECT *
		FROM CONTRACT, TEAM
		WHERE CONTRACT.Start_date+CONTRACT.Duration BETWEEN '2018-01-01' AND '2020-01-01' AND
			  TEAM.Team_id=CONTRACT.Destination_team_id AND
			  CONTRACT.Is_player=FALSE) AS DEST_TEAM, TEAM AS PRE_TEAM, PERSON
	WHERE (DEST_TEAM.Previous_team_id=PRE_TEAM.Team_id OR DEST_TEAM.Previous_team_id=NULL) AND
		DEST_TEAM.Team_member_id=PERSON.Person_id;

-- 9 
SELECT TEAM.Team_id, SUM(CONTRACT.Salary) AS Total_cost
	FROM TEAM, CONTRACT
	WHERE CURRENT_DATE BETWEEN CONTRACT.Start_date AND CONTRACT.Start_date+CONTRACT.Duration AND
		  TEAM.Team_id=CONTRACT.Destination_team_id AND
		  CONTRACT.Is_player=TRUE
	GROUP BY TEAM.Team_id;

-- 10
SELECT TEAM.Full_name, SUM(CONTRACT.Salary) AS Total_cost
	FROM TEAM, CONTRACT
	WHERE CURRENT_DATE BETWEEN CONTRACT.Start_date AND CONTRACT.Start_date+CONTRACT.Duration AND
		  TEAM.Team_id=CONTRACT.Destination_team_id AND
		  CONTRACT.Is_player=FALSE
	GROUP BY TEAM.Team_id;

-- 14
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name, STAFF.Role, PRE_TEAM.Full_name AS Previous_team_name,
		CONTRACT.Start_date, CONTRACT.Duration, CONTRACT.Salary
	FROM TEAM AS PRE_TEAM, TEAM AS DEST_TEAM, CONTRACT, STAFF, PERSON
	WHERE DEST_TEAM.Team_id=CONTRACT.Destination_team_id AND
		  (PRE_TEAM.Team_id=CONTRACT.Previous_team_id OR CONTRACT.Previous_team_id=NULL) AND
		  CONTRACT.Team_member_id=STAFF.Staff_id AND
		  STAFF.Role!='Head coach' AND
		  STAFF.Staff_id=PERSON.Person_id AND
		  DEST_TEAM.Full_name='x' AND
		  CURRENT_DATE BETWEEN CONTRACT.Start_date AND CONTRACT.Start_date+CONTRACT.Duration AND
		  CONTRACT.Is_player=FALSE;

-- 15
SELECT PERSON.First_name, PERSON.Middle_name, PERSON.Last_name, STAFF.Role, PRE_TEAM.Full_name AS Previous_team_name,
		CONTRACT.Start_date, CONTRACT.Duration, CONTRACT.Salary
	FROM TEAM AS PRE_TEAM, TEAM AS DEST_TEAM, CONTRACT, STAFF, PERSON
	WHERE DEST_TEAM.Team_id=CONTRACT.Destination_team_id AND
		  (PRE_TEAM.Team_id=CONTRACT.Previous_team_id OR CONTRACT.Previous_team_id=NULL) AND
		  CONTRACT.Team_member_id=STAFF.Staff_id AND
		  STAFF.Role='Head coach' AND
		  STAFF.Staff_id=PERSON.Person_id AND
		  DEST_TEAM.Full_name='x' AND
		  CURRENT_DATE BETWEEN CONTRACT.Start_date AND CONTRACT.Start_date+CONTRACT.Duration AND
		  CONTRACT.Is_player=FALSE;

-- 16
SELECT TEAM.Full_name AS Team_name, PLAYER_CONTRACT.Start_date, PLAYER_CONTRACT.End_date, PLAYER_CONTRACT.Salary,
		PLAYER_MATCH.No_match, PLAYER_GOAL.No_goal, PLAYER_YEL_CARD.No_yellow_card, PLAYER_RED_CARD.No_red_card,
		PLAYER_AVG_SCORE.Average_score, PLAYER_SUB_OUT.No_substituted_out
	FROM
		(SELECT PERSON.Person_id AS Player_id, TEAM.Team_id,
				CONTRACT.Start_date, CONTRACT.Start_date+CONTRACT.Duration AS End_date, CONTRACT.Salary 
			FROM PERSON, CONTRACT, TEAM
			WHERE PERSON.First_name='x' AND PERSON.Middle_name='y' AND PERSON.Last_name='z' AND
				  PERSON.Person_id=CONTRACT.Team_member_id AND
				  CONTRACT.Destination_team_id=TEAM.Team_id) AS PLAYER_CONTRACT
	NATURAL JOIN
		(SELECT GAMEPLAN.Player_id, GAMEPLAN.Team_id, COUNT(GAMEPLAN.Date) AS No_match
			FROM GAMEPLAN
			WHERE GAMEPLAN.Position!='Bench'
			GROUP BY GAMEPLAN.Player_id, GAMEPLAN.Team_id) AS PLAYER_MATCH
	NATURAL JOIN
		(SELECT GAMEPLAN_GOAL.Player_id, GAMEPLAN_GOAL.Team_id, COUNT(GAMEPLAN_GOAL.Time) AS No_goal
			FROM GAMEPLAN_GOAL
			GROUP BY GAMEPLAN_GOAL.Player_id, GAMEPLAN_GOAL.Team_id) AS PLAYER_GOAL
	NATURAL JOIN
		(SELECT GAMEPLAN_CARD.Player_id, GAMEPLAN_CARD.Team_id, COUNT(GAMEPLAN_CARD.Time) AS No_yellow_card
			FROM GAMEPLAN_CARD
			WHERE GAMEPLAN_CARD.Is_red=FALSE
			GROUP BY GAMEPLAN_CARD.Player_id, GAMEPLAN_CARD.Team_id) AS PLAYER_YEL_CARD
	NATURAL JOIN
		(SELECT GAMEPLAN_CARD.Player_id, GAMEPLAN_CARD.Team_id, COUNT(GAMEPLAN_CARD.Time) AS No_red_card
			FROM GAMEPLAN_CARD
			WHERE GAMEPLAN_CARD.Is_red=TRUE
			GROUP BY GAMEPLAN_CARD.Player_id, GAMEPLAN_CARD.Team_id) AS PLAYER_RED_CARD
	NATURAL JOIN
		(SELECT SUPERVISOR_SCORING_PLAYER.Player_id, SUPERVISOR_SCORING_PLAYER.Team_id,
		 		AVG(SUPERVISOR_SCORING_PLAYER.Score) AS Average_score
			FROM SUPERVISOR_SCORING_PLAYER
			GROUP BY SUPERVISOR_SCORING_PLAYER.Player_id, SUPERVISOR_SCORING_PLAYER.Team_id) AS PLAYER_AVG_SCORE
	NATURAL JOIN
		(SELECT SUBSTITUTE.Out_id AS Player_id, SUBSTITUTE.Team_id, COUNT(SUBSTITUTE.Date) AS No_substituted_out
			FROM SUBSTITUTE
			GROUP BY SUBSTITUTE.Out_id, SUBSTITUTE.Team_id) AS PLAYER_SUB_OUT, TEAM
	WHERE PLAYER_CONTRACT.Team_id=TEAM.Team_id;

-- 17 (INCOMPLETE)
-- SELECT *
-- 	FROM
-- 		(SELECT * 
-- 			FROM
-- 				(SELECT PERSON.Person_id AS Player_id, LEAGUE_INCLUDE_TEAM.league_id, SUM(CONTRACT.Duration) AS Total_Duration
-- 					FROM PERSON, CONTRACT, TEAM, LEAGUE_INCLUDE_TEAM
-- 					WHERE PERSON.First_name='X' AND PERSON.Middle_name='Y' AND PERSON.Last_name='Z' AND
-- 							PERSON.Person_id=CONTRACT.Team_member_id AND
-- 							CONTRACT.Destination_team_id=TEAM.Team_id AND
-- 							CONTRACT.Destination_team_id=LEAGUE_INCLUDE_TEAM.Team_id AND
-- 							CONTRACT.Start_date>=LEAGUE_INCLUDE_TEAM.Start_date AND 
-- 							CONTRACT.Start_date+CONTRACT.Duration<=LEAGUE_INCLUDE_TEAM.End_date
-- 					GROUP BY PERSON.Person_id, LEAGUE_INCLUDE_TEAM.league_id) AS LEAGUE_DURATION
-- 			NATURAL JOIN GAMEPLAN NATURAL JOIN MATCH NATURAL JOIN) AS TEMP
-- 			NATURAL JOIN
-- 			(SELECT )
 		
-- 12
SELECT COUNT(HOME.Date)+COUNT(AWAY.Date)
	FROM TEAM, CONTRACT, STAFF, MATCH AS HOME, MATCH AS AWAY
	WHERE TEAM.Full_name='X' AND
			TEAM.Team_id=CONTRACT.Destination_team_id AND
			CONTRACT.Is_player=FALSE AND
			CONTRACT.Team_member_id=STAFF.Staff_id AND
			STAFF.Role='Head coach' AND
			(TEAM.Team_id=HOME.Home_id OR TEAM.Team_id=AWAY.Away_id)
	GROUP BY CONTRACT.Team_member_id, CONTRACT.Start_date;
	

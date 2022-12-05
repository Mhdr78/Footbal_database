CREATE TABLE STADIUM (
	Stadium_id 			NUMERICAL_ID,
	Name 				NAME NOT NULL,
	Capacity 			INTEGER NOT NULL,
	First_floor_price 	PRICE,
	Second_floor_price 	PRICE,
	VIP_seat_price 		PRICE,
	State 				VARCHAR(32) NOT NULL,
	City 				VARCHAR(32) NOT NULL,
	Roof				BOOLEAN DEFAULT FALSE,
	VAR					BOOLEAN DEFAULT FALSE,
	CONSTRAINT STADPK
		PRIMARY KEY (Stadium_id),
	CHECK (Capacity > 0)
);

CREATE TABLE PERSON (
	Person_id 		NUMERICAL_ID,
	First_name 		NAME NOT NULL,
	Middle_name		NAME,
	Last_name 		NAME NOT NULL,
	Birth_date 		DATE NOT NULL,
	Nationality 	VARCHAR(32),
	Is_referee		BOOLEAN NOT NULL,
	Is_supervisor	BOOLEAN NOT NULL,
	Is_team_member	BOOLEAN NOT NULL,
	CONSTRAINT PERPK
		PRIMARY KEY (person_id),
	CHECK (((Is_referee AND Is_supervisor) = FALSE) AND
		  ((Is_referee AND Is_team_member) = FALSE) AND
		  ((Is_supervisor AND Is_team_member) = FALSE) AND
		  ((Is_referee OR Is_supervisor OR Is_team_member) = True))
);

CREATE TABLE PLAYER (
	Player_id 		NUMERICAL_ID,
	Speed_rate 		smallint,
	Height 			smallint,
	Weight 			smallint,
	CONSTRAINT PLAPK
		PRIMARY KEY (Player_id),
	CONSTRAINT PERPLAFK
		FOREIGN KEY (Player_id) REFERENCES PERSON(Person_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CHECK (Speed_rate > 0 AND Height > 0 AND Weight > 0)
);

CREATE TABLE PLAYER_POSITION (
	Player_id		NUMERICAL_ID,
	Position		VARCHAR(24) NOT NULL,
	CONSTRAINT PPPK
		PRIMARY KEY (Player_id, Position),
	CONSTRAINT PLAPPFK
		FOREIGN KEY (Player_id) REFERENCES PLAYER(Player_id)
			ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE STAFF (
	Staff_id 		NUMERICAL_ID,
	Role 			VARCHAR(16) NOT NULL,
	CONSTRAINT STAFPK
		PRIMARY KEY (Staff_id),
	CONSTRAINT PERSTAFK
		FOREIGN KEY (Staff_id) REFERENCES PERSON(Person_id)
			ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE TEAM (
	Team_id 			NUMERICAL_ID,
	Short_name 			VARCHAR(4),
	Full_name 			NAME NOT NULL,
	Foundation_date 	DATE NOT NULL,
	CONSTRAINT TEAPK
		PRIMARY KEY (Team_id)
);

CREATE TABLE CONTRACT (
	Team_member_id			NUMERICAL_ID,
	Previous_team_id		NUMERICAL_ID,
	Destination_team_id		NUMERICAL_ID,
	Start_date				DATE NOT NULL,
	Duration				SMALLINT NOT NULL,
	Is_player 				BOOLEAN NOT NULL,
	Salary					INTEGER,
	CONSTRAINT CONPK
		PRIMARY KEY (Team_member_id, Destination_team_id, Start_date),
	CONSTRAINT PERCONFK
		FOREIGN KEY (Team_member_id) REFERENCES PERSON(Person_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT TEACONPFK
		FOREIGN KEY (Previous_team_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT TEACONDFK
		FOREIGN KEY (Destination_team_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE LEAGUE (
	League_id 			NUMERICAL_ID,
	Name 				NAME NOT NULL,
	Type 				VARCHAR(16) NOT NULL,
	Foundation_date		DATE,
	CONSTRAINT LEAPK
		PRIMARY KEY (League_id)
);

CREATE TABLE MATCH (
	Home_id 			NUMERICAL_ID,
	Away_id 			NUMERICAL_ID,
	Date 				DATE NOT NULL,
 Time				TIMETZ,
	Stadium_id 			NUMERICAL_ID,
	League_id 			NUMERICAL_ID,
	No_first_floor 		INTEGER,
	No_second_floor 	INTEGER,
	No_vip_seat 		SMALLINT,
	CONSTRAINT PLAYPK
	PRIMARY KEY (Home_id, Away_id, Date),
	CONSTRAINT TEAPLAHFK
		FOREIGN KEY (Home_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT TEAPLAAFK
		FOREIGN KEY (Away_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT STAPLAFK
		FOREIGN KEY (Stadium_id) REFERENCES STADIUM(Stadium_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT LEAPLAFK
		FOREIGN KEY (League_id) REFERENCES LEAGUE(League_id)
			ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE LEAGUE_INCLUDE_TEAM (
	League_id		NUMERICAL_ID,
	Team_id			NUMERICAL_ID,
	Start_date		DATE NOT NULL,
	End_date		DATE NOT NULL,
	PRIMARY KEY (League_id, Team_id, Start_date),
	CONSTRAINT LEALITFK
		FOREIGN KEY (League_id) REFERENCES LEAGUE(League_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT TEALITFK
		FOREIGN KEY (Team_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CHECK (Start_date < End_date)
);

CREATE TABLE REFEREE_JUDGE_MATCH (
	Referee_id		NUMERICAL_ID,
	Home_id			NUMERICAL_ID,
	Away_id			NUMERICAL_ID,
	Date			Date NOT NULL,
	CONSTRAINT RJMPK
		PRIMARY KEY (Referee_id, Home_id, Away_id, Date),
	CONSTRAINT REFRJMFK
		FOREIGN KEY (Referee_id) REFERENCES PERSON(Person_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT MATRJMFK
		FOREIGN KEY (Home_id, Away_id, Date) REFERENCES MATCH(Home_id, Away_id, Date)
			ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE GAMEPLAN (
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Player_id 		NUMERICAL_ID,
	Position 		VARCHAR(4),
	Referee_id 		NUMERICAL_ID,
	RHome_id		NUMERICAL_ID,
	RAway_id		NUMERICAL_ID,
	RDate			Date NOT NULL,
	CONSTRAINT GAMPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Player_id),
	CONSTRAINT PLAYGAMFK
		FOREIGN KEY (Home_id, Away_id, Date) REFERENCES MATCH(Home_id, Away_id, Date)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT TEAGAMFK
		FOREIGN KEY (Team_id) REFERENCES TEAM(Team_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT PLAGAMFK
		FOREIGN KEY (Player_id) REFERENCES PLAYER(Player_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT RJMGAMFK
		FOREIGN KEY (Referee_id, RHome_id, RAway_id, RDate)
			REFERENCES REFEREE_JUDGE_MATCH(Referee_id, Home_id, Away_id, Date)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE GAMEPLAN_GOAL (
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Player_id 		NUMERICAL_ID,
	Time			SMALLINT NOT NULL,
	CONSTRAINT GGPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Player_id, Time),
	CONSTRAINT GAMGGFK
		FOREIGN KEY (Home_id, Away_id, Date, Team_id, Player_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE GAMEPLAN_CARD (
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Player_id 		NUMERICAL_ID,
	Time			SMALLINT NOT NULL,
 Is_red			BOOLEAN NOT NULL,
	CONSTRAINT GCPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Player_id),
	CONSTRAINT GAMGCFK
		FOREIGN KEY (Home_id, Away_id, Date, Team_id, Player_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE GAMEPLAN_INJURED (
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Player_id 		NUMERICAL_ID,
	Time			SMALLINT NOT NULL,
	CONSTRAINT GIPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Player_id),
	CONSTRAINT GAMGIFK
		FOREIGN KEY (Home_id, Away_id, Date, Team_id, Player_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE SUBSTITUTE (
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Out_id 			NUMERICAL_ID,
	BHome_id 		NUMERICAL_ID,
	BAway_id 		NUMERICAL_ID,
	BDate 			DATE NOT NULL,
	BTeam_id 		NUMERICAL_ID,
	In_id 			NUMERICAL_ID,
	Time			SMALLINT NOT NULL,
	CONSTRAINT SUBPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Out_id),
	CONSTRAINT GAMSUBOFK
		FOREIGN KEY (Home_id, Away_id, Date, Team_id, Out_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT GAMSUBIFK
		FOREIGN KEY (BHome_id, BAway_id, BDate, BTeam_id, In_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

CREATE TABLE SUPERVISOR_SCORING_PLAYER (
	Supervisor_id 	NUMERICAL_ID,
	Home_id 		NUMERICAL_ID,
	Away_id 		NUMERICAL_ID,
	Date 			DATE NOT NULL,
	Team_id 		NUMERICAL_ID,
	Player_id 		NUMERICAL_ID,
	Score			SMALLINT,
	CONSTRAINT SSPPK
		PRIMARY KEY (Home_id, Away_id, Date, Team_id, Player_id),
	CONSTRAINT PERSSPFK 
		FOREIGN KEY (Supervisor_id) REFERENCES PERSON(Person_id)
			ON UPDATE CASCADE	ON DELETE CASCADE,
	CONSTRAINT GAMSSPFK
		FOREIGN KEY (Home_id, Away_id, Date, Team_id, Player_id) 
			REFERENCES GAMEPLAN(Home_id, Away_id, Date, Team_id, Player_id)
				ON UPDATE CASCADE	ON DELETE CASCADE
);

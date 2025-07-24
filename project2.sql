
CREATE DATABASE  SportsTournament;
use SportsTournament;
-- Create Teams table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL
);

-- Create Players table
CREATE TABLE Players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR(100),
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Create Matches table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    match_date DATE,
    team1_id INT,
    team2_id INT,
    team1_score INT,
    team2_score INT,
    winner_team_id INT,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_team_id) REFERENCES Teams(team_id)
);

-- Create Stats table
CREATE TABLE Stats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT,
    player_id INT,
    runs_scored INT,
    wickets_taken INT,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);


-- Teams
INSERT INTO Teams (team_name) VALUES ('Tigers'), ('Warriors'), ('Kings');

-- Players
INSERT INTO Players (player_name, team_id) VALUES
('Ravi', 1), ('Aman', 1),
('Sohail', 2), ('Faizan', 2),
('Karan', 3), ('Dev', 3);

-- Matches
INSERT INTO Matches (match_date, team1_id, team2_id, team1_score, team2_score, winner_team_id)
VALUES 
('2025-07-20', 1, 2, 250, 240, 1),
('2025-07-21', 2, 3, 200, 210, 3),
('2025-07-22', 1, 3, 180, 190, 3);

-- Stats
INSERT INTO Stats (match_id, player_id, runs_scored, wickets_taken) VALUES
(1, 1, 70, 1), (1, 2, 50, 0), (1, 3, 40, 2), (1, 4, 60, 1),
(2, 3, 45, 0), (2, 4, 30, 1), (2, 5, 60, 2), (2, 6, 70, 1),
(3, 1, 55, 0), (3, 2, 40, 0), (3, 5, 80, 1), (3, 6, 50, 0);


-- All Match Results
SELECT 
    m.match_id,
    t1.team_name AS Team1,
    t2.team_name AS Team2,
    m.team1_score,
    m.team2_score,
    tw.team_name AS Winner
FROM Matches m
JOIN Teams t1 ON m.team1_id = t1.team_id
JOIN Teams t2 ON m.team2_id = t2.team_id
JOIN Teams tw ON m.winner_team_id = tw.team_id;

-- Total Runs by Each Player
SELECT 
    p.player_name,
    t.team_name,
    SUM(s.runs_scored) AS total_runs,
    SUM(s.wickets_taken) AS total_wickets
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY s.player_id
ORDER BY total_runs DESC;


-- Leaderboard: Top Players by Total Runs
CREATE VIEW PlayerLeaderboard AS
SELECT 
    p.player_name,
    t.team_name,
    SUM(s.runs_scored) AS total_runs,
    SUM(s.wickets_taken) AS total_wickets
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY p.player_id
ORDER BY total_runs DESC;

-- Points Table for Teams
CREATE VIEW TeamPoints AS
SELECT 
    team_name,
    COUNT(*) AS matches_played,
    SUM(CASE WHEN winner_team_id = t.team_id THEN 1 ELSE 0 END) * 2 AS points
FROM Teams t
LEFT JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_id
ORDER BY points DESC;



-- Average Runs and Wickets per Match
WITH PlayerMatchStats AS (
    SELECT 
        player_id,
        COUNT(DISTINCT match_id) AS matches_played,
        SUM(runs_scored) AS total_runs,
        SUM(wickets_taken) AS total_wickets
    FROM Stats
    GROUP BY player_id
)
SELECT 
    p.player_name,
    t.team_name,
    ps.matches_played,
    ROUND(ps.total_runs / ps.matches_played, 2) AS avg_runs,
    ROUND(ps.total_wickets / ps.matches_played, 2) AS avg_wickets
FROM PlayerMatchStats ps
JOIN Players p ON ps.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id;



SELECT * FROM TeamPoints
INTO OUTFILE '/tmp/team_points.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


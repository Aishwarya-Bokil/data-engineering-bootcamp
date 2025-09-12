-- Using grouping sets to aggregate answer all 3 questions:
-- 1. Who scored the most points playing for one team
-- 2. Who scored the most points in one season
-- 3. Which team has won the most games.

CREATE TABLE aggregated_dataset(
	player_name TEXT,
	team_id TEXT,
	season TEXT,
	total_points REAL,
	total_wins INTEGER
)

INSERT INTO aggregated_dataset
SELECT
	-- Coalescing using 'Overall' to avoid seeing nulls in the final aggregaed table
	COALESCE(player_name, '(Overall)') AS player_name,
	COALESCE(team_id, '(Overall)') AS team_id,
	COALESCE(season, '(Overall)') AS season,
	SUM(pts) AS total_points,
	SUM(
		CASE
			WHEN did_win THEN 1 
			ELSE 0 
		END
	) as total_wins
FROM game_player_details
GROUP BY GROUPING SETS(
	(player_name, team_id),
	(player_name, season),
	(team_id)
)
ORDER BY total_points DESC, total_wins DESC;
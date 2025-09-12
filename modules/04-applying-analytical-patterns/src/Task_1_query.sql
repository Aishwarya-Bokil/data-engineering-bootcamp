-- Query to create the state tracking table

CREATE TABLE players_state_tracking(
	player_name TEXT,
	first_active_season INTEGER,
	last_active_season INTEGER,
	yearly_active_state TEXT,
	seasons_active INTEGER[],
	season INTEGER,
	PRIMARY KEY (player_name, season)
)

INSERT INTO players_state_tracking
-- Getting previous season data from tracking table
WITH last_season AS(
	SELECT
		*
	FROM players_state_tracking
	WHERE season = 2021
),
-- From the player_seasons data, picking data for the current season
this_season AS(
	SELECT
		player_name,
		season as this_season,
		COUNT(1)
	FROM player_seasons
	WHERE season = 2022
	and player_name IS NOT NULL
	GROUP BY player_name, season
)
SELECT
	COALESCE(t.player_name, l.player_name) AS player_name,
	-- If the player has value for first_active_season for the prev season, then this value remains, else current new value is treated as the first_Active_Season
	COALESCE(l.first_active_season, t.this_season) AS first_active_season,
	-- If the player has value for the current season, this becomes the last_active_season, otherwise we pick value from the last season
	COALESCE(t.this_season, l.last_active_season) AS last_active_season,
	CASE
		-- If player never existed in the previous season data, then new
		WHEN l.player_name IS NULL and t.player_name IS NOT NULL THEN 'New'
		-- If the player's last active season is one less than the current season, that means he remained active 
		WHEN l.last_active_season = t.this_season - 1 THEN 'Continued Playing'
		-- If the player's last active season from last season's data is more than one year ago the current season value, that means he returned from retirement
		WHEN l.last_active_season < t.this_season - 1 THEN 'Returned from Retirement'
		-- If the player has no data for the current season and the player's last active season is equal to the season partition in the previous season data, that means the player has retired
		WHEN t.this_season IS NULL AND l.last_active_season = l.season THEN 'Retired'
		-- Otherwise the player stays retired
		ELSE 'Stayed Retired'
	END AS yearly_active_state,
	-- Using the week 2 concept to build active seasons array
	COALESCE(l.seasons_active, ARRAY[]::INTEGER[]) ||
	CASE 
		WHEN t.player_name IS NOT NULL THEN ARRAY[t.this_season]
		ELSE ARRAY[]::INTEGER[]
	END AS seasons_active,
	COALESCE(t.this_season, l.season+1) as season
FROM this_season t
FULL OUTER JOIN last_season l
ON t.player_name = l.player_name;
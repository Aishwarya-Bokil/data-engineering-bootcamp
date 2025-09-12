SELECT
	player_name,
	team_id,
	total_points
FROM aggregated_dataset
WHERE player_name != '(Overall)' AND team_id != '(Overall)' AND total_points IS NOT NULL
ORDER BY total_points DESC
LIMIT 1;
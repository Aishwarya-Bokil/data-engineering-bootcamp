SELECT
	player_name,
	season,
	total_points
FROM aggregated_dataset
WHERE player_name != '(Overall)' AND season != '(Overall)' AND total_points IS NOT NULL
ORDER BY total_points DESC
LIMIT 1;
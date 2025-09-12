SELECT
	team_id,
	total_wins
FROM aggregated_dataset
WHERE player_name = '(Overall)' AND season = '(Overall)' AND team_id != '(Overall)' AND total_wins IS NOT NULL
ORDER BY total_wins DESC
LIMIT 1;
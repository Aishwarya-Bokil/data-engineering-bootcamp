-- For question: What is the most games a team has won in a 90 game stretch? we need to reduce the cardinality of the data to one row per game per team
WITH team_game_results AS(
	SELECT DISTINCT
		game_id,
		team_id,
		did_win,
		game_date_est
	FROM game_player_details
),
windowed_wins AS(
	SELECT
		team_id,
		game_date_est,
		-- Counting the number of games to filter out cases where we have less than 90 games
		COUNT(*) OVER (
			PARTITION BY team_id
			ORDER BY game_date_est
			ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
		)AS number_of_games,
		-- To get a 90 game window and then sum over this window, we use the sum() window function. We use the rows between .. parameter to restrict the size of the window.
		SUM(
			CASE
				WHEN did_win THEN 1 
				ELSE 0
			END
		) OVER (
			PARTITION BY team_id
			ORDER BY game_date_est
			ROWS BETWEEN 89 PRECEDING AND CURRENT ROW
		)AS last_90_wins
	FROM team_game_results
)
-- We select the max last_90_wins to get most games each team has won
SELECT
	team_id,
	MAX(last_90_wins) AS max_last_90_wins
FROM windowed_wins
WHERE number_of_games>=90
GROUP BY team_id
ORDER BY max_last_90_wins DESC;
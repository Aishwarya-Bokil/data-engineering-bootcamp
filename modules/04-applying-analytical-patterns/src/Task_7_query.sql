-- We first create a simple filter CTE and flag games for when lebron scores over 10 points
WITH scoring_over_10 AS(
	SELECT
		*,
		CASE 
			WHEN pts>10 THEN 1
			ELSE 0
		END as scored_over_10
	FROM game_player_details
	WHERE player_name ILIKE 'Lebron James'
	AND pts IS NOT NULL
),
streaks AS(
	SELECT
		*,
		-- This is a trick to create a streak identifier. The row number remains continuous while the sum() reduces each time there is a break. subtracting these 2, hence, will give us the streak_ids by locating the breaks
		ROW_NUMBER() OVER (ORDER BY game_date_est) - SUM(scored_over_10) OVER (ORDER BY game_date_est) AS streak_id
	FROM scoring_over_10
),
-- We group by streak ids to identify the lengths of each streak.
streak_length AS(
	SELECT
		streak_id,
		COUNT(*) AS streak_length
	FROM streaks
	WHERE scored_over_10 = 1
	GROUP BY streak_id
)
-- We pick the longest streak to get the number of games in a row leBron james scored over 10 points in
SELECT
	COALESCE(MAX(streak_length),0) AS longest_streak
FROM streak_length;
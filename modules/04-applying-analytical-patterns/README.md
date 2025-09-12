# Applying Analytical Patterns

## Problem
For this, use the videos from Dimnesional data modeling module to build the following tables:
- 'players' table: Contains one row for every year. For each year, it contains the stats from the current and all the previous years the player was active for.
- 'players_scd' table: Contains one row for every time a change in 'is_active' or 'scoring_class' takes place. It also records the start_season and end_season.
- 'player_seasons': The original table. Contains a row for every player and every season.

The homework involves building the following queries:
1. Query to perform state change tracking for players. This query would build the state - New, Retired, Continued Playing, Returned From Retirement, Stayed Retired. 
2. Query that uses 'Grouping Sets' to aggregate 'game_details' data along the following dimensions:
- player and team
- player and season
- team
3. Use the aggregated dataset and write a query to see who scored the most points playing for one team 
4. Use the aggregated dataset and write a query to see who scored most points in one season.
5. Use the aggregated dataset and write a query to check which team has won the most games.
6. Using window functions to write a query to check which is the most games a team has won in a 90 game stretch
7. Using window functions to write a query to check how many games in a row did LeBron James score over 10 points a game.
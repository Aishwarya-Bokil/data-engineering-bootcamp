# Dimensional Data Modeling

## Problem
We are given a 'actor_films' dataset, which contains a record for each actor and a film.
This table contains the following columns:
- actor
- actorid
- film
- year
- votes
- rating
- filmid

1. First Task: Create a new 'actors' table containing the following:
- 'films', which is an array of struct.
- 'quality_class' to demonstrate the actor's performance quality.
- 'is_active', which indicates whether or not an actor was active that year.
2. Second Task: Building a cumulative query that populates this table.
3. Third Task: Create a new 'actors_history_scd' table:
- Should implement SCD type 2 dimensions
- Tracks 'quality_class' and 'is_active' status for each actor
4. Backfill query that populates this 'actors_history_scd' table.
5. Incremental query that populates 'actors_history_scd' table by combining previous year's data with fresh incoming data from 'actors' table.

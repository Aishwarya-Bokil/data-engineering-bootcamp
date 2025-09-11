WITH years AS (
    SELECT 
    GENERATE_SERIES(min(year)-1, max(year)) AS film_year 
	from actor_films
), 
a AS (
    SELECT
		actorid,
        min(actor) as actor,
        MIN(year) AS first_year
    FROM actor_films
    GROUP BY actorid
), 
actors_and_years AS (
    SELECT *
    FROM a
    JOIN years y
        ON a.first_year <= y.film_year
),
windowed as (
	select aay.actor, 
	aay.actorid,
	aay.film_year,
	ARRAY_REMOVE(
		ARRAY_AGG(
			CASE 
				WHEN af.year IS NOT NULL
				THEN ROW(
					af.film,
					af.votes,
					af.rating,
					af.filmid
				)::films
			END
		) OVER (PARTITION BY aay.actorid ORDER BY COALESCE(aay.film_year, af.year)),NULL) 
		AS films_in_year,
	AVG(rating) OVER(PARTITION BY aay.actorid, aay.film_year ORDER BY COALESCE(aay.film_year, af.year)) AS rating,
	case 
		when af.year is not null then true
		else false
	end
	as is_active
	from 
	actors_and_years aay left join
	actor_films as af
	on aay.actor = af.actor
	and aay.film_year = af.year
)
,
grouped as (
	SELECT
            MIN(actor) AS actor,
            actorid,
            film_year,
			min(rating) as rating,
			bool_or(is_active) as is_active,
            MIN(films_in_year) as films
	FROM windowed GROUP BY actorid, film_year
),
grouped_for_null as (
	select 
		g.actor,
		g.actorid,
		g.film_year,
		g.rating,
		count(g.rating) over (order by g.actor,g.film_year) as rating_cnt,
		case
			when g.rating>8 then 'star'
			when g.rating >7 and g.rating<=8 THEN 'good'
			when g.rating >6 and g.rating<=7 THEN 'average'
			when g.rating<=6 then 'bad'
		end::quality_class as quality_class,
		g.is_active,
		g.films
	from grouped g
)
insert into actors(
	select 
		gn.actor,
		gn.actorid,
		gn.films,
		max(gn.quality_class) over (partition by gn.rating_cnt) as quality_class,
		gn.is_active,
		gn.film_year as current_year
	from grouped_for_null gn
	order by gn.actor,gn.film_year
);
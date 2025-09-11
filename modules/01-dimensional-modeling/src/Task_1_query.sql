create type films as (
	film text,
	votes integer,
	rating real,
	filmid text
);

CREATE TYPE quality_class AS
     ENUM ('bad', 'average', 'good', 'star');

create table actors (
	actor text,
	actorid text,
	films films[],
	quality_class quality_class,
	is_active boolean,
	current_year integer,
	primary key(actorid, current_year)
)
create table hosts_cumulated(
	host TEXT,
	host_activity_datelist DATE[],
	curr_date DATE,
	primary key (host, curr_date)
)
create table user_devices_cumulated(
	user_id NUMERIC,
	browser_type TEXT,
	device_activity_datelist DATE[],
	curr_date DATE,
	PRIMARY KEY (user_id,browser_type,curr_date)
)
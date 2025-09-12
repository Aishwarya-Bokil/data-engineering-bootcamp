create table joined_table(
	event_date DATE,
	user_id NUMERIC,
	device_id NUMERIC,
	browser_type TEXT
)


insert into joined_table
	with deduped_devices as(
		select
			device_id,
			browser_type,
			row_number() over (partition by device_id) as device_row_num
		from devices
	),
	deduped_events as(
		select
			user_id,
			device_id,
			event_time,
			row_number() over (partition by user_id, device_id, event_time::date order by event_time) as event_row_num
		from events
		where user_id is not null
	),
	to_insert as(
		select
			e.event_time::date,
			e.user_id,
			e.device_id,
			d.browser_type
		from deduped_devices d
		join deduped_events e
		on d.device_id = e.device_id
		where d.device_row_num = 1
		and e.event_row_num = 1
	)

select * from to_insert
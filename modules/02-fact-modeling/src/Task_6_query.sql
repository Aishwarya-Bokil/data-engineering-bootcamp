with recursive date_list as(
	select 
		min(event_time::DATE) as start_date,
		max(event_time::DATE) as end_date
	from events
),
days as(
	select
		start_date as event_date 
	from date_list
	union all
	select
		(event_date + interval '1 day')::DATE
	from days, date_list
	where (event_date + interval '1 day')::DATE <= end_date
),
today_events as(
	select
		event_time::DATE as event_date,
		host,
		count(*) as num_host_events
	from events
	group by host, event_time::DATE 
),
hosts_activity as(
	select
		h.host,
		CASE
			when e.event_date is not null then array[e.event_date]
			else array[]::date[]
		end as host_activity_datelist,
		d.start_date as curr_date
	from (
		select
			distinct host
		from events
	) h
	cross join date_list d
	left join today_events e
	on h.host = e.host
	and e.event_date = d.start_date

	union all

	select
		y.host,
		y.host_activity_datelist || 
			case
				when t.host is not null then array[d.event_date] else array[]::date[]
			end
		as host_activity_datelist,
		d.event_date as curr_date
	from hosts_activity y
	join days d on d.event_date = y.curr_date + interval '1 day'
	left join today_events t
	on t.host = y.host
	and t.event_date = d.event_date
)
insert into hosts_cumulated (host, host_activity_datelist, curr_date)
select
	host,
	host_activity_datelist,
	curr_date
from hosts_activity;
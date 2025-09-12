WITH starter AS (
    SELECT
        udc.device_activity_datelist @> ARRAY[d.valid_date] AS is_active,
        '2023-02-01'::DATE - d.valid_date as days_since,
		udc.user_id,
		udc.browser_type
    FROM user_devices_cumulated udc
    CROSS JOIN (
        SELECT generate_series('2022-12-31', '2023-01-31', INTERVAL '1 day')::DATE AS valid_date
    ) d
    WHERE udc.curr_date = '2023-01-31'
),
bits AS(
	select
		user_id,
		sum(
			case 
				when is_active then pow(2, 32-days_since)
				else 0
			end
		)::bigint::bit(32) as datelist_int
	from starter
	group by user_id,browser_type
)

select * from bits;
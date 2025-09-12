WITH RECURSIVE date_list AS (
    SELECT MIN(event_date)::DATE AS start_date, MAX(event_date)::DATE AS end_date
    FROM joined_table
),
days AS (
    SELECT start_date AS event_date FROM date_list
    UNION ALL
    SELECT (event_date + INTERVAL '1 day')::DATE
    FROM days, date_list
    WHERE (event_date + INTERVAL '1 day')::DATE <= date_list.end_date
),
today_events AS (
    SELECT
        event_date::DATE,
        user_id,
        browser_type,
        COUNT(*) AS num_events
    FROM joined_table
    GROUP BY event_date, user_id, browser_type
),
user_devices_cumulative AS (
    SELECT
        u.user_id,
        u.browser_type,
        CASE 
            WHEN e.event_date IS NOT NULL THEN ARRAY[e.event_date]
            ELSE ARRAY[]::DATE[]
        END AS device_activity_datelist,
        d.start_date AS curr_date
    FROM (
        SELECT DISTINCT user_id, browser_type FROM joined_table
    ) u
    CROSS JOIN date_list d
    LEFT JOIN today_events e
        ON u.user_id = e.user_id
        AND u.browser_type = e.browser_type
        AND e.event_date = d.start_date

    UNION ALL

    SELECT
        y.user_id,
        y.browser_type,
        y.device_activity_datelist ||
            CASE WHEN t.user_id IS NOT NULL THEN ARRAY[d.event_date] ELSE ARRAY[]::DATE[] END
            AS device_activity_datelist,
        d.event_date AS curr_date
    FROM user_devices_cumulative y
    JOIN days d ON d.event_date = y.curr_date + INTERVAL '1 day' 
    LEFT JOIN today_events t
        ON t.user_id = y.user_id
        AND t.browser_type = y.browser_type
        AND t.event_date = d.event_date
)
INSERT INTO user_devices_cumulated (user_id, browser_type, device_activity_datelist, curr_date)
SELECT user_id, browser_type, device_activity_datelist, curr_date
FROM user_devices_cumulative;
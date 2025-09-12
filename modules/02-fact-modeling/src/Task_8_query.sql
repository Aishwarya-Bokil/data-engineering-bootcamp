WITH RECURSIVE daily_stats AS (
    SELECT
        host,
        event_time::DATE AS event_date,
        COUNT(*) AS num_hits,
        COUNT(DISTINCT user_id) AS num_unique_visitors
    FROM events
    WHERE event_time::DATE BETWEEN '2023-01-01' AND '2023-01-31'
      AND host IS NOT NULL
    GROUP BY host, event_time::DATE
),
date_host_combos AS (
    SELECT
        h.host,
        d::DATE AS event_date
    FROM (SELECT DISTINCT host FROM daily_stats) h
    CROSS JOIN generate_series('2023-01-01'::DATE, '2023-01-31'::DATE, INTERVAL '1 day') d
),
expanded_stats AS (
    SELECT
        dh.host,
        dh.event_date,
        COALESCE(ds.num_hits, 0) AS num_hits,
        COALESCE(ds.num_unique_visitors, 0) AS num_unique_visitors
    FROM date_host_combos dh
    LEFT JOIN daily_stats ds
        ON dh.host = ds.host AND dh.event_date = ds.event_date
),
daily_accumulate AS (
    SELECT
        host,
        event_date,
        ARRAY[num_hits] AS hit_array,
        ARRAY[num_unique_visitors] AS unique_visitors_array
    FROM expanded_stats
    WHERE event_date = '2023-01-01'
    UNION ALL
    SELECT
        s.host,
        s.event_date,
        d.hit_array || s.num_hits,
        d.unique_visitors_array || s.num_unique_visitors
    FROM daily_accumulate d
    JOIN expanded_stats s
        ON d.host = s.host AND s.event_date = d.event_date + INTERVAL '1 day'
)
INSERT INTO host_activity_reduced (host, month_start, hit_array, unique_visitors_array)
SELECT
    host,
    DATE_TRUNC('month', event_date) AS month_start,
    hit_array,
    unique_visitors_array
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY host ORDER BY event_date DESC) AS rn
    FROM daily_accumulate
) final_rows
WHERE rn = 1
ON CONFLICT (host, month_start)
DO UPDATE
SET
    hit_array = EXCLUDED.hit_array,
    unique_visitors_array = EXCLUDED.unique_visitors_array;
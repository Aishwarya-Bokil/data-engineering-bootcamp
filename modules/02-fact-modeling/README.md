# Fact Data Modeling

## Problem
For this module, we work with the 'devices' and 'events' table.
The 'events' table records the web events on zach's websites. This table contains the following columns:
- url
- referrer
- user_id
- device_id
- host
- event_time
The 'devices' table records the device used to access zach's websites. This table contains the following columns:
- device_id
- browser_type
- browser_version_major
- browser_version_minor
- browser_version_patch
- device_type
- device_version_major
- device_version_minor
- os_type
- os_version_major
- os_version_minor
- os_version_patch

On further reading the questions, it is clear we want to join these tables and only need the following columns:
- event_date (derived from event_time)
- user_id
- device_id
- browser_type

The homework contains writing the following 8 queries:
1. Deduplication query for joined table.
2. DDL query to build 'user_devices_cumulated' table containing the following:
- Column - 'device_activity_datelist' which tracks users active days by 'browser_type'. 
In my approach, I have chosen to model the table containing a row for each user_id and browser_type for each day.
3. Cumulative query to populate this 'user_devices_cumulated' table using the 'events' table.
4. A query to convert 'device_activity_datelist' into a 'datelist_int' integer. This will be a 32 bit integer, where 0 means the user has been inactive on that browser_type and 1 represent activity. The leftmost bit represents the most recent date.
5. A DDL query for table 'hosts_cumulated' table containing the following:
- Column - 'host_activity_datelist' which tracks host activity for each date
6. Incremental query to populate the 'host_activity_datelist' table.
7. A DDL query to build a reduced 'host_activity_reduced' table which contains one record for each month. It contains the following:
- Month
- Host
- hit_array: Number of times a host receives any activity each day
- unique_visitors_array: Unique user_id's hitting the host each day
8. A query that populates this 'host_activity_reduced' table. I have used recursion in this query
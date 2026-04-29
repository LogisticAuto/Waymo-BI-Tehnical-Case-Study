/**********************************************************
* Project:	Waymo Sessionization [Gaps & Isalnds]
* Author:		Christopher (LogisticAuto)
* Scenario:	A vehicle sends pings every few seconds. If it stops for > 5 minutes, consider the next ping the start of a new "session" or "trip".
* Goal:			Identify trips by grouping sensore pings that occur within 5 minutes of each other.
* Why:			This is crucial for calculating Miles Per Disengagement.
* Optimization:	Uses CTEs to prevent fan-out on large fact tables.
**********************************************************/

With time_calc as	(
	SELECT
		vehicle_id,
		timestamp, --current event timestamp,
		mileage,
		LAG(timestamp) OVER (PARTITION BY vehicle_id ORDER BY timestamp) prev_event --previous event timestamp,
		-- Check if the gap between pings is > 5 mins
		CASE
			WHEN
				TIMESTAMP_DIFF
					(
						timestamp, --Current Event
						LAG(timestamp) OVER (PARTITION BY vehicle_id ORDER BY timestamp), --Previous Event
						MINUTE --Interval
					)	> 5 THEN 1 -- AMOUNT OF INTERVAL
			ELSE 0
		END is_new_session -- Create a flag to determine if a new session is identified
	FROM
		Database.Schema.Table
	),
	sessions AS (
	SELECT
		*,
		SUM(is_new_session) OVER (PARTITION BY vehicle_id ORDER BY timestamp) session_id
	FROM
		time_calc
	)
	SELECT 
		vehicle_id,
		session_id,
		MIN(timestamp) AS start_time,
		MAX(timestamp) AS end_time,
		MAX(mileage) - MIN(mileage) AS trip_distance
	FROM sessions
	GROUP BY 1, 2;

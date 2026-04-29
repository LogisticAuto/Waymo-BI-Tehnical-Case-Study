/**********************************************************
* Project:	Waymo Sessionization [Gaps & Isalnds]
* Author:		Christopher (LogisticAuto)
* Scenario:	Find instances where two different vendor vehicles were in the same zone at the exact same timestamp.
* Goal:			Identify trips by grouping sensore pings that occur within 5 minutes of each other.
* Why:			This is crucial for calculating Miles Per Disengagement.
* Optimization:	Uses CTEs to prevent fan-out on large fact tables.
**********************************************************/

WITH trips_with_geom AS (
    SELECT
        t.pickup_datetime,
        t.vendor_id,
        z.zone_geom
    FROM
        `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022` AS t
    JOIN
        `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom` AS z
        ON t.pickup_location_id = z.zone_id
    WHERE t.pickup_datetime >= '2022-01-01'
    --LIMIT 1000
)
SELECT 
    a.pickup_datetime,
    a.vendor_id AS v1,
    b.vendor_id AS v2,
    -- This calculates distance between the centroids (centers) of the two zones
    ST_DISTANCE(a.zone_geom, b.zone_geom) AS dist_between_zones
FROM trips_with_geom AS a
JOIN trips_with_geom AS b
    ON a.pickup_datetime = b.pickup_datetime
    AND a.vendor_id < b.vendor_id
--Optional (Results < 10)
WHERE
	ST_DISTANCE(a.zone_geom, b.zone_geom) < 10 AND
	ST_DISTANCE(a.zone_geom, b.zone_geom) > 0
ORDER BY dist_between_zones ASC;

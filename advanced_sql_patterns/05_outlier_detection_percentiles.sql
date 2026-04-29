/**********************************************************
* Project:	Outlier Detection within Average Trips 
* Author:		Christopher (LogisticAuto)
* Scenario:	
* Goal:			Find the 99thpercentile of trip distances to identify "extreme" long distance trips.
* Why:			
* Optimization:	
**********************************************************/

--	Version 1
WITH thresholds AS (
    -- Step 1: Calculate the P99 threshold for each vendor
    SELECT 
        vendor_id,
        PERCENTILE_CONT(trip_distance, 0.99) OVER(PARTITION BY vendor_id) AS p99_threshold
    FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
    WHERE trip_distance > 0
),
unique_thresholds AS (
    -- Step 2: Get one row per vendor with their specific P99
    SELECT DISTINCT vendor_id, p99_threshold 
    FROM thresholds
)
-- Step 3: Join back to the raw data to filter and average the outliers
SELECT 
    raw.vendor_id,
    MAX(ut.p99_threshold) p99,
    AVG(raw.trip_distance) AS avg_outlier_distance,
    COUNT(*) AS number_of_outlier_trips
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022` AS raw
JOIN unique_thresholds AS ut 
    ON raw.vendor_id = ut.vendor_id
WHERE raw.trip_distance > ut.p99_threshold
GROUP BY 1;

--	Version 2
SELECT 
    vendor_id,
    AVG(trip_distance) AS avg_outlier_distance
FROM (
    SELECT 
        vendor_id,
        trip_distance,
        PERCENTILE_CONT(trip_distance, 0.99) OVER(PARTITION BY vendor_id) AS p99
    FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
    WHERE trip_distance > 0
)
WHERE trip_distance > p99
GROUP BY 1;

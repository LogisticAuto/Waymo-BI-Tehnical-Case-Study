/**********************************************************
* Project:	Time Series Analysis - Rolling Averages  
* Author:		Christopher (LogisticAuto)
* Scenario:	
* Goal:			Calculate the 7 day rolling average opf daily trips for each vendor.
* Why:			
* Optimization:	
**********************************************************/

WITH daily_counts AS (
    -- Step 1: Aggregate data to the day level
    SELECT 
        vendor_id,
        EXTRACT(DATE FROM pickup_datetime) AS trip_date,
        COUNT(*) AS daily_trip_count
    FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
    WHERE pickup_datetime >= '2022-01-01'
    GROUP BY 1, 2
)
SELECT 
    vendor_id,
    trip_date,
    daily_trip_count,
    -- Step 2: Compute the moving average over the last 7 rows
    AVG(daily_trip_count) OVER (PARTITION BY vendor_id ORDER BY trip_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_avg
FROM daily_counts
ORDER BY vendor_id, trip_date;

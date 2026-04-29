/**********************************************************
* Project:	Pivoting Dashboard Metrics 
* Author:		Christopher (LogisticAuto)
* Scenario:	Show the count of specific payment types per vendor, pivoted into columns for an executive dashboard.
* Goal:			
* Why:			
* Optimization:	
**********************************************************/

SELECT 
    vendor_id,
    COALESCE(Credit_Card, 0) AS credit_trips,
    COALESCE(Cash, 0) AS cash_trips
FROM (
    SELECT 
        vendor_id, 
        CASE WHEN payment_type = '1' THEN 'Credit_Card' 
             WHEN payment_type = '2' THEN 'Cash' 
             ELSE 'Other'
		END AS pay_method
    FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2016`
    WHERE vendor_id IS NOT NULL
    LIMIT 10000
)
PIVOT (
    COUNT(*) 
    FOR pay_method IN ('Credit_Card', 'Cash')
);

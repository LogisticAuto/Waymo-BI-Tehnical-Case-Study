/**********************************************************
* Project:	User Defined Functions
* Author:		Christopher (LogisticAuto)
* Scenario:	
* Goal:			
* Why:			
* Optimization:	
**********************************************************/

--	User Defined Functions
	--	Scenario:	Waymo's "Safety" team needs to flag any event where a vehicle's deceleration exceeds a certain threshold. Instead of writing the math every time, create a reusable UDF.
		--	SQL Version
-- Step 1: Define the function
CREATE TEMP FUNCTION calculate_braking_severity(velocity_start FLOAT64, velocity_end FLOAT64, time_seconds FLOAT64)
RETURNS STRING AS (
  CASE 
    WHEN (velocity_start - velocity_end) / time_seconds > 4.5 THEN 'CRITICAL'
    WHEN (velocity_start - velocity_end) / time_seconds > 2.5 THEN 'MODERATE'
    ELSE 'NORMAL'
  END
);
-- Step 2: Use the function
WITH sensor_events AS (
  SELECT 'Waymo_01' as id, 25.0 as v1, 10.0 as v2, 2.0 as t
  UNION ALL
  SELECT 'Waymo_02' as id, 30.0 as v1, 28.0 as v2, 1.0 as t
)
SELECT 
    id,
    calculate_braking_severity(v1, v2, t) AS braking_event
FROM sensor_events;
---------------------------------------------------------------------------------------------------------
--	User Defined Functions
	--	Scenario:	Waymo's "Safety" team needs to flag any event where a vehicle's deceleration exceeds a certain threshold. Instead of writing the math every time, create a reusable UDF.
		--	Javascript Version
CREATE TEMP FUNCTION parse_sensor_status(log_string STRING)
RETURNS STRING
LANGUAGE js AS """
  try {
    // Imagine the string is 'SYS_OK|TEMP:45|BATT:90'         --This is the sample string
    let parts = log_string.split('|');                        --String now looks like: 'SYS_OK TEMP:45 BATT:90'
    let tempPart = parts.find(p => p.startsWith('TEMP:'));    --String looked and found TEMP:45
    return tempPart ? tempPart.split(':')[1] + '°C' : 'N/A';  --Give the result as: 45 + °C
  } catch (e) {
    return 'ERROR';
  }
""";

SELECT parse_sensor_status('SYS_OK|TEMP:52|BATT:88') AS temperature; -- When provided this input string, it published 52°C
---------------------------------------------------------------------------------------------------------
--	User Defined Functions
	--	Scenario:	We would like to analyze the health of the Waymo vehicles. Create a UDF to calculate Miles per Kilowatt Hour.
		--	Inputs: Start_Mileage, End_Mileage, kwh_consumed
		--	Output: The numeric efficiency
		--	Make sure the function factors in Division by Zero
-- Step 1: Create the function
CREATE TEMP FUNCTION calculate_ev_efficiency(start_miles FLOAT64, end_miles FLOAT64, kwh_consumed FLOAT64)
RETURNS FLOAT64 AS (
  -- Use SAFE_DIVIDE or an IF statement to prevent division by zero errors
  IF(kwh_consumed = 0 OR kwh_consumed IS NULL, 0,(end_miles - start_miles) / kwh_consumed)
);

-- Step 2: Test the function with sample Waymo data
WITH vehicle_logs AS (
  SELECT 'Waymo_A' as id, 100.0 as m1, 150.0 as m2, 10.0 as pwr -- Normal trip
  UNION ALL
  SELECT 'Waymo_B' as id, 200.0 as m1, 200.0 as m2, 0.0 as pwr  -- Idling/No power used
  UNION ALL
  SELECT 'Waymo_C' as id, 500.0 as m1, 550.0 as m2, 5.0 as pwr  -- Efficient trip
)
SELECT 
    id,
    m1 AS start_mileage,
    m2 AS end_mileage,
    pwr AS kwh,
    calculate_ev_efficiency(m1, m2, pwr) AS miles_per_kwh
	--Optional
	,CASE
		WHEN calculate_ev_efficiency(m1, m2, pwr) = 0.0		THEN 'Idling/No power used'
		WHEN calculate_ev_efficiency(m1, m2, pwr) = 5.0		THEN 'Normal trip'
		WHEN calculate_ev_efficiency(m1, m2, pwr) = 10.0	THEN 'Efficient trip'
		WHEN calculate_ev_efficiency(m1, m2, pwr) < 5.0		THEN 'Inefficient trip'
		WHEN calculate_ev_efficiency(m1, m2, pwr) > 10.0	THEN 'Extremely Efficient trip'
	END	Trip_Status
FROM vehicle_logs;

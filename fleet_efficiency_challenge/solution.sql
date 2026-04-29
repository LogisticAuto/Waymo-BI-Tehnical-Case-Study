/**********************************************************
* Project:		Waymo Fleet Efficiency Analysis
* Author:		Christopher (LogisticAuto)
* Goal:			Calculate miles per kWh while filtering for maintenance reliability.
* Why:			This allows the maintenance team to prioritize newer models with high efficiency.
* Optimization:	Uses CTEs to prevent fan-out on large fact tables.
**********************************************************/

WITH MaintenanceFilter AS (
    SELECT 
        a.model_name,
        SUM(b.cost_usd) as total_cost
    FROM dim_vehicles a
    JOIN fact_maintenance b ON a.vehicle_id = b.vehicle_id
    GROUP BY 1
    HAVING total_cost < 5000
),
EfficiencyCalc AS (
    SELECT 
        a.model_name,
        -- Correct Math: Ratio of Totals
        SAFE_DIVIDE(SUM(b.miles_driven), SUM(b.energy_kwh)) as miles_per_kwh
    FROM dim_vehicles a
    JOIN fact_trips b ON a.vehicle_id = b.vehicle_id
    -- Join to the filter CTE to only include valid models
    JOIN MaintenanceFilter c ON a.model_name = c.model_name
    GROUP BY 1
)
SELECT 
    model_name, 
    miles_per_kwh
FROM EfficiencyCalc
ORDER BY miles_per_kwh DESC
LIMIT 5;

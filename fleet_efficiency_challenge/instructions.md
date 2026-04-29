# Technical Challenge: Fleet Efficiency & Reliability Analysis

## Objective
Using the provided schema, write a SQL query to return the top 5 most efficient vehicle models, where efficiency is defined as **total miles driven / total kWh consumed** (miles per kWh).

### Constraints
1.  **Maintenance Filter:** Only include models where the total maintenance cost across all vehicles of that model is **< 5000**. (This identifies newer vehicles or high-reliability models).
2.  **Production-Ready Logic:** The query must be robust. It must not crash or return errors if energy consumed is **0 or NULL**.

### Output Requirements
* **Columns:** `model_name`, `miles_per_kwh`
* **Sorting:** Best-to-worst efficiency (Highest `miles_per_kwh` first).
* **Limit:** Top 5 results.

---

## Data Schema

### 1. `dim_vehicles` (Dimension Table)
* `vehicle_id` (PK)
* `model_name`
* `deployment_date`

### 2. `fact_trips` (Fact Table)
* `trip_id` (PK)
* `vehicle_id` (FK)
* `trip_date`
* `miles_driven`
* `energy_kwh` *(Note: May contain 0 or NULL values)*

### 3. `fact_maintenance` (Fact Table)
* `maintenance_id` (PK)
* `vehicle_id` (FK)
* `service_date`
* `cost_usd`

---

## Architectural Considerations
* **Relationship:** One-to-Many between `dim_vehicles` and both fact tables.
* **Fan-out Prevention:** When calculating model-level aggregates, logic must account for the potential "fan-out" effect (multiplication of rows) when joining multiple fact tables to a single dimension. Aggregation should occur prior to joining fact datasets.

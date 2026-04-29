# Case Study: Autonomous Fleet Performance & Efficiency Analysis

## Project Overview
This repository contains a series of advanced SQL solutions developed as a technical simulation for a Business Intelligence Analyst role at **Waymo**. The focus is on translating raw autonomous vehicle sensor and fleet data into actionable reliability and efficiency metrics.

## Key Technical Challenges Solved

### 1. Fleet Efficiency & Reliability (The "Star Schema" Join)
**Problem:** Identify the top 5 most efficient vehicle models while filtering for maintenance cost thresholds to ensure reliability.
**Skills Demonstrated:** * Avoiding join "fan-out" by aggregating before joining.
* Production-ready defensive coding using `SAFE_DIVIDE` and `COALESCE`.
* Handling complex relationships between dimension and multiple fact tables.
* **[View Solution Here](./advanced_sql_patterns/fleet_efficiency_challenge.sql)** 

### 2. Advanced Outlier Detection (Window Functions)
**Problem:** Define and isolate "long-tail" trip distances using the 99th percentile (P99) to identify sensor anomalies or extreme use cases.
**Skills Demonstrated:** * Use of `PERCENTILE_CONT` for continuous data distribution.
* Filtering analytic results using the `QUALIFY` clause for high-performance BigQuery execution.
* **[View Solution Here](./advanced_sql_patterns/05_outlier_detection_percentiles.sql)** 

### 3. Time-Series Optimization (Rolling Averages)
**Problem:** Calculate a 7-day rolling average of trip counts while accounting for potential "missing data days" in a 500M+ row dataset.
**Skills Demonstrated:** * Implementing `RANGE` vs `ROWS` window frames to maintain calendar accuracy.
* Optimization techniques: **Partitioning** and **Clustering** to reduce query costs and latency.
* **[View Solution Here](./advanced_sql_patterns/05_outlier_detection_percentiles.sql)** 

## Additional Technical Modules
* **[Sessionization & Gaps/Islands](./advanced_sql_patterns/01_sessionization_gaps_islands.sql):** Using `LAG` and `SUM OVER` to group high-frequency pings into distinct trips.
* **[Geospatial Proximity Joins](./advanced_sql_patterns/02_spatial_proximity_joins.sql):** Utilizing `ST_DISTANCE` to identify fleet concentration and zone overlaps.
* **[Array Flattening & UNNEST](./advanced_sql_patterns/06_unnesting_complex_arrays.sql):** Handling hierarchical logs and extracting specific keys from repeated structs.
* **[User Defined Functions (UDFs)](./advanced_sql_patterns/07_user_defined_functions.sql):** Creating reusable SQL and JavaScript logic for safety scoring and diagnostic parsing.

## Tools & Environment
* **SQL Dialect:** Google BigQuery (Standard SQL)
* **Concepts:** UDFs (User Defined Functions), CTEs, Window Functions, Geospatial (ST_DISTANCE).

# Case Study: Autonomous Fleet Performance & Efficiency Analysis

## Project Overview
This repository contains a series of advanced SQL solutions developed as a technical simulation for a Business Intelligence Analyst role at **Waymo**. The focus is on translating raw autonomous vehicle sensor and fleet data into actionable reliability and efficiency metrics.

## Key Technical Challenges Solved

### 1. Fleet Efficiency & Reliability (The "Star Schema" Join)
**Problem:** Identify the top 5 most efficient vehicle models while filtering for maintenance cost thresholds to ensure reliability.
**Skills Demonstrated:** * Avoiding join "fan-out" by aggregating before joining.
* Production-ready defensive coding using `SAFE_DIVIDE` and `COALESCE`.
* Handling complex relationships between dimension and multiple fact tables.

### 2. Advanced Outlier Detection (Window Functions)
**Problem:** Define and isolate "long-tail" trip distances using the 99th percentile (P99) to identify sensor anomalies or extreme use cases.
**Skills Demonstrated:** * Use of `PERCENTILE_CONT` for continuous data distribution.
* Filtering analytic results using the `QUALIFY` clause for high-performance BigQuery execution.

### 3. Time-Series Optimization (Rolling Averages)
**Problem:** Calculate a 7-day rolling average of trip counts while accounting for potential "missing data days" in a 500M+ row dataset.
**Skills Demonstrated:** * Implementing `RANGE` vs `ROWS` window frames to maintain calendar accuracy.
* Optimization techniques: **Partitioning** and **Clustering** to reduce query costs and latency.

## Tools & Environment
* **SQL Dialect:** Google BigQuery (Standard SQL)
* **Concepts:** UDFs (User Defined Functions), CTEs, Window Functions, Geospatial (ST_DISTANCE).

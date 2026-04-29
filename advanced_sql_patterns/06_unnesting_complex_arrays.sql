/**********************************************************
* Project:	Working with Arrays 
* Author:		Christopher (LogisticAuto)
* Scenario:	In trying to identify the TOP 10 most popular product, UNNEST the items from their array.
* Goal:			
* Why:			
* Optimization:	
**********************************************************/

--	UNNEST data
	--	Scenario:	In trying to identify the TOP 10 most popular product, UNNEST the items from their array.
SELECT
  item_name,
  COUNT(*) as times_added_to_cart
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) as item
WHERE
  event_name = 'add_to_cart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
---------------------------------------------------------------------------------------------------------
--	Filtering an array
	--	You can flatten everything first, but this creates extra rows which are unneccessary.
		--	This is most performant
SELECT 
    vehicle_id
FROM `waymo.data.vehicle_diagnostics`
WHERE 'E999' IN UNNEST(error_codes);
---------------------------------------------------------------------------------------------------------
--	Key-Value Flattening
	--	For tables which store event parameters as an array struct of:
		--	Event - Timestamp - Key - Value
	--	Scenario:	Turn specific keys into their own colummns (page_location, ga_session_id)
SELECT
  event_timestamp,
  event_name,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') as url,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') as session_id
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
LIMIT 100;
---------------------------------------------------------------------------------------------------------
--	Filter based on Array CONTENTS
	--	Identify users which are looking at 'Apparel' and 'Google' brands in one event.
SELECT
  event_timestamp,
  user_pseudo_id
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) as item
WHERE
  item.item_brand = 'Google'
  AND EXISTS (SELECT 1 FROM UNNEST(items) WHERE item_category = 'Apparel')
LIMIT 10;
---------------------------------------------------------------------------------------------------------
--	ARRAY_AGG
	--	Create a summary of all disengagements a car has in a trip, within a single cell
SELECT 
    trip_id,
    ARRAY_AGG(disengagement_reason ORDER BY timestamp) AS all_reasons
FROM `waymo.data.disengagements`
GROUP BY trip_id;

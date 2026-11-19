USE food_delivery;

Select * from  food_delivery_2;

select count(*) from food_delivery_2;

-- TASK 1 Establish Delivery-Duration Baseline

-- 	a) Delivery-duration baseline
SELECT COUNT(*) AS number_of_row,
       SUM(Time_taken_min IS NULL) AS nulls,
       SUM(Time_taken_min <= 0) AS zero_or_negative
FROM food_delivery_2;

-- Count, Mean, Median, Minimum, Maximum, 25th percentile, 75th percentile, and standard deviation
SELECT COUNT(Time_taken_min)               AS Count,
       ROUND(AVG(Time_taken_min), 2)       AS mean_Time_taken_min,
       MIN(Time_taken_min)                 AS min_Time_taken_min,
       MAX(Time_taken_min)                 AS max_Time_taken_min,
       ROUND(STDDEV_SAMP(Time_taken_min),2) AS std_dev_Time_taken_min
FROM food_delivery_2;

-- PART 2: Compare operational factors
-- a) Traffic Analysis:
SELECT Road_traffic_density,
       COUNT(*) AS deliveries,
       ROUND(AVG(Time_taken_min),2) AS mean_min
FROM food_delivery_2
WHERE Road_traffic_density <> 'No Records'
GROUP BY Road_traffic_density
ORDER BY mean_min Desc;

-- Result Summary: Higher traffic density is associated with longer delivery times.

-- Median by group
WITH r AS (
    SELECT Road_traffic_density AS grp,
           Time_taken_min AS d,
           ROW_NUMBER() OVER (PARTITION BY Road_traffic_density ORDER BY Time_taken_min) AS rn,
           COUNT(*) OVER (PARTITION BY Road_traffic_density) AS cnt,
           AVG(Time_taken_min) OVER (PARTITION BY Road_traffic_density) AS avg_d
    FROM food_delivery_2
    WHERE Road_traffic_density <> 'No Records'
)
SELECT grp, MAX(cnt) AS deliveries, ROUND(MAX(avg_d),2) AS mean_min,
       AVG(CASE WHEN rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2)) THEN d END) AS median_min
FROM r
GROUP BY grp
ORDER BY mean_min;


-- Weather Analysis
SELECT Weather_conditions,
       COUNT(*) AS deliveries,
       ROUND(AVG(Time_taken_min),2) AS mean_min
FROM food_delivery_2
WHERE Road_traffic_density <> 'No Records'
GROUP BY Weather_conditions
ORDER BY mean_min Desc;

-- Median by group
WITH r AS (
    SELECT Weather_conditions AS grp,
           Time_taken_min AS d,
           ROW_NUMBER() OVER (PARTITION BY Weather_conditions ORDER BY Time_taken_min) AS rn,
           COUNT(*) OVER (PARTITION BY Weather_conditions) AS cnt,
           AVG(Time_taken_min) OVER (PARTITION BY Weather_conditions) AS avg_d
    FROM food_delivery_2
    WHERE Weather_conditions <> 'No Records'
)
SELECT grp, MAX(cnt) AS deliveries, ROUND(MAX(avg_d),2) AS mean_min,
       AVG(CASE WHEN rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2)) THEN d END) AS median_min
FROM r
GROUP BY grp
ORDER BY mean_min;

-- Vehicle type Analysis
SELECT Type_of_vehicle,
       COUNT(*) AS deliveries,
       ROUND(AVG(Time_taken_min),2) AS mean_min
FROM food_delivery_2
WHERE Road_traffic_density <> 'No Records'
GROUP BY Type_of_vehicle
ORDER BY mean_min Desc;

-- Median by group
WITH r AS (
    SELECT  Type_of_vehicle AS grp,
           Time_taken_min AS d,
           ROW_NUMBER() OVER (PARTITION BY  Type_of_vehicle ORDER BY Time_taken_min) AS rn,
           COUNT(*) OVER (PARTITION BY  Type_of_vehicle) AS cnt,
           AVG(Time_taken_min) OVER (PARTITION BY  Type_of_vehicle) AS avg_d
    FROM food_delivery_2
    WHERE  Type_of_vehicle <> 'No Records'
)
SELECT grp, MAX(cnt) AS deliveries, ROUND(MAX(avg_d),2) AS mean_min,
       AVG(CASE WHEN rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2)) THEN d END) AS median_min
FROM r
GROUP BY grp
ORDER BY mean_min;

-- Duration by distance band:
SELECT CASE WHEN distance_km < 5  THEN '1. 0-5 km'
            WHEN distance_km < 10 THEN '2. 5-10 km'
            WHEN distance_km < 15 THEN '3. 10-15 km'
            ELSE '4. 15+ km' END AS distance_band,
       COUNT(*) AS deliveries,
       ROUND(AVG(Time_taken_min),2) AS mean_min
FROM v_delivery_distance
GROUP BY distance_band
ORDER BY distance_band;

-- Ratings Analysis
SELECT CASE WHEN Delivery_person_Ratings < 4   THEN '1. Below 4.0'
            WHEN Delivery_person_Ratings < 4.5 THEN '2. 4.0-4.4'
            WHEN Delivery_person_Ratings < 4.8 THEN '3. 4.5-4.7'
            ELSE '4. 4.8-5.0' END AS rating_band,
       COUNT(*) AS deliveries,
       ROUND(AVG(Time_taken_min),2) AS mean_min
FROM food_delivery_2
WHERE Delivery_person_Ratings BETWEEN 1 AND 5
GROUP BY rating_band
ORDER BY rating_band;


-- Time Taken vs Distance(Km)
SELECT ID,
       Time_taken_min,
       ROUND(ST_Distance_Sphere(
           POINT(ABS(Restaurant_longitude), ABS(Restaurant_latitude)),
           POINT(Delivery_location_longitude, Delivery_location_latitude)
       ) / 1000, 2) AS distance_km
FROM food_delivery_2
WHERE Restaurant_latitude <> 0 AND Restaurant_longitude <> 0;


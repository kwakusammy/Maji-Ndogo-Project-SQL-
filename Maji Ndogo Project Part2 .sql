/* Creating Emails for Employees */
UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ','.')), '@ndogowater.gov');


/* Counting the Number of digits in a phone number*/
SELECT 
LENGTH(phone_number)
FROM 
employee;

/* Update phone by removing leading and trailing spaces*/
UPDATE employee
SET phone_number = trim(phone_number);

-- Count of the various number of employees who live in a town
SELECT town_name, COUNT(employee_name) as employee_count
FROM employee
GROUP BY town_name;

-- Top employees
SELECT assigned_employee_id,
COUNT(visit_count) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
LIMIT 3;

SELECT 
employee_name,
email,
phone_number
FROM employee
WHERE assigned_employee_id = 0 OR assigned_employee_id = 1 or assigned_employee_id = 2
;
-- understand where the water sources are in Maji Ndogo per town
SELECT
COUNT(*) AS records_per_town,
town_name
FROM location
GROUP BY town_name;
-- understand where the water sources are in Maji Ndogo per province
SELECT
COUNT(*) AS records_per_town,
province_name
FROM location
GROUP BY province_name;


SELECT
province_name,
town_name,
count(*) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name ASC, records_per_town desc
 ;
 -- water sources per location type
 SELECT
location_type,
count(*) AS records_per_town
FROM location
GROUP BY location_type
;

-- Finding out number of people served/ numer of people who took part in the survey
SELECT 
SUM(number_of_people_served)
FROM
water_source;

-- Finding the number of water sources
SELECT
type_of_water_source,
count(*) AS Number_of_sources
FROM water_source
GROUP BY type_of_water_source
;

-- Finding the average number of people served by each water source
SELECT
type_of_water_source,
ROUND(avg(number_of_people_served)) AS average_number_of_people_served
FROM water_source
GROUP BY type_of_water_source
;

-- Finding the number of people served by each type of water source
SELECT
type_of_water_source,
sum(number_of_people_served) AS total_number_of_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_number_of_people_served DESC
;

-- Finding percentage of people served by each water source
SELECT
type_of_water_source,
ROUND(sum((number_of_people_served) / (SELECT 
								SUM(number_of_people_served)
								FROM
								water_source)*100)) AS Percentage_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY Percentage_people_served DESC
;

-- Ranking the water sources excluding tap in homes because they do not need improvement
SELECT
  type_of_water_source,
  SUM(number_of_people_served) AS total_number_of_people_served,
  RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS ranking
FROM
  water_source
WHERE type_of_water_source != 'tap_in_home'
GROUP BY
  type_of_water_source
ORDER BY
  total_number_of_people_served DESC;
  
  -- Which water shared tap should be fixed first
  SELECT
 source_id,
  type_of_water_source,
  number_of_people_served AS total_number_of_people_served,
  RANK() OVER (partition by type_of_water_source order BY number_of_people_served DESC) AS ranking
FROM
  water_source
WHERE type_of_water_source != 'tap_in_home'
ORDER BY
  total_number_of_people_served DESC;
  
  -- Total time spent on survey
SELECT
  DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS DATEELAPSE
FROM
  visits;
  
  -- Average total queue time for water
SELECT
  AVG(NULLIF(time_in_queue, 0)) AS average_time_in_queue
FROM
  visits; -- you can as well say where time in queue is not(!=) 0
  
  -- average time in queue per day of the week
  SELECT 
  DAYNAME(time_of_record) AS Day_of_the_week,
  ROUND(Avg(NULLIF(time_in_queue, 0)))as average_queue_time
  FROM
  visits
  GROUP BY
  Day_of_the_week;
  
  -- AVERAGE TIME IN QUEUE ON AN HOURLY BASIS
  SELECT
  time_format((time_of_record),'%H:00') AS hour_of_the_day,
  ROUND(AVG(NULLIF(time_in_queue, 0))) AS average_time_in_queue
FROM 
  visits
GROUP BY
  hour_of_the_day
  ORDER BY hour_of_the_day ASC;
 
 -- Showing average time in queue per day of the week per hour of the day (sunday)
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	DAYNAME(time_of_record) AS Day_of_the_week,
	
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END AS Sunday
FROM
visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
;

-- All other days of the week
SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
-- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
-- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
-- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
), 0) AS Tueday,
-- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
), 0) AS Wednesday,
-- Thursday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
), 0) AS Thursday,
ROUND(AVG(	
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
), 0) AS Friday,
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
), 0) AS Saturday
FROM
visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;  


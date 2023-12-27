-- ERD Design

-- Integrating the auditor's report
DROP TABLE IF EXISTS auditor_report;
CREATE TABLE auditor_report(
location_id VARCHAR(32),
type_of_water_source VARCHAR(64),
true_water_source_score int DEFAULT NULL,
statements VARCHAR(255)
);

-- the location_id and true_water_source_score columns from auditor_report
SELECT
 location_id,
 true_water_source_score
 FROM
auditor_report;

-- Joining Tables
SELECT
auditor_report.location_id AS location,
auditor_report.type_of_water_source AS auditor_source,
water_source.type_of_water_source AS survey_source, 
visits.record_id,
auditor_report.true_water_source_score AS Audit_score,
water_quality.subjective_quality_score AS Empoloyee_score
FROM
auditor_report
JOIN
visits 
ON auditor_report.location_id = visits.location_id
JOIN
water_quality
ON visits.record_id = water_quality.record_id
JOIN
water_source
ON water_source.source_id = visits.source_id
WHERE water_quality.subjective_quality_score != auditor_report.true_water_source_score AND visits.visit_count
= 1
LIMIT 10000;

-- Linking water source to employees
WITH
	Incorrect_records AS (
						SELECT
								auditor_report.location_id AS location,
								visits.record_id,
								employee.employee_name AS employee_name,
								auditor_report.true_water_source_score AS Audit_score,
								water_quality.subjective_quality_score AS Empoloyee_score
FROM
auditor_report
JOIN
visits 
ON auditor_report.location_id = visits.location_id
JOIN
water_quality
ON visits.record_id = water_quality.record_id
JOIN 
employee
ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE water_quality.subjective_quality_score != auditor_report.true_water_source_score AND visits.visit_count
= 1
LIMIT 10000
)
SELECT
 *
 FROM
 Incorrect_records;
 
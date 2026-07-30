# Purpose: clean patient-level clinical data with PATIENT_ID

CREATE OR REPLACE TABLE dim_patient AS
SELECT DISTINCT
    "#Patient Identifier" AS PATIENT_ID,
    *
FROM clinical_patient;

# QA: 1088

SELECT COUNT(DISTINCT PATIENT_ID) AS unique_patient_count
FROM dim_patient;
CREATE OR REPLACE TABLE dim_sample_clean AS
SELECT 
    "Sample Identifier" AS SAMPLE_ID,
    "#Patient Identifier" AS PATIENT_ID,
    "Tumor Type" AS TUMOR_TYPE
FROM clinical_sample;

# QA: 1088
SELECT COUNT(*)
FROM dim_sample_clean;
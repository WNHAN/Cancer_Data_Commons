CREATE OR REPLACE TABLE fact_condition AS
SELECT
    s.PATIENT_ID,
    c.Cancer_ID,
    s."Tumor Type"
FROM dim_sample_clean s
JOIN dim_cancer c
ON s."Tumor Type" = c.Cancer_name;
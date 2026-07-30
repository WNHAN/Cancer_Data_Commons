# Purpose: Create one record per patient.
# Input: clinical_patient
# Output: dim_patient

CREATE OR REPLACE TABLE dim_patient AS
SELECT DISTINCT * 
    FROM clinical_patient;
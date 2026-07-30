# Purpose: Standardize sample information.

# Input: clinical_sample

# Output: dim_sample_clean

CREATE OR REPLACE TABLE dim_sample_clean AS
SELECT
    "Sample Identifier" AS SAMPLE_ID,
    "#Patient Identifier" AS PATIENT_ID,
    *
    EXCLUDE ("Sample Identifier", "#Patient Identifier") 
    FROM clinical_sample;
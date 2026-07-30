CREATE OR REPLACE TABLE fact_mutation_patient AS
SELECT
    s.patient_id,
    f.*
FROM fact_mutation_final f
LEFT JOIN dim_sample_clean s
ON f.Tumor_Sample_Barcode = s.sample_id;
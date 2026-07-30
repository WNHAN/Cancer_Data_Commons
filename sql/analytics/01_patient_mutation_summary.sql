CREATE OR REPLACE TABLE patient_mutation_summary AS

SELECT

    PATIENT_ID,

    COUNT(*) AS total_mutations,

    COUNT(DISTINCT Hugo_Symbol) AS mutated_genes,

    COUNT(DISTINCT Variant_Classification) AS mutation_types

FROM fact_mutation_patient

GROUP BY PATIENT_ID;
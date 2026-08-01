-- ============================================================
-- 03_mutation_frequency.sql
--
-- Purpose:
--   Identify the top 20 most mutated patient in frequency.
--   What percentage of patients have each mutation?
-- ============================================================

SELECT
    Hugo_Symbol,
    COUNT(DISTINCT Patient_ID) AS patient_mutation,
    ROUND(COUNT(DISTINCT Patient_ID) * 100 /
        (SELECT COUNT(DISTINCT Patient_ID)
        FROM fact_mutation_patient),
        2 ) AS mutation_frequency_percent
FROM fact_mutation_patient 
GROUP BY Hugo_Symbol
ORDER BY mutation_frequency_percent DESC
LIMIT 20;
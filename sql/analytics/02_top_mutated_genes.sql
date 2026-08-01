-- ============================================================
-- 02_top_mutated_genes.sql
--
-- Purpose:
--   Identify the top 20 most frequently mutated genes.
--   Which genes are most frequently mutated?
-- ============================================================

SELECT
    Hugo_Symbol,
    COUNT(*) AS total_mutations,
    COUNT(DISTINCT Patient_ID) AS patient_count
FROM fact_mutation_patient
GROUP BY Hugo_Symbol
ORDER BY total_mutations DESC
LIMIT 20;
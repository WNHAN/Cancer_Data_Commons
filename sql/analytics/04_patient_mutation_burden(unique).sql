-- ============================================================
-- 04_patient_mutation_burden.sql
--
-- Purpose:
--   Identify patients with the highest number of unique
--   mutated genes.
-- ============================================================

SELECT 
	PATIENT_ID,
	COUNT(DISTINCT Hugo_Symbol) AS mutated_genes,
	COUNT(DISTINCT Variant_Classification) AS mutation_types
	FROM fact_mutation_patient
GROUP BY PATIENT_ID
ORDER BY mutated_genes DESC
LIMIT 20;
-- ============================================================
-- 04_patient_mutation_burden.sql
--
-- Purpose:
--   Identify patients with the highest mutation burden by
--   summarizing total mutations and unique mutated genes.
-- ============================================================

SELECT
    PATIENT_ID,
    COUNT(*) AS total_mutations,
    COUNT(DISTINCT Hugo_Symbol) AS mutated_genes,
    COUNT(DISTINCT Variant_Classification) AS mutation_types
FROM fact_mutation_patient
GROUP BY PATIENT_ID
ORDER BY total_mutations DESC
LIMIT 20;
  
  
  
  
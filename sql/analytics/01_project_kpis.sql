-- ============================================================
-- 01_project_kpis.sql
--
-- Purpose:
--   Overall Cancer Data Commons summary statistics.
-- ============================================================

SELECT
    COUNT(*) AS total_mutations,
    COUNT(DISTINCT Hugo_Symbol) AS mutated_genes,
    COUNT(DISTINCT Variant_Classification) AS mutation_types
FROM fact_mutation_patient;
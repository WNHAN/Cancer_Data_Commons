-- ============================================================
-- 06_cancer_subtypes.sql
--
-- Purpose:
--   Summarize the distribution of cancer subtypes
--   in the study cohort.
--
-- Output:
--   - Number of patients (or samples) by tumor type
-- ============================================================

SELECT
    "Tumor Type",
    COUNT(*) AS patient_count
FROM fact_condition
GROUP BY "Tumor Type"
ORDER BY patient_count DESC;
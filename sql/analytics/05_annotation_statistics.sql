-- ============================================================
-- 05_annotation_statistics.sql
--
-- Purpose:
--   Summarize mutation annotation results using the
--   four-tier gene matching strategy.
--
-- Output:
--   - Mutation count by annotation method
--   - Percentage of total mutations
-- ============================================================

SELECT
    Gene_Match_Method,
    COUNT(*) AS mutation_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM fact_mutation_annotated
GROUP BY Gene_Match_Method
ORDER BY mutation_count DESC;

-- ============================================================
-- 05_annotation_status.sql
--
-- Purpose:
--   Summarize mutation annotation results using the
--   four-tier gene matching strategy.
--
-- Output:
--   - Mutation count by annotation method roughly as 'Unresolved' and 'Resolved'
-- ============================================================

SELECT
    CASE
        WHEN Gene_Match_Method = 'Tier4_Unresolved'
        THEN 'Unresolved'
        ELSE 'Resolved'
    END AS Annotation_Status,
    COUNT(*) AS mutation_count
FROM fact_mutation_annotated
GROUP BY Annotation_Status;

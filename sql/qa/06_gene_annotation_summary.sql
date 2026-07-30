SELECT
    Gene_Match_Method,
    COUNT(*) AS mutation_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS pct 
FROM fact_mutation_annotated
GROUP BY Gene_Match_Method
ORDER BY Gene_Match_Method;

-- ============================================================
-- QA 1
-- Gene annotation summary
-- ============================================================

SELECT
    Gene_Match_Method,
    COUNT(*) AS mutation_count,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS pct
FROM fact_mutation_annotated
GROUP BY Gene_Match_Method
ORDER BY Gene_Match_Method;

-- ============================================================
-- QA 2
-- Row count validation
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM fact_mutation_patient) AS source_rows,
    (SELECT COUNT(*) FROM fact_mutation_annotated) AS annotated_rows,
    (SELECT COUNT(*) FROM fact_mutation_annotated)
    -
    (SELECT COUNT(*) FROM fact_mutation_patient)
        AS row_difference;
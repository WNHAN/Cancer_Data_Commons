-- ============================================================
-- 09_mutation_expression_summary.sql
--
-- Purpose:
--   To compare mutation and expression
--   Are the most frequently mutated genes also highly expressed?
-- ============================================================

WITH mutation_summary AS (
    SELECT
        Hugo_Symbol,
        COUNT(*) AS mutation_count
    FROM fact_mutation_patient
    GROUP BY Hugo_Symbol
),
expression_summary AS (
    SELECT
        Hugo_Symbol,
        ROUND(AVG(Expression_Value), 2) AS avg_expression
    FROM (
        UNPIVOT fact_expression
        ON COLUMNS('^TCGA-')
        INTO
            NAME Sample_ID
            VALUE Expression_Value
    )
    GROUP BY Hugo_Symbol
)

SELECT
    m.Hugo_Symbol,
    m.mutation_count,
    e.avg_expression
FROM mutation_summary m
LEFT JOIN expression_summary e
    ON m.Hugo_Symbol = e.Hugo_Symbol
ORDER BY m.mutation_count DESC
LIMIT 20;

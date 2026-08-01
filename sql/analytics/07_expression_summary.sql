-- ============================================================
-- 07_expression_summary.sql
--
-- Purpose:
--   Summarize RNA gene expression across the TCGA BRCA cohort.
--
-- Dataset:
--   fact_expression (wide format)
--
-- Outputs:
--   1. Top 20 genes by average expression
--   2. Top 20 genes with the greatest expression variability
--
-- Author: WNHAN
-- Version: 1.0
-- ============================================================

-- ============================================================
-- Analysis 1: Top 20 genes by average expression
-- ============================================================

SELECT
    Hugo_Symbol,
    Entrez_Gene_Id,
    ROUND(
        list_avg([COLUMNS('(?i)^TCGA-.*')]),
        3
    ) AS avg_expression
FROM fact_expression
WHERE Hugo_Symbol IS NOT NULL
GROUP BY ALL
ORDER BY avg_expression DESC
LIMIT 20;


-- ============================================================
-- Analysis 2: Top 20 genes by expression variability
-- ============================================================

SELECT
    Hugo_Symbol,
    Entrez_Gene_Id,
    ROUND(
        list_avg([COLUMNS('(?i)^TCGA-.*')]),
        3
    ) AS avg_expression,
    ROUND(
        list_stddev_pop([COLUMNS('(?i)^TCGA-.*')]),
        3
    ) AS expression_sd
FROM fact_expression
WHERE Hugo_Symbol IS NOT NULL
GROUP BY ALL
ORDER BY expression_sd DESC
LIMIT 20;
-- =====================================================
-- Script: 01_table_counts.sql
-- Purpose: Check row counts for warehouse tables
-- =====================================================

SELECT 'dim_patient' AS table_name,
        COUNT(*) AS row_count
FROM dim_patient

UNION ALL

SELECT 'dim_sample_clean' AS table_name,
        COUNT(*) AS row_count
FROM dim_sample_clean

UNION ALL

SELECT 'dim_gene' AS table_name,
        COUNT(*) AS row_count
FROM dim_gene

UNION ALL

SELECT 'dim_gene_mutation' AS table_name,
        COUNT(*) AS row_count
FROM dim_gene_mutation

UNION ALL
SELECT 'dim_gene_expression' AS table_name,
        COUNT(*) AS row_count
FROM dim_gene_expression    

UNION ALL
SELECT 'dim_cancer' AS table_name,
        COUNT(*) AS row_count
FROM dim_cancer 

UNION ALL
SELECT 'fact_mutation_final' AS table_name,
        COUNT(*) AS row_count
FROM fact_mutation_final    

UNION ALL
SELECT 'fact_expression' AS table_name,
        COUNT(*) AS row_count
FROM fact_expression;
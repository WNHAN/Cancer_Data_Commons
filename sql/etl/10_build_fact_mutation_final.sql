

-- =====================================================
-- Script: 10_build_fact_mutation_final.sql
-- Purpose: Build final mutation fact table
-- Source: fact_mutation
-- Dataset: cBioPortal TCGA BRCA
-- =====================================================

CREATE OR REPLACE TABLE fact_mutation_final AS
SELECT
    Tumor_Sample_Barcode,
    Matched_Norm_Sample_Barcode,
    Hugo_Symbol,
    Entrez_Gene_Id,
    NCBI_Build,
    Variant_Classification,
    Variant_Type,
    Chromosome,
    Start_Position,
    End_Position,
    Reference_Allele,
    Tumor_Seq_Allele2,
    Mutation_Status
FROM fact_mutation;
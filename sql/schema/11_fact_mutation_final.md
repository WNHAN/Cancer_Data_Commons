# Create table fact_mutation_final 
# from tables fact_mutation and 
# dim_sample-clean and dim_gene_mutation

CREATE OR REPLACE TABLE fact_mutation_final AS
SELECT
    m.*,
    s.PATIENT_ID,
    g.GeneID,
    g.descripition
FROM fact_mutation m
LEFT JOIN dim_sample_clean s
ON m.Tumor_Sample_Barcode = s.SAMPLE_ID
LEFT JOIN dim_gene_mutation g
ON m.Hugo_Symbol = g.Symbol;
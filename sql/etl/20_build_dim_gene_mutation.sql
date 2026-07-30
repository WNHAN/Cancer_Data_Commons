# Mutation genes from tables dim_gene and fact_mutation

CREATE OR REPLACE TABLE dim_gene_mutation AS
SELECT DISTINCT
    g.GeneID,
    g.Symbol,
    g.description
FROM dim_gene g
JOIN (
    SELECT DISTINCT Entrez_Gene_Id
    FROM fact_mutation
) m
ON g.GeneID = m.Entrez_Gene_Id;


# Expression genes from tables dim_gene and fact_expression

CREATE OR REPLACE TABLE dim_gene_expression AS
SELECT DISTINCT
    g.GeneID,
    g.Symbol,
    g.description
FROM dim_gene g
JOIN (
    SELECT DISTINCT Entrez_Gene_Id
    FROM fact_expression
) e
ON g.GeneID = e.Entrez_Gene_Id;
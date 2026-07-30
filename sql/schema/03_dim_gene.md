# create three related dimensions in gene domain: 
# Master gene table,mutation genes, and expression genes.

# the master gene table
CREATE OR REPLACE TABLE dim_gene AS
SELECT
    GeneID,
    Symbol,
    description
FROM read_csv_auto(
    'data/raw/ncbi/Homo_sapiens.gene_info',
    delim='\t',
    header=true
)
WHERE "#tax_id" = '9606';

# Mutation genes from tables dim_gene and fact_mutation

CREATE OR REPLACE TABLE dim_gene_mutation AS
SELECT DISTINCT
    g.*
FROM dim_gene g
JOIN (
    SELECT DISTINCT Hugo_Symbol
    FROM fact_mutation
) m
ON g.Symbol = m.Hugo_Symbol;

# Expression genes from tables dim_gene and fact_expression

CREATE OR REPLACE TABLE dim_gene_expression AS
SELECT DISTINCT
    g.*
FROM dim_gene g
JOIN (
    SELECT DISTINCT Hugo_Symbol
    FROM fact_expression
) e
ON g.Symbol = e.Hugo_Symbol;
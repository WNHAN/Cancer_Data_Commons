# Purpose: Use NCBI gene annotations to build a gene dimension table for the Cancer Data Commons
# Filter out human genes as tax_id = 9606
# the number of tax_id = 9606, 63221, and 741158 is 193802, 37, 36


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
WHERE "#tax_id" = '9606'
AND Symbol IS NOT NULL
AND Symbol != '';



import duckdb

con = duckdb.connect("database/cancer_commons.duckdb")

# --------------------------
# Gene dimension
# --------------------------

con.execute("""
CREATE OR REPLACE TABLE dim_gene AS
SELECT 
    GeneID,
    Symbol,
    description
FROM read_csv_auto('data/raw/ncbi/Homo_sapiens.gene_info',
delim = '\t',
Header = True)
WHERE "#tax_id" = '9606'
""")

# --------------------------
# Patient dimension
# --------------------------

con.execute("""
CREATE OR REPLACE TABLE dim_patient AS
SELECT *
FROM clinical_patient
""")

# --------------------------
# Sample dimension
# --------------------------

con.execute("""
CREATE OR REPLACE TABLE dim_sample AS
SELECT *
FROM clinical_sample
""")

# --------------------------
# Mutation fact table
# --------------------------

con.execute("""
CREATE OR REPLACE TABLE fact_mutation AS
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
FROM mutations
""")

# --------------------------
# RNA expression fact table
# --------------------------
con.execute("""
CREATE OR REPLACE TABLE fact_expression AS
SELECT *
FROM rna_expression
""")

# --------------------------
# Gene Mutation fact table
# --------------------------

con.execute("""
CREATE OR REPLACE TABLE dim_gene_mutation AS
SELECT DISTINCT
    g.GeneID,
	g.Symbol,
	g.description
FROM dim_gene g
JOIN ( SELECT DISTINCT Hugo_Symbol FROM fact_mutation ) m 
ON g.Symbol = m.Hugo_Symbol
""")


tables = [
    "dim_gene",
    "dim_patient",
    "dim_sample",
    "fact_mutation",
    "fact_expression",
    "dim_gene_mutation"
]

for t in tables:
    n = con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
    print(f"Table {t} has {n} rows")

con.close()


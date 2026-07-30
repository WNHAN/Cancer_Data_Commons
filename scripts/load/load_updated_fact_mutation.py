import duckdb
import os

con = duckdb.connect("database/cancer_commons.duckdb")

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
tables = [
    "fact_mutation" 
]

for t in tables:
    n = con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
    print(f"Table {t} has {n} rows")

con.close()

# 126252 rows #

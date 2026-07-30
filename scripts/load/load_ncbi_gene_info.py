import duckdb
import os

BASE = "data/raw/ncbi"
DB = "database/cancer_commons.duckdb"

con = duckdb.connect(DB)

# -------------------------
# Homo_Sapiens Gene Info
# -------------------------

gene_file = f"{BASE}/Homo_sapiens.gene_info"
if os.path.exists(gene_file):
    print(f"Loading {gene_file}...")
    con.execute(f"""
        CREATE OR REPLACE TABLE ncbi_gene AS
        SELECT *
        FROM read_csv_auto('{gene_file}', HEADER = True, DELIM = '\\t');
        """)

print("\nData Summary:")
for table in ["ncbi_gene"]:
    try:
        count = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table}: {count:,}")
    except:
        print(f"{table}: Not Loaded")

con.close()
print("\nNCBI gene data loading complete.")

import duckdb
import os

BASE = "data/raw/cbioportal/brca_tcga_pan_can_atlas_2018"
DB = "database/cancer_commons.duckdb"

con = duckdb.connect(DB)

print("Loading BRCA data into DuckDB...")

# -------------------------
# 1. Clinical Patient
# -------------------------

patient_file = f"{BASE}/data_clinical_patient.txt"
if os.path.exists(patient_file):
    print(f"Loading {patient_file}...")
    con.execute(f"""
        CREATE TABLE IF NOT EXISTS clinical_patient AS
        SELECT *
        FROM read_csv_auto('{patient_file}', HEADER = True, DELIM = '\\t');
        """)

# -------------------------
# 2. Clinical Sample
# -------------------------

sample_file = f"{BASE}/data_clinical_sample.txt"
if os.path.exists(sample_file):
    print(f"Loading {sample_file}...")
    con.execute(f"""
        CREATE TABLE IF NOT EXISTS clinical_sample AS
        SELECT *
        FROM read_csv_auto('{sample_file}', HEADER = True, DELIM = '\\t');
        """)


# -------------------------
# 3. Mutations
# -------------------------

mut_file = f"{BASE}/data_mutations.txt"
if os.path.exists(mut_file):
    con.execute(f"""
        CREATE OR REPLACE TABLE mutations AS
        SELECT *
        FROM read_csv_auto('{mut_file}',DELIM = '\\t', HEADER = True);
        """)

# -------------------------
# 4. RNA Expression
# -------------------------

rna_file = f"{BASE}/data_mrna_seq_v2_rsem.txt"
if os.path.exists(rna_file):
    con.execute(f"""
        CREATE OR REPLACE TABLE rna_expression AS
        SELECT *
        FROM read_csv_auto('{rna_file}',DELIM = '\\t', HEADER = True);
        """)

# -------------------------
# 5. QA Checks
# -------------------------

print("\nData Summary:")
for table in ["clinical_patient", "clinical_sample", "mutations", "rna_expression"]:
    try:
        count = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table}: {count:,}")
    except:
        print(f"{table}: Not Loaded")



# Top mutated genes
print("\nTop 10 Mutated Genes:")

try:
    top_genes = con.execute("""
        SELECT
            Hugo_Symbol,
            COUNT(*) AS mut_cnt
        FROM mutations
        GROUP BY Hugo_Symbol
        ORDER BY mut_cnt DESC
        LIMIT 10
    """).fetchall()

    for gene, count in top_genes:
        print(f"{gene}: {count:,}")

except Exception as e:
    print("Error occurred while fetching top mutated genes.")
    print(e)

con.close()
print("\nBRCA data loading complete.")
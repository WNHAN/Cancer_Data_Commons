| Table             |    Rows |
| ----------------- | ------: |
| `dim_gene`        | 193,802 |
| `dim_patient`     |   1,088 |
| `dim_sample`      |   1,088 |
| `fact_mutation`   | 126,252 |
| `fact_expression` |  20,531 |

Note:
# Master reference
full NCBI gene catalog (193k)
# Analytical layer
dim_gene (17,380)

# genes appearing in mutations

con.execute("""
CREATE OR REPLACE TABLE dim_gene_mutation AS
SELECT DISTINCT
	g.GeneID,
	g.Symbol,
	g.description
FROM dim_gene g
JOIN (
	SELECT DISTINCT Hugo_Symbol
	FROM fact_mutation
) m
ON g.Symbol = m.Hugo_Symbol
""")

Check

print(
	con.execute("""
	SELECT COUNT(*)
	FROM dim_gene_mutation
	""").fetchall()
)
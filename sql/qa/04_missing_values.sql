# check the missing values in important fields like patient,sample

#Patients
SELECT COUNT(*) AS missing_sample
FROM fact_mutation_final f
LEFT JOIN dim_sample_clean s
ON f.Tumor_Sample_Barcode = s.sample_id
WHERE s.sample_id IS NULL;

#Mutation
select
    count(*) as missing_gene_name
from fact_mutation_final
where Entrez_Gene_Id is null

#mutation - gene:6870 missing genes

SELECT COUNT(*) AS missing_gene
FROM fact_mutation_final f
LEFT JOIN dim_gene g
ON f.Entrez_Gene_Id = g.GeneID
WHERE g.GeneID IS NULL;  

#Sample
SELECT
    COUNT(*) AS missing_tumor_type
FROM dim_sample_clean
WHERE tumor_type IS NULL;
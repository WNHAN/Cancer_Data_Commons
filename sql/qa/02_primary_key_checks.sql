# purpose: check duplicate primary keys in the database

# Patient table: PATIENT_ID
SELECT PATIENT_ID, COUNT(*) AS count
FROM dim_patient
GROUP BY PATIENT_ID
HAVING COUNT(*) > 1;

# Sample table: SAMPLE_ID
SELECT SAMPLE_ID, COUNT(*) AS count
FROM dim_sample_clean
GROUP BY SAMPLE_ID
HAVING COUNT(*) > 1; 

# Gene table: GENE_ID
SELECT GeneID, COUNT(*) AS count
FROM dim_gene
GROUP BY GeneID
HAVING COUNT(*) > 1;
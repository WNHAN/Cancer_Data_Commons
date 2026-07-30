# check relationships between tables: mutation/patient and mutation/gene

SELECT COUNT(*) AS missing_gene
FROM fact_mutation_final f
LEFT JOIN dim_gene g
ON f.Entrez_Gene_Id = g.GeneID
WHERE g.GeneID IS NULL;

SELECT COUNT(*) AS missing_sample
FROM fact_mutation_final f
LEFT JOIN dim_sample_clean s
ON f.Tumor_Sample_Barcode = s.sample_id
WHERE s.sample_id IS NULL;



# check mutation/patient relationship
SELECT COUNT(*) AS missing_patientSELECT COUNT(*) AS missing_cancer
FROM dim_sample_clean
WHERE Cancer_ID IS NULL;


FROM fact_mutation_patient f
LEFT JOIN dim_patient p
ON f.PATIENT_ID = p.PATIENT_ID
WHERE p.patient_ID IS NULL;

# check mutation/gene relationship
-- Mutation records with unmatched gene annotation:6780
SELECT COUNT(*) AS unmatched_mutations
FROM fact_mutation_final f
LEFT JOIN dim_gene g
ON f.Entrez_Gene_Id = g.GeneID
WHERE g.GeneID IS NULL;

-- Percentage unmatched: 5.44%
SELECT
    ROUND(COUNT(*)*100 /
        (SELECT COUNT(*) FROM fact_mutation_final),
        2
    ) AS unmatched_percent
FROM fact_mutation_final f
LEFT JOIN dim_gene g
ON f.Entrez_Gene_Id = g.GeneID
WHERE g.GeneID IS NULL;

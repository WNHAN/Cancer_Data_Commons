# Purpose: rebuild the warehouse from scratch
DROP TABLE IF EXISTS fact_survival;
DROP TABLE IF EXISTS fact_condition;
DROP TABLE IF EXISTS fact_expression;
DROP TABLE IF EXISTS fact_mutation_final;

DROP TABLE IF EXISTS dim_cancer;
DROP TABLE IF EXISTS dim_gene_expression;
DROP TABLE IF EXISTS dim_gene_mutation;
DROP TABLE IF EXISTS dim_gene;
DROP TABLE IF EXISTS dim_sample_clean;
DROP TABLE IF EXISTS dim_patient;
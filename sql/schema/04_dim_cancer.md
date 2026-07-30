# Instead of manually inserting rows, 
# derive the dimension from clinical data.

CREATE OR REPLACE TABLE dim_cancer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY "Tumor Type") AS Cancer_ID,
    "Tumor Type" AS Cancer_name,
    'BRCA' AS Cancer_group,
    'Breast' AS Primary_site,
    'TCGA PanCancer Atlas' AS Data_source
FROM(
    SELECT DISTINCT "Tumor Type"
    FROM clinical_sample
    WHERE "Tumor Type" IS NOT NULL
    AND TRIM("Tumor Type") <> ''
    AND TRIM("Tumor Type") NOT IN (
        '1',
        'Tumor Type',
        'TUMOR_TYPE',
        'STRING'
    )
);

SELECT DISTINCT
    ROW_NUMBER() OVER () AS Cancer_ID,
    "tumor type" AS Cancer_name,
    CASE
        WHEN "tumor type" LIKE '%Breast%'
          OR "tumor type" LIKE '%Infiltrating%'
        THEN 'Breast Cancer'
        ELSE 'Other'
    END AS Cancer_group,
    'Breast' AS Primary_site,
    'TCGA cBioPortal' AS Data_source
FROM clinical_sample
WHERE "tumor type" IS NOT NULL
AND "tumor type" NOT IN
(
    'STRING',
    'TUMOR_TYPE',
    'Tumor Type'
);
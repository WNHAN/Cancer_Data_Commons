#Tumor type distribution in table dim_sample_clean

SELECT
    TRIM(Tumor_Type) AS Tumor_Type,
    COUNT(*) AS samples
FROM dim_sample_clean
WHERE TRIM (Tumor_Type) <> ''
AND TRIM (Tumor_Type) NOT IN (
		'1',
		'Tumor Type',
		'TUMOR_TYPE',
		'STRING'
		)
GROUP BY TRIM(Tumor_Type)
ORDER BY samples DESC;
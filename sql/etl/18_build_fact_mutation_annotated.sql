-- 18_build_fact_mutation_annotated.sql
--
-- Purpose:
--   Annotate mutation records using a 4-tier gene matching
--   strategy to rescue historical symbols via NCBI Synonyms.
--
-- Tier 1: Valid Entrez_Gene_Id -> dim_gene.GeneID
-- Tier 2: Entrez_Gene_Id = 0/NULL -> Hugo_Symbol -> dim_gene.Symbol
-- Tier 3: Hugo_Symbol -> ncbi_gene.Synonyms
-- Tier 4: Unresolved
--
-- Source:
--   fact_mutation_patient
--   dim_gene
--   ncbi_gene
--
-- Output:
--   fact_mutation_annotated
--
-- Notes:
--   Tier 3 synonym matches are reduced to ONE NCBI gene
--   per Hugo_Symbol using ROW_NUMBER() to prevent duplicate
--   mutation records.
-- ============================================================


CREATE OR REPLACE TABLE fact_mutation_annotated AS

WITH synonym_match AS
(
    SELECT
        f.Hugo_Symbol,
        n.GeneID,
        n.Symbol,
        n.description,

        ROW_NUMBER() OVER
        (
            PARTITION BY f.Hugo_Symbol
            ORDER BY n.GeneID
        ) AS rn

    FROM
    (
        SELECT DISTINCT
            Hugo_Symbol
        FROM fact_mutation_patient
        WHERE Entrez_Gene_Id IS NULL
           OR Entrez_Gene_Id = 0
    ) AS f

    INNER JOIN ncbi_gene AS n
        ON n."#tax_id" = 9606
       AND
       (
            LOWER(TRIM(n.Synonyms))
                = LOWER(TRIM(f.Hugo_Symbol))

            OR

            (
                '|' || LOWER(TRIM(n.Synonyms)) || '|'
            )
            LIKE
            (
                '%|' || LOWER(TRIM(f.Hugo_Symbol)) || '|%'
            )
       )
),

tier3 AS
(
    SELECT
        Hugo_Symbol,
        GeneID,
        Symbol,
        description
    FROM synonym_match
    WHERE rn = 1
)

SELECT
    f.*,

    ------------------------------------------------------------
    -- Resolved NCBI annotation
    ------------------------------------------------------------

    COALESCE(g.GeneID, t3.GeneID) AS Resolved_GeneID,
    COALESCE(g.Symbol, t3.Symbol) AS Official_Symbol,
    COALESCE(
        g.description,
        t3.description
    ) AS Gene_Description,

    ------------------------------------------------------------
    -- Gene Match Method
    ------------------------------------------------------------

    CASE

        --------------------------------------------------------
        -- Tier 1
        --------------------------------------------------------
        WHEN
            f.Entrez_Gene_Id IS NOT NULL
            AND f.Entrez_Gene_Id <> 0
            AND g.GeneID IS NOT NULL
        THEN 'Tier1_EntrezID'


        --------------------------------------------------------
        -- Tier 2
        --------------------------------------------------------

        WHEN
            (
                (f.Entrez_Gene_Id IS NULL
                 OR f.Entrez_Gene_Id = 0)
                AND g.GeneID IS NOT NULL
            )
        THEN 'Tier2_OfficialSymbol'


        --------------------------------------------------------
        -- Tier 3
        --------------------------------------------------------

        WHEN
            (
                (f.Entrez_Gene_Id IS NULL
                 OR f.Entrez_Gene_Id = 0)
                AND g.GeneID IS NULL
                AND t3.GeneID IS NOT NULL
            )
        THEN 'Tier3_NCBISynonym'


        --------------------------------------------------------
        -- Tier 4
        --------------------------------------------------------
        ELSE 'Tier4_Unresolved'

    END AS Gene_Match_Method
FROM fact_mutation_patient f


------------------------------------------------------------
-- Tier 1 + Tier 2
------------------------------------------------------------
LEFT JOIN dim_gene g
ON
(

    (
        f.Entrez_Gene_Id IS NOT NULL
        AND f.Entrez_Gene_Id <> 0
        AND f.Entrez_Gene_Id = g.GeneID
    )
    OR
    (
        (
            f.Entrez_Gene_Id IS NULL
            OR f.Entrez_Gene_Id = 0
        )

        AND f.Hugo_Symbol = g.Symbol
    )

)


------------------------------------------------------------
-- Tier 3
------------------------------------------------------------

LEFT JOIN tier3 t3
ON
(
    (
        f.Entrez_Gene_Id IS NULL
        OR f.Entrez_Gene_Id = 0
    )
    AND g.GeneID IS NULL
    AND LOWER(f.Hugo_Symbol)
        = LOWER(t3.Hugo_Symbol)
);


-- ============================================================
-- QA 1
-- Distribution of annotation tiers
-- ============================================================

SELECT
    Gene_Match_Method,
    COUNT(*) AS mutation_count
FROM fact_mutation_annotated
GROUP BY Gene_Match_Method
ORDER BY Gene_Match_Method;


-- ============================================================
-- QA 2
-- Verify row count preservation
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM fact_mutation_patient)
        AS source_rows,
    (SELECT COUNT(*) FROM fact_mutation_annotated)
        AS annotated_rows,
    (SELECT COUNT(*) FROM fact_mutation_annotated)
    -
    (SELECT COUNT(*) FROM fact_mutation_patient)
        AS row_difference;
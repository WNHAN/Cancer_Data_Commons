# Cancer Data Commons

## Overview

**Cancer Data Commons** is a reproducible cancer data engineering and bioinformatics project that integrates multi-dimensional cancer data into an analytical data warehouse using **DuckDB, Python, and SQL**.

The project builds a mini cancer data commons by transforming public cancer datasets into a structured warehouse environment suitable for mutation analysis, gene annotation, clinical exploration, and downstream analytics.

The current release is:

**Version 1.0 — Cancer Data Commons**

---

# Project Objectives

The goals of this project are:

* Build a reproducible cancer data ingestion and transformation pipeline
* Integrate clinical, genomic, and molecular datasets
* Design a dimensional data warehouse for cancer analytics
* Standardize gene annotation using NCBI reference information
* Perform quality assurance checks throughout the ETL workflow
* Enable reproducible SQL-based cancer research analysis

---

# Data Sources

## cBioPortal TCGA Breast Cancer Dataset

Source:

* cBioPortal Breast Cancer Pan-Cancer Atlas
* TCGA Breast Cancer (BRCA)

Integrated data types:

* Clinical patient information
* Clinical sample information
* Somatic mutation data
* RNA expression data
* Survival information

---

## NCBI Gene Annotation

Source:

* NCBI Homo sapiens Gene Information

Used for:

* Gene identifier normalization
* Official gene symbol mapping
* Historical synonym rescue
* Gene metadata enrichment

---

# Technology Stack

## Programming

* Python
* SQL

## Database

* DuckDB

## Bioinformatics Data Sources

* cBioPortal
* TCGA
* NCBI Gene

## Development Environment

* VS Code
* WSL Ubuntu

---

# Project Architecture

```
Public Cancer Data
        |
        v
+----------------+
| Data Ingestion |
+----------------+
        |
        v
+----------------+
| ETL Processing |
| Python + SQL   |
+----------------+
        |
        v
+----------------+
| DuckDB         |
| Data Warehouse |
+----------------+
        |
        v
+----------------+
| Analytics      |
| QA Validation |
+----------------+
```

---

# Repository Structure

```
Cancer_Data_Commons/

├── dashboard/
│
├── data/
│   ├── raw/              # ignored
│   ├── interim/          # ignored
│   └── processed/        # ignored
│
├── database/
│   └── cancer_commons.duckdb   # ignored
│
├── doc/
│   ├── DATA_DICTIONARY.md
│   ├── ETL_PIPELINE.md
│   ├── PROJECT_WORKFLOW.md
│   ├── QA_REPORT.md
│   ├── STAR_SCHEMA.md
│   └── VERSION_HISTORY.md
│
├── notebooks/
│
├── scripts/
│   └── load/
│       ├── build_data_commons.py
│       ├── duckdb_connection.py
│       ├── load_brca_v1.py
│       ├── load_ncbi_gene_info.py
│       └── load_updated_fact_mutation.py
│
└── sql/
    ├── analytics/
    ├── etl/
    ├── qa/
    └── schema/
```

---

# Data Warehouse Design

The project uses a dimensional warehouse design.

## Dimension Tables

### dim_patient

Patient-level clinical information.

Example attributes:

* Patient ID
* Clinical characteristics
* Survival information

---

### dim_sample

Cancer sample-level information.

Example attributes:

* Sample ID
* Patient relationship
* Cancer classification

---

### dim_gene

Reference gene dimension created from NCBI Gene.

Example attributes:

* GeneID
* Official Symbol
* Synonyms
* Gene metadata

---

### dim_cancer

Cancer classification dimension.

Example attributes:

* Cancer ID
* Cancer name
* Cancer group
* Primary site

---

# Fact Tables

## fact_mutation_final

Central somatic mutation fact table.

Contains:

* Mutation information
* Sample relationship
* Gene relationship
* Annotation status

---

## fact_expression

Gene expression measurements.

---

## fact_survival

Clinical survival outcomes.

---

## fact_condition

Clinical condition information.

---

# Gene Annotation Strategy

Mutation records are annotated using a four-tier gene matching strategy.

The workflow prioritizes high-confidence identifiers first and progressively applies rescue strategies while preserving data provenance.

| Tier   | Method                | Matching Key                 | Confidence |
| ------ | --------------------- | ---------------------------- | ---------- |
| Tier 1 | Entrez Gene ID Match  | Entrez_Gene_Id → NCBI GeneID | Highest    |
| Tier 2 | Official Symbol Match | Hugo_Symbol → NCBI Symbol    | High       |
| Tier 3 | NCBI Synonym Rescue   | Hugo_Symbol → NCBI Synonyms  | Moderate   |
| Tier 4 | Unresolved            | No confident match           | Review     |

---

## Tier 1 — Entrez Gene ID Match

Primary annotation method.

Matching:

```
fact_mutation.Entrez_Gene_Id
              |
              v
dim_gene.GeneID
              |
              v
Annotated Gene
```

Stable identifiers are preferred because they provide the strongest linkage between mutation records and reference genes.

---

## Tier 2 — Official Symbol Match

Used when Entrez Gene ID matching is unavailable.

Matching:

```
fact_mutation.Hugo_Symbol
              |
              v
dim_gene.Symbol
              |
              v
Annotated Gene
```

---

## Tier 3 — NCBI Synonym Rescue

Used to recover historical or alternative gene names.

Matching:

```
fact_mutation.Hugo_Symbol
              |
              v
dim_gene.Synonyms
              |
              v
Annotated Gene
```

This improves compatibility with older cancer datasets.

---

## Tier 4 — Unresolved Records

Records without a confident gene mapping are retained.

No forced mapping is performed.

Reasons:

* prevents incorrect biological interpretation
* preserves auditability
* allows future annotation updates

---

# Gene Annotation QA Results

Mutation annotation coverage:

| Gene Match Method       | Mutation Count | Percentage |
| ----------------------- | -------------: | ---------: |
| Tier 1: Entrez Gene ID  |        119,382 |     94.56% |
| Tier 2: Official Symbol |             91 |      0.07% |
| Tier 3: NCBI Synonym    |          6,176 |      4.89% |
| Tier 4: Unresolved      |            603 |      0.48% |
| Total                   |        126,252 |       100% |

Overall annotation success:

```
99.52% successfully annotated
0.48% unresolved
```

---

# ETL Workflow

The pipeline follows these steps:

## 1. Data Loading

Scripts:

```
scripts/load/
```

Responsibilities:

* Load cBioPortal files
* Load NCBI Gene reference data
* Create DuckDB connections

---

## 2. Dimension Building

SQL:

```
sql/etl/
```

Builds:

* dim_patient
* dim_sample
* dim_gene
* dim_cancer

---

## 3. Fact Table Construction

Creates:

* fact_mutation_final
* fact_expression
* fact_survival
* fact_condition

---

## 4. Mutation Annotation

Creates enriched mutation datasets using the 4-tier matching strategy.

---

# Quality Assurance

The project includes SQL-based QA validation.

QA checks include:

## Table Counts

Validation of:

* row counts
* expected data loading

---

## Primary Key Checks

Validation of:

* uniqueness
* duplicate records

---

## Foreign Key Checks

Validation of:

* dimension relationships
* referential integrity

---

## Missing Value Checks

Validation of:

* incomplete records
* annotation gaps

---

# Example Analytics

The warehouse supports:

* Patient mutation summaries
* Gene mutation frequency analysis
* Cancer subtype analysis
* Gene annotation coverage analysis
* Clinical outcome exploration

---

# Reproducibility

To reproduce the project:

1. Clone the repository

```bash
git clone git@github.com:WNHAN/Cancer_Data_Commons.git
```

2. Install required Python packages

3. Download public source datasets

4. Run ETL scripts

5. Execute SQL transformation scripts

6. Run QA validation scripts

---

# Version History

## v1.0 — Cancer Data Commons

Initial production release.

Includes:

* DuckDB warehouse
* cBioPortal BRCA integration
* NCBI gene reference integration
* Star schema design
* Four-tier mutation annotation workflow
* SQL QA framework

---

# Future Development

Potential future improvements:

* Add interactive dashboards
* Add additional TCGA cancer types
* Integrate clinical trial information
* Expand molecular annotation
* Add automated pipeline execution

## Architecture

![Architecture](doc/images/architecture.png)



---

# License

This project uses publicly available cancer research datasets.

Please refer to individual data source licenses and usage requirements.

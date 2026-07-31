# Raw data ingestion
# cBioPortal loading
# NCBI Gene loading
# Dimension creation
# Fact table creation
# Mutation annotation step

fact_mutation
      |
      v
Tier 1 Entrez ID Match
      |
      v
Tier 2 Official Symbol Match
      |
      v
Tier 3 NCBI Synonym Rescue
      |
      v
Tier 4 Unresolved
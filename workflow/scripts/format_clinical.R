# Purpose:
# Formatting TCGA-LAML clinical data
# Will combine two pieces of TCGA clinical documentation
# One contains censor for survival taken for cbioportal
# The other is taken directly from the publication
# which outlines clinical characteristics

library(dplyr)
library(readr)
library(tidyr)
library(stringr)

cbioportal <- read_csv(snakemake@input[["cbioportal"]])
publication <- read_csv(snakemake@input[["publication"]], na = c("N/A", "", " "))
immunophenotyping <- read_csv(snakemake@input[["immunophenotyping"]])

cbioportal <- cbioportal %>%
  rename_with(~ str_replace_all(., c(" " = "_"))) %>%
  rename_with(~ tolower(.)) %>%
  select(
    patient_id,
    sex,
    race = race_category,
    efs_status = disease_free_status,
    os_status = overall_survival_status
  ) %>%
  mutate(
    patient_id = str_replace_all(patient_id, "TCGA-AB-", ""),
    efs_status = ifelse(str_detect(efs_status, "^0"), 0, 1),
    os_status = ifelse(str_detect(os_status, "^0"), 0, 1)
  ) %>%
  mutate(
    patient_id = as.character(patient_id)
  )

common_mutations <- c(
  "npm1",
  "flt3",
  "idh1",
  "idh2",
  "dnmt3a",
  "nras",
  "tet2",
  "tp53"
)
clinical <- publication %>%
  rename_with(~ str_replace_all(., c(" " = "_"))) %>%
  rename_with(~ tolower(.)) %>%
  select(
    age,
    patient_id = tcga_patient_id,
    cytogenetics,
    subtype = molecular_classification,
    induction,
    translocation = `inferred_genomic_rearrangement_(from_rna-seq_fusion)`,
    efs_time = efs_months____3.31.12,
    os_time = os_months__3.31.12,
    days_to_relapse = trnsplt,
    wbc,
    eln = `risk_(cyto)`,
    all_of(common_mutations)
  ) %>%
  mutate(
    flt3 = case_when(
      str_detect(flt3, "p.D.*") ~ "TKD",
      str_detect(flt3, "in_.*") ~ "ITD",
      .default = flt3
    ),
    subtype = str_replace_all(
      subtype,
      c(
        "Normal Karyotype" = "Normal karyotype",
        "Complex Cytogenetics" = "Complex karyotype",
        "MLL.*" = "MLL rearranged",
        "CBFB-MYH11" = "inv(16)",
        "PML-RARA" = "t(15;17)",
        "RUNX1-RUNX1T1" = "t(8;21)",
        "Intermediate Risk Cytogenetic Abnormality" = "Other",
        "Poor Risk Cytogenetic Abnormality" = "Other",
        "NUP98.*" = "NUP98 translocation"
      )
    )
  ) %>%
  mutate(patient_id = as.character(patient_id)) %>%
  inner_join(cbioportal, by = "patient_id")

immunophenotyping <- immunophenotyping %>%
  select(
    immunophenotype = immunophenotype_cytochemistry_testing_result,
    patient_id = bcr_patient_barcode
  ) %>%
  mutate(
    hladr_status = case_when(
      str_detect(immunophenotype, "HLA-DR  Negative") ~ "negative",
      str_detect(immunophenotype, "HLA-DR Positive") ~ "positive",
      .default = NA
    )
  ) %>%
  mutate(patient_id = str_replace_all(patient_id, "TCGA-AB-", "")) %>%
  mutate(patient_id = as.character(patient_id))

clinical <- clinical %>%
  inner_join(immunophenotyping, by = "patient_id")

write_csv(clinical, snakemake@output[["clinical"]])

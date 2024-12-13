
library(TCGAbiolinks)
library(stringr)
library(dplyr)
library(readr)

mirnaseq <- GDCquery(
  project = "TCGA-LAML",
  data.category = "Transcriptome Profiling",
  data.type = "miRNA Expression Quantification",
  workflow.type = "BCGSC miRNA Profiling",
  experimental.strategy = "miRNA-Seq"
)

GDCdownload(mirnaseq, directory = "results/mirnaseq/")
raw_mirna_counts <- GDCprepare(mirnaseq, directory = "results/mirnaseq")

raw_mirna_counts <- raw_mirna_counts %>%
  select(
    mirna_id = miRNA_ID,
    contains("read_count")
  ) %>%
  rename_with(~ str_replace_all(., c("read_count_TCGA-AB-" = "", "-.*" = ""))) %>%
  rename_with(~ paste0("TCGA-AB-", .x, recycle0 = TRUE), !mirna_id)

write_csv(raw_mirna_counts, snakemake@output[["raw_mirna_counts"]])

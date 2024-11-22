# Purpose:
# Retrieve raw counts

library(TCGAbiolinks)
library(dplyr)
library(readr)
library(stringr)

rnaseq <- GDCquery(
  project = "TCGA-LAML",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  experimental.strategy = "RNA-Seq"
)

GDCdownload(rnaseq, directory = "results/rnaseq/")
raw_counts <- GDCprepare(rnaseq, summarizedExperiment = FALSE, directory = "results/rnaseq")

raw_counts <- raw_counts %>%
  select(
    gene_id,
    gene_name,
    gene_type,
    contains("unstranded")
  ) %>%
  select(!contains(c("tpm", "fpkm"))) %>%
  rename_with(~ str_replace_all(., c("unstranded_TCGA-AB-" = "", "-.*" = ""))) %>%
  mutate(gene_id = str_replace_all(gene_id, "\\..*", ""))

write_csv(raw_counts, snakemake@output[["raw_counts"]])

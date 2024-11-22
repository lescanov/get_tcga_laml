### Purpose:
* Retrieve raw RNA-sequencing and miRNA-sequencing for TCGA-LAML dataset
* Wrangle clinical data for TCGA-LAML cohort and append immunophenotyping
* Format raw counts for ready use in downstream analysis

### Output:
* Formatted raw RNA-seq counts
* Formatted raw miRNA-seq counts
* Harmonized clinical data including:
    * overall and disease free survival
    * updated patient subtyping
    * formatted columns
    * immunophenotyping

### Dependencies and how to use
To get the results of this analysis you need to for this repository and have snakemake installed. Once both are finished, run the following code in your terminal, at the project root directory:

```zsh
snakemake --use-conda
```
Or if running on an ARM64 machine, some packages are not available on anaconda so you must specify osx-64 as the architecture for the pipeline.
```
CONDA_SUBDIR=osx-64 snakemake --use-conda
```

To retrieve the raw sequencing data I am using the package TCGAbiolinks. The clinical data that is processed here was retrieved from the GDC and cbioportal.

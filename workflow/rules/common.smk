raw_mirna_counts = 'results/mirnaseq/raw_tcga_mirna_counts.csv'
raw_rna_counts = 'results/rnaseq/raw_tcga_rna_counts.csv'
clinical = 'results/clinical/tcga_clinical_summary.csv'

def get_final_output():
	final = [raw_mirna_counts, raw_rna_counts, clinical]
	return final

rule retrieve_rnaseq:
	output:
		raw_counts=protected(raw_rna_counts)
	conda: '../envs/data_munging.yaml'
	script:
		'../scripts/rnaseq.R'

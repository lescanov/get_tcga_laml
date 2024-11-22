rule retrieve_mirnaseq:
	output:
		raw_mirna_counts=protected(raw_mirna_counts)
	conda: '../envs/data_munging.yaml'
	script:
		'../scripts/mirnaseq.R'

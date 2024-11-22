rule format_clinical:
	input:
		cbioportal=config['cbioportal'],
		publication=config['publication']
	output:
		clinical=clinical
	conda:
		'../envs/data_munging.yaml'
	script:
		'../scripts/format_clinical.R'


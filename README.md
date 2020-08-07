# Snakepipe
A downloadable version of the the snakemake pipeline to run hmmer searches on metagenomes using pre-build MSAs. This pipline outputs hmmout files, as well as the fasta hit sequences, and the hit fasta sequences below a threshold E-value.

# Requirements:
This code requires the following to be on your PATH:

	snakemake, conda, HMMER, seqtk, and yyaml

# Steps:

1.) Download Snakefile, submit_snake.sh, genefile.txt, theshold-parser.py, and all of the .yaml enviroment files	

2.) Make directories titled "submit", "envs", "hmm_results", "inputs", and "slurm_logs"	

3.) Move the .yaml files to the "envs" directory	

4.) Make a file called "genefile.txt" to the "input" directory	

5.) Populate the "submit" directory with your MSAs. Each MSA should be in its own directory, named for the MSA, and have a file type of ".protein.faa"	

5.) Edit "genefile.txt" to list the names of the MSA directories you made in the submit directory	

6.) Edit "config.yaml" to point towards the location of your metagenomes:	

    prot_dir = location of your metagenomes	
    alignment_dir = location of the "submit" directory (should be the same location as the snakefile)	
    output_dir = location of the "hmm_results" directory (should be the same location as the snakefile)	
    gene_list = location of the "inputs" directory (should be the same location as the snakefile)	
		
 7.) Modify the submit_snakefile.sh file to fit the slurm inputs you want to use (the default settings should work fine if you don't want to bother with this)	
 
 8.) On the command line, type: 
 
 	"bash submit_snakefile.sh"	
 
 9.) After the Snakefile runs, use the command line to run:
 
 	"python threshold_parser.py" 
 
 The default E-value cut off is 0.00005. If you want to use another E-value, pass this as an argument to the threshold parser. for example:
 
 	"python threshold_parser.py 0.000000001"
 
 10.) All of your results can be found under the hmm_search tab. Move the slurm.out files to the slurm_logs folder or delete them. 	
 
 # Troubleshooting
 Some issues I have encountered and their solutions
 
 - occasionally, snakemake will report that the directory is locked and will not run. To fix, try:
 
 	"snakemake --cores=1 --unlock"
	
- The threshold parser cannot handle E-values greater than 1


    

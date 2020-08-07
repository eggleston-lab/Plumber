configfile: "envs/config.yaml"

import io
import os
import glob
import pandas as pd
import numpy as np
import pathlib
from snakemake.exceptions import print_exception, WorkflowError

#----SET VARIABLES----#
PROTEIN_DIR = config['protein_dir']
ALIGNMENT_DIR = config['alignment_dir']
OUTPUT_DIR = config['output_dir']
GENEFILE = config['gene_list']
PROTFILE = config['protein_list']
genelist = []
with open(GENEFILE, 'r') as f:
    for line in f:
        genelist.append(line.strip())

SAMPLES = [os.path.basename(f).replace(".proteins.faa", "") for f in glob.glob(PROTEIN_DIR + "/*.proteins.faa")]


#----RULES----#

rule all:
    input:
        hmmbuild =  expand('{base}/{gene}/gene_alignment_profile.hmm', base = ALIGNMENT_DIR, gene=genelist),
        hmmsearch = expand('{base}/hmm_results/{gene}/{sample}.hmmout', base = OUTPUT_DIR, gene = genelist, sample = SAMPLES ),
        hmm_allhits = expand('{base}/hmm_results/{gene}/{sample}.hits.faa', base = OUTPUT_DIR, gene = genelist, sample = SAMPLES ),
        # hmm_mags = expand("{base}/mag_results/{gene}.maghits.contigs.csv", base = OUTPUT_DIR, gene = genelist)


rule hmmbuild:
    input: alignment = ALIGNMENT_DIR + "/{gene}/gene_alignment.aln"
    output: hmm = ALIGNMENT_DIR + "/{gene}/gene_alignment_profile.hmm"
    conda:
        "envs/hmmer.yaml"
    shell:
        """
        hmmbuild {output.hmm} {input.alignment}
        """
rule hmmsearch:
    input:
        proteins = PROTEIN_DIR + "/{sample}.proteins.faa",
        hmm = ALIGNMENT_DIR + "/{gene}/gene_alignment_profile.hmm"
    output:
        hmmout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.hmmout",
	tblout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.tblout"
    params:
        all = "--cpu 2 --tblout"
    conda:
        "envs/hmmer.yaml"
    shell:
        """
        hmmsearch {params.all} {output.tblout} {input.hmm} {input.proteins} > {output.hmmout}
        """

rule get_contig_hits:
    input:
        tblout = OUTPUT_DIR + "/hmm_results/{gene}/{sample}.tblout",
        proteins = PROTEIN_DIR + "/{sample}.proteins.faa"
    output:
        OUTPUT_DIR + "/hmm_results/{gene}/{sample}.hits.faa"
    conda:
        "envs/seqtk.yaml"
    shell:
        """
        cut -d " " -f 1 {input.tblout} | seqtk subseq {input.proteins} - > {output}
        """



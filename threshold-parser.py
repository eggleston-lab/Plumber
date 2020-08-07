#                      ##--- Threshhold Parser ---##                           #
#    gathers a threshold e-value from the command line and returns faa files
#              containing only those hits that pass the filter.
#
#                                Read- ME                                  #
#   1.) May not run correctly if thresh > 1 due to the content of the hmm_out
#   2.) Default E-value cutoff is 0.00005
#   3.) python3 thresh_parser.py <directory containing gene files> <metagenome dir> <cutoff (optional)>

#Requirements
import sys
import fileinput
import os
import yaml
import argparse


#Setup Functions:
def retrieve_prot_list(prot_dir):
    #make an array for all protein dtbase names
    A = []
    for f in os.listdir(prot_dir):
        if f.endswith(".proteins.faa"):
                A.append(os.path.basename(f).replace(".proteins.faa", ""))
        else:
            continue
    return A

#args from config.yaml stored as "data":
data = yaml.load(f, Loader=yaml.FullLoader)

#Read args from command line
parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('threshhold', type = float, default = 0.00005 )
args = parser.parse_args()

directory = data['output_dir']
prot_dir = data['protein_dir']
thresh = args[0]
metalist = retrieve_prot_list(prot_dir)
GENEFILE = data['gene_list']
genelist = []
with open(GENEFILE, 'r') as f:
    for line in f:
        genelist.append(line.strip())


#Functions
def is_number(s):
    #check if a string is a number
    try:
        float(s)
        return True
    except ValueError:
        return False

def index_tbl(hmmout):
    #count how many seq pass the Threshhold
    count = 0
    f = open(directory + "/" + hmmout, "r")
    for line in f:
        if line[0] == " ":
            line = line.strip()
            line2 = line.split()
            if is_number(line2[0]):
                if float(line2[0]) < thresh:
                    count += 1
                else:
                    break
            else:
                continue
        else:
            continue
    print(count)
    return(count*2)
    f.close()

def build_faa(faafile, thresh_count):
    #Create a new file with only the fasta seq which passed the threshhold
    newf = open(directory + "/" + gene + "/" + meta + ".parse.faa", 'w')
    f = open(directory + "/" + faafile)
    n = thresh_count

    for line in f:
        if n>0:
            newf.write(line)
            n = n - 1
        else:
            break

    newf.close()
    f.close()


#Run
for meta in metalist:
    for gene in genelist:
        try:
            f= open(directory + "/" + gene + "/" + meta + ".hmmout", "r")
        except FileNotFoundError:
            pass
        else:
            thresh_count = index_tbl(gene + "/" + meta + ".hmmout")
            build_faa(gene + "/" + meta + ".hits.faa", thresh_count)

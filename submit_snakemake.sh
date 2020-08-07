snakemake   \
        --jobs 40 --use-conda   \
        --cluster-config envs/cluster.yaml --cluster "sbatch --parsable --qos=unlim --partition={cluster.queue} --job-name=Colin.job --mem={cluster.mem}gb --time={cluster.time} --ntasks={cluster.threads} --nodes={cluster.nodes} --mail-user=cahowe@middlebury --mail-type=ALL "

mv *.out slurm_logs/
        

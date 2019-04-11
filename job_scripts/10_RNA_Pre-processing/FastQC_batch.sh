#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 2:00:00
#SBATCH -J fast_qc_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs FastQC to perform quality check on raw RNA-seq data
  
# Load modules
module load bioinfo-tools
module load FastQC

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_raw_data/"
OUT_DIR="$HOME/prj/data/RNA_data/fastqc"

# Init operations
RAW_READS="ERR2*.fastq.gz"

# FastQC v0.11.5
fastqc --threads 4 \
       -o $OUT_DIR \
       -d /scratch/$SLURM_JOB_ID \
       $IN_DIR/$RAW_READS

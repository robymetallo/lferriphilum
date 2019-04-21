#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 00:15:00
#SBATCH --qos=short
#SBATCH -J FastQC_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com


# Load modules
module load bioinfo-tools
module load FastQC

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/DNA_raw_data/"
OUT_DIR="$HOME/prj/data/DNA_data/fastqc"

# Init operations
RAW_READS="ERR2028*.fastq.gz"

# FastQC v0.11.5
for FILE in $IN_DIR/$RAW_READS; do
   fastqc --threads 4 \
          -o $OUT_DIR \
          -d /scratch/$SLURM_JOB_ID \
          $FILE
done

## NOTES:
# FastQC allocates 250MB of RAM per thread.
# 250MB are not enough to process long reads
# such as PacBio reads.
# This can be solved by specifying an higher number of threads
# (even though files are processed one at a time)
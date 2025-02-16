#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 00:15:00
#SBATCH --qos=short
#SBATCH -J Kraken2_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com


# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/DNA_data/trimmed_reads"
OUT_DIR="$HOME/prj/data/DNA_data/kraken2/01_corr_reads"

IN_FILES="LFerr.trimmedReads.fasta.gz"
REPORT_FILE="LFerr_trimmed_reads_kraken2.report"

# Kraken2 2.0.7-beta-bc14b13
command time -v \
kraken2 --threads 6 \
        --report $OUT_DIR/$REPORT_FILE \
        --output /dev/null \
        $IN_DIR/$IN_FILES
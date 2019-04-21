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
WD="$HOME/prj/data/DNA_data/kraken2/02_corr_reads_filter_nitro_proteo"

IN_FILES="LFerr_decontaminated.fastq.bz2"
REPORT_FILE="LFerr_validate_decont_procedure_kraken2.report"

mkdir -p $WD

# Kraken2 2.0.7-beta-bc14b13
command time -v \
kraken2 --threads 6 \
        --report $WD/$REPORT_FILE \
        --output /dev/null \
        $WD/$IN_FILES
#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 00:15:00
#SBATCH --qos=short
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com



# This script runs kraken2 to check for
# reads contamination in fastq.gz files
# containing corrected and trimmed PacBio reads.
# The purpose of this run is to separate reads mapping
# on homo sapiens (main contaminant source)
# from the rest of the reads



# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/DNA_data/trimmed_reads"
OUT_DIR="$HOME/prj/data/DNA_data/kraken2/03_proc_reads_humanDB"
TMP_OUT_DIR=$SNIC_TMP/kraken2_output

MY_DB="$HOME/private/human"
IN_FILES="LSP_ferriphilum.trimmedReads.fasta.gz"
REPORT_FILE="lferriphilum_kraken2.report"
OUT_FILE="lferriphilum_kraken2.out"
CLASS_FILE="lferriphilum_kraken2_classified.fastq"
UNCLASS_FILE="lferriphilum_kraken2_unclassified.fastq"

# Create temp output directory
mkdir -p $TMP_OUT_DIR

# Kraken2 2.0.7-beta-bc14b13
kraken2 --threads 6 \
        --db $MY_DB \
        --report $OUT_DIR/$REPORT_FILE \
        --output $TMP_OUT_DIR/$OUT_FILE \
        --classified-out $TMP_OUT_DIR/$CLASS_FILE \
        --unclassified-out $TMP_OUT_DIR/$UNCLASS_FILE \
        $IN_DIR/$IN_FILES

# Compress FASTQ files using pbzip2
pbzip2 --keep -v -p6 -m2000 -c < $TMP_OUT_DIR/$OUT_FILE > $OUT_DIR/$OUT_FILE.bz2
pbzip2 --keep -v -p6 -m2000 -c < $TMP_OUT_DIR/$CLASS_FILE > $OUT_DIR/$CLASS_FILE.bz2
pbzip2 --keep -v -p6 -m2000 -c < $TMP_OUT_DIR/$UNCLASS_FILE > $OUT_DIR/$UNCLASS_FILE.bz2
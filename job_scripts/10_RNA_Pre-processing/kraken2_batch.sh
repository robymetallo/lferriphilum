#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 03:00:00
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs kraken2 to check for
# reads contamination in fastq.gz files
  
# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_raw_data/"
OUT_DIR="$HOME/prj/data/RNA_data/kraken2"
TMP_OUT_DIR=$SNIC_TMP/kraken2_output

IN_FILES="ERR2*.fastq.gz"
REPORT_FILE="lferriphilum_kraken2.report"
OUT_FILE="lferriphilum_kraken2.out"
UNCLASS_FILE="lferriphilum_kraken2_unclassified.fastq"

# Copy Kraken2 DB to local node
MY_DB_DIR=$SNIC_TMP/Kraken2
MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
mkdir -p $MY_DB
cp -av $KRAKEN2_DEFAULT_DB/* $MY_DB/
mkdir -p $SNIC_TMP/Kraken2_output

# Create temp output directory
mkdir -p $TMP_OUT_DIR

# Kraken2 2.0.7-beta-bc14b13
kraken2 --threads 6 \
        --db $MY_DB \
        --report $OUT_DIR/$REPORT_FILE \
        --output $TMP_OUT_DIR/$OUT_FILE \
        --unclassified-out $TMP_OUT_DIR/$UNCLASS_FILE \
        $IN_DIR/$IN_FILES

# Compress FASTQ files using pbzip2
pbzip2 --keep -v -p6 -c < $TMP_OUT_DIR/$OUT_FILE > $OUT_DIR/$OUT_FILE.bz2
pbzip2 --keep -v -p6 -c < $TMP_OUT_DIR/$UNCLASS_FILE > $OUT_DIR/$UNCLASS_FILE.bz2


#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs kraken2 to check for
# reads contamination in fastq.gz files
  
# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/DNA_raw_data/"
OUT_DIR="$HOME/prj/data/DNA_data/kraken2"

IN_FILES="ERR2028*.fastq.gz"
REPORT_FILE="lferriphilum_kraken2.report"
OUT_FILE="lferriphilum_kraken2.out"
CLASS_FILE="lferriphilum_kraken2_classified.fasq"
UNCLASS_FILE="lferriphilum_kraken2_classified.fastq"

# Copy Kraken2 DB on local node
MY_DB_DIR=$SNIC_TMP/Kraken2
MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
mkdir -p $MY_DB
cp -av $KRAKEN2_DEFAULT_DB/* $MY_DB/


# Kraken2 2.0.7-beta-bc14b13
kraken2 --threads 2 \
        --memory-mapping \
        --db $MY_DB \
        --report $OUT_DIR/$REPORT_FILE \
        --output $OUT_DIR/$OUT_FILE \
        --classified-out $OUT_DIR/$CLASS_FILE \
        --unclassified-out $OUT_DIR/$UNCLASS_FILE \
        $IN_DIR/$IN_FILES


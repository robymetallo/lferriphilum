#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 01:00:00
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com



# This script runs kraken2 to check for
# reads contamination in fastq.gz files containing raw PacBio reads



# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/DNA_raw_data/"
OUT_DIR="$HOME/prj/data/DNA_data/kraken2/single_sample"


IN_FILES="ERR2028*.fastq.gz"
REPORT_FILE="lferriphilum_kraken2.report"

# Copy DB locally
MY_DB_DIR=$SNIC_TMP/Kraken2
    MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
    mkdir -p $MY_DB
    cp -av $KRAKEN2_DEFAULT_DB/* $MY_DB/


for FILE in $IN_DIR/$IN_FILES; do
   BASE_NAME=`basename $FILE .fastq.gz`
# Kraken2 2.0.7-beta-bc14b13
   command time -v \
   kraken2 --threads 6 \
           --db $MY_DB \
           --report $OUT_DIR/$BASE_NAME.report \
           --output dev/null \
           $FILE \
           2>&1 | tee -a $OUT_DIR/canu_tee.log
done;

#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 03:00:00
#SBATCH -J Kraken2_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com


# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_raw_data"
OUT_DIR="$HOME/prj/data/RNA_data/kraken2"

IN_FILES="ERR2*_1.fastq.gz"

# Copy DB locally
MY_DB_DIR=$SNIC_TMP/Kraken2
MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
mkdir -p $MY_DB
cp -av $KRAKEN2_DEFAULT_DB/* $MY_DB/

for FILE in $IN_DIR/$IN_FILES; do
   BASE_NAME=`basename $FILE _1.fastq.gz`
   
   # Kraken2 2.0.7-beta-bc14b13
   command time -v \
   kraken2 --threads 6 \
           --db $MY_DB \
           --paired \
           --report $OUT_DIR/$BASE_NAME.report \
           --output dev/null \
           $IN_DIR/$BASE_NAME*.fastq.gz
done;

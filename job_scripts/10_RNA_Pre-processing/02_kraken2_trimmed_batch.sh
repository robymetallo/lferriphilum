#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 04:00:00
#SBATCH -J Kraken2_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com


# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/prj/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/prj/data/RNA_data/kraken2/trimmed_reads"


# Copy DB locally
MY_DB_DIR="$SNIC_TMP/Kraken2"
MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
mkdir -p "$MY_DB"
cp -av "$KRAKEN2_DEFAULT_DB"/* "$MY_DB/"

# MY_DB="$KRAKEN2_DEFAULT_DB"

mkdir -p "$OUT_DIR"

find $IN_DIR -wholename '*$IN_DIR*/*_OK_1.fastq.gz' | while read FILE; do
   BASE_NAME=`basename "$FILE" _OK_1.fastq.gz`
   BASE_DIR=`dirname "$FILE"`
   
   # Kraken2 2.0.7-beta-bc14b13
   command time -v \
   kraken2 --threads 6 \
           --db "$MY_DB" \
           --report "$OUT_DIR/$BASE_NAME.report" \
           --output dev/null \
           "$BASE_DIR/$BASE_NAME"_OK_*.fastq.gz "$BASE_DIR/$BASE_NAME""_singletons.fastq.gz"
done;

#!/bin/bash

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/decontaminated"

DB="$HOME/Bioinformatics_data/krakenDB/acidithiobacillus"

FWD_READS=("$IN_DIR/ERR2036631/ERR2036631_OK_1.fastq.gz\
 $IN_DIR/ERR2117290/ERR2117290_OK_1.fastq.gz\
 $IN_DIR/ERR2036632/ERR2036632_OK_1.fastq.gz\
 $IN_DIR/ERR2117291/ERR2117291_OK_1.fastq.gz")

REV_READS=("$IN_DIR/ERR2036631/ERR2036631_OK_2.fastq.gz\
 $IN_DIR/ERR2117290/ERR2117290_OK_2.fastq.gz\
 $IN_DIR/ERR2036632/ERR2036632_OK_2.fastq.gz\
 $IN_DIR/ERR2117291/ERR2117291_OK_2.fastq.gz")

SINGL_READS=("$IN_DIR/ERR2036631/ERR2036631_singletons.fastq.gz\
 $IN_DIR/ERR2117290/ERR2117290_singletons.fastq.gz\
 $IN_DIR/ERR2036632/ERR2036632_singletons.fastq.gz\
 $IN_DIR/ERR2117291/ERR2117291_singletons.fastq.gz")

REPORT_FILE="lferriphilum_kraken2.report"

mkdir -p "$OUT_DIR"

for i in $(seq 0 ${#FWD_READS[@]}); do
   BASE_NAME=`basename "${FWD_READS[i]}" _OK_1.fastq.gz`
# Kraken2 2.0.7-beta-bc14b13
   command time -v \
   kraken2 --threads 4 \
           --db "$DB" \
           --paired \
           --report "$OUT_DIR/$BASE_NAME""_PE.report" \
           --unclassified-out "$OUT_DIR/$BASE_NAME""_OK#_clean.fastq" \
           --output dev/null \
           ${FWD_READS[i]} ${REV_READS[i]}
   
   command time -v \
   kraken2 --threads 4 \
           --db "$DB" \
           --report "$OUT_DIR/$BASE_NAME""_singletons.report" \
           --unclassified-out "$OUT_DIR/$BASE_NAME""_singletons_clean.fastq" \
           --output dev/null \
           ${SINGL_READS[i]}

   cd "$OUT_DIR"
   pigz -9 "$OUT_DIR/$BASE_NAME""_OK_1_clean.fastq"
   pigz -9 "$OUT_DIR/$BASE_NAME""_OK_2_clean.fastq"
   pigz -9 "$OUT_DIR/$BASE_NAME""_singletons_clean.fastq"
done;

#  --unclassified-out "$OUT_DIR/$BASE_NAME"_clean.fastq.gz \s
#!/bin/bash 
# This script runs FastQC to perform quality check on raw RNA-seq data
  

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/FastQC/trimmed_reads"

mkdir -p "$OUT_DIR"
REGEXP="((.*)_OK_[12].fastq.gz)|((.*)_singletons.fastq.gz)"

# FastQC v0.11.8
for FILE in `find "$IN_DIR" -type f -regextype posix-egrep -regex "$REGEXP"`; do
   command time -v \
   fastqc --threads $(nproc) \
          -o "$OUT_DIR" \
          "$FILE" \
          2>&1 | tee -a "$OUT_DIR/FastQC_tee.log"
done
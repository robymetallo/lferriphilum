#!/bin/bash 
# This script runs FastQC to perform quality check on raw RNA-seq data
  

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/FastQC/trimmed_reads"

mkdir -p "$OUT_DIR"


# FastQC v0.11.8
for FILE in `find $IN_DIR -type f -name '*_OK_1.fastq.gz'`; do
   DIR=`dirname $FILE`
   BASE_NAME=`basename $FILE _OK_1.fastq.gz`
   TMP_FILE="/tmp/$BASE_NAME""_merged_trimmed.fastq.gz"
   BASE="$DIR/$BASE_NAME"
   cat $BASE"_OK_1.fastq.gz" $BASE"_OK_2.fastq.gz" $BASE"_singletons.fastq.gz" \
   > $TMP_FILE

   command time -v \
   fastqc --threads $(nproc) \
          -o "$OUT_DIR" \
          "$TMP_FILE" \
          2>&1 | tee -a "$OUT_DIR/FastQC_tee.log"
   rm $TMP_FILE
done
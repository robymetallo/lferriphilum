#!/bin/bash 
# This script runs FastQC to perform quality check on raw RNA-seq data
  

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/raw_data/RNA_raw_data"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/FastQC/raw_reads"

RAW_READS="ERR2*.fastq.gz"

mkdir -p "$OUT_DIR"

# FastQC v0.11.8
command time -v \
fastqc --threads $(nproc) \
       -o "$OUT_DIR" \
       "$IN_DIR/"$RAW_READS \
       2>&1 | tee "$OUT_DIR/FastQC_tee.log"

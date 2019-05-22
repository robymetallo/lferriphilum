#!/bin/bash

SALMON_IDX_DIR="$HOME/Bioinformatics_data/salmon_idx/salmon_idx_genome_assembly"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/genome_assembly/without_replicates"
IDX="LFerr_genome_assembly"
TRANS_ANNOT="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/LFerr_merged.ffn"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"

mkdir -p "$SALMON_IDX_DIR"
mkdir -p "$OUT_DIR"

cd "$SALMON_IDX_DIR"

salmon index -t "$TRANS_ANNOT" \
             -i "$IDX" \
             -k 31

FWD_READS=`find "$READS_DIR" -wholename '*/ERR*/*OK_1.fastq.gz' | tr '\n' ' '~`
REV_READS=`find "$READS_DIR" -wholename '*/ERR*/*OK_2.fastq.gz' | tr '\n' ' '~`


for FILE in $FWD_READS; do
   BASE_NAME=`basename "$FILE" _OK_1.fastq.gz`
   BASE_DIR=`dirname "$FILE"`

   command time -v \
   salmon quant -i "$SALMON_IDX_DIR/$IDX" \
               -l A \
               -1 "$FILE" \
               -2 "$BASE_DIR/$BASE_NAME"_OK_2.fastq.gz \
               -p $(nproc) \
               --validateMappings \
               --gcBias \
               -o "$OUT_DIR/$BASE_NAME"_salmon.out \
               2>&1 | tee "$OUT_DIR/$BASE_NAME"_salmon_tee.log
done
#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBMerge"


find $IN_DIR -wholename '*_OK_1.fastq.gz' | while read FILE; do
   BASE_NAME=`basename "$FILE" _OK_1.fastq.gz`
   BASE_DIR=`dirname "$FILE"`

   FWD_IN="$FILE"
   REV_IN="$BASE_DIR/$BASE_NAME""_OK_2.fastq.gz"

   WD="$OUT_DIR/$BASE_NAME"
   mkdir -p "$WD"

   OUT_MERGED="$WD/$BASE_NAME""_merged.fastq.gz"
   FWD_OUT_UNMERGED="$WD/$BASE_NAME"_OK_1_unmerged.fastq.gz
   REV_OUT_UNMERGED="$WD/$BASE_NAME"_OK_2_unmerged.fastq.gz

   command time -v \
   bbmerge-auto.sh in="$FWD_IN" in2="$REV_IN" \
                  out="$OUT_MERGED" \
                  outu="$FWD_OUT_UNMERGED" outu2="$REV_OUT_UNMERGED" \
                  rem \
                  k=62 \
                  extend2=50 \
                  2>&1 | tee "$WD/BBMerge_$BASE_NAME"_tee.log
done;
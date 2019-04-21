#!/bin/bash
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/merged"
OUT_FWD="LFer_RNA-Seq_FWD_merged.fastq.bz2"
OUT_REV="LFer_RNA-Seq_REV_merged.fastq.bz2"
SINGLTN="LFer_RNA-Seq_singletons.fastq.bz2"

mkdir -p $OUT_DIR

find $IN_DIR -name '*_OK_1.fastq.bz2' -exec bzcat {} \; | pbzip2 > $OUT_DIR/$OUT_FWD
find $IN_DIR -name '*_OK_2.fastq.bz2' -exec bzcat {} \; | pbzip2 > $OUT_DIR/$OUT_REV
find $IN_DIR -name '*singletons.fastq.bz2' -exec bzcat {} \; | pbzip2 > $OUT_DIR/$SINGLTN
#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBMerge/"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBMerge/dedup"

IN_FILE="LFer_RNA-Seq_clumped_merged.fastq.bz2"
OUT_FILE="LFer_RNA-Seq_dedup_merged.fastq.bz2"

mkdir -p $OUT_DIR

clumpify.sh dedupe \
            in=$IN_DIR/$IN_FILE \
            out=$OUT_DIR/$OUT_FILE \
            -Xmx14g \
            2>&1 | tee $OUT_DIR/BBMerge_dedup_tee.log

IN_FILE="LFer_RNA-Seq_FWD_clumped_unmerged.fastq.bz2"
OUT_FILE="LFer_RNA-Seq_FWD_dedup_unmerged.fastq.bz2"

clumpify.sh dedupe \
            in=$IN_DIR/$IN_FILE \
            out=$OUT_DIR/$OUT_FILE \
            -Xmx14g \
            2>&1 | tee -a $OUT_DIR/BBMerge_dedup_tee.log

IN_FILE="LFer_RNA-Seq_REV_clumped_unmerged.fastq.bz2"
OUT_FILE="LFer_RNA-Seq_REV_dedup_unmerged.fastq.bz2"

clumpify.sh dedupe \
            in=$IN_DIR/$IN_FILE \
            out=$OUT_DIR/$OUT_FILE \
            -Xmx14g \
            2>&1 | tee -a $OUT_DIR/BBMerge_dedup_tee.log

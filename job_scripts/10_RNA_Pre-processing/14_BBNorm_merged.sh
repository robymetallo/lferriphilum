#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/01_Merged"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBNorm/merged"

READS_IN="LFer_RNA-Seq_FWD_clumped_merged.fastq.bz2"
READS_OUT="LFer_RNA-Seq_FWD_clumped_merged_norm.fastq.bz2"

TMPDIR="$HOME/BBNorm_tmp"
mkdir $TMPDIR

command time -v bbnorm.sh in=$IN_DIR/$READS_IN \
                          out=$OUT_DIR/$READS_OUT \
                          target=50 \
                          min=15 \
                          prefilter \
                          fixspikes \
                          tmpdir=$TMPDIR \
                          -Xmx12g \
                          2>&1 | tee $OUT_DIR/BBNorm_tee.log

rm -r $TMPDIR
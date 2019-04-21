#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/merged"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBNorm/PE"

FWD_IN="LFer_RNA-Seq_FWD_clumped.fastq.bz2"
REV_IN="LFer_RNA-Seq_REV_clumped.fastq.bz2"
SNG_IN="LFer_RNA-Seq_singletons_clumped.fastq.bz2"

FWD_OUT="LFer_RNA-Seq_FWD_clumped_norm.fastq.bz2"
REV_OUT="LFer_RNA-Seq_REV_clumped_norm.fastq.bz2"
SNG_OUT="LFer_RNA-Seq_singletons_clumped_norm.fastq.bz2"

# command time -v bbnorm.sh in=$IN_DIR/$FWD_IN \
#                           in2=$IN_DIR/$REV_IN \
#                           out=$OUT_DIR/$FWD_OUT \
#                           out2=$OUT_DIR/$REV_OUT \
#                           target=100 \
#                           min=10 \
#                           prefilter \
#                           fixspikes \
#                           -Xmx12g \
#                           2>&1 | tee $OUT_DIR/BBNorm_PE_tee.log

command time -v bbnorm.sh in=$IN_DIR/$SNG_IN \
                          out=$OUT_DIR/$SNG_OUT \
                          target=100 \
                          min=10 \
                          prefilter \
                          fixspikes \
                          -Xmx12g \
                          2>&1 | tee $OUT_DIR/BBNorm_SNG_tee.log
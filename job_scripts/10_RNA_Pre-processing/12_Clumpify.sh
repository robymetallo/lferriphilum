#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/merged"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/merged"


FWD_IN="LFer_RNA-Seq_FWD.fastq.bz2"
REV_IN="LFer_RNA-Seq_REV.fastq.bz2"
SNG_IN="LFer_RNA-Seq_singletons.fastq.bz2"
FWD_OUT="LFer_RNA-Seq_FWD_clumped.fastq.bz2"
REV_OUT="LFer_RNA-Seq_REV_clumped.fastq.bz2"
SNG_OUT="LFer_RNA-Seq_singletons_clumped.fastq.bz2"


TMPDIR="$HOME/clumpify_tmp"
mkdir $TMPDIR


clumpify.sh in1=$IN_DIR/$FWD_IN \
            in2=$IN_DIR/$REV_IN \
            out1=$OUT_DIR/$FWD_OUT \
            out2=$OUT_DIR/$REV_OUT \
            tmpdir=$TMPDIR \
            usetmpdir \
            groups=auto \
            blocksize=900 \
            -Xmx13g \
            reorder

clumpify.sh in=$IN_DIR/$SNG_IN \
            out=$OUT_DIR/$SNG_OUT \
            tmpdir=$TMPDIR \
            usetmpdir \
            groups=auto \
            blocksize=900 \
            -Xmx13g \
            reorder

rm -r $TMPDIR
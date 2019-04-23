#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBNorm/PE"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/rnaQUAST/StringTie"

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
TRANS_CONTIGS="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/rnaSPAdes/soft_filtered_transcripts.fasta"
FWD_READS="LFer_RNA-Seq_FWD_clumped_norm.fastq.gz"
REV_READS="LFer_RNA-Seq_REV_clumped_norm.fastq.gz"
UNP_READS="LFer_RNA-Seq_singletons_clumped_norm.fastq.gz"

mkdir -p $OUT_DIR

/usr/bin/python2 \
$HOME/Bioinformatics_Programs/rnaQUAST-1.5.2/\
rnaQUAST.py -r $REF_GENOME \
            --prokaryote \
            -c $TRANS_CONTIGS \
            -1 $IN_DIR/$FWD_READS \
            -2 $IN_DIR/$REV_READS \
            -s $IN_DIR/$UNP_READS \
            -o $OUT_DIR \
            --threads 4 \
            2>&1 | tee $OUT_DIR/rnaQUAST_tee.log

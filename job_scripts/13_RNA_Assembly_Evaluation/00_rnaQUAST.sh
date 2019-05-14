#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_dedup"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/rnaQUAST"

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
TRANS_ASSEMBLY="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
FWD_READS="LFerr_OK_1_merged_renamed.fastq.gz"
REV_READS="LFerr_OK_2_merged_renamed.fastq.gz"

mkdir -p $OUT_DIR

/usr/bin/python2 \
$HOME/Bioinformatics_tools/rnaQUAST-1.5.2/\
rnaQUAST.py -r $REF_GENOME \
            --prokaryote \
            -c $TRANS_ASSEMBLY \
            -1 $IN_DIR/$FWD_READS \
            -2 $IN_DIR/$REV_READS \
            -o $OUT_DIR \
            --threads $(nproc) \
            2>&1 | tee $OUT_DIR/rnaQUAST_tee.log

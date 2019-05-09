#!/bin/bash

SALMON_IDX_DIR="$HOME/Bioinformatics_data/salmon_idx"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/salmon/00_trinity_denovo_assembly"
IDX="LFerr_trinity_denovo"
TRANS_ASSEMBLY="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"

mkdir $SALMON_IDX_DIR
cd $SALMON_IDX_DIR
mkdir $OUT_DIR

salmon index -t $TRANS_ASSEMBLY \
             -i $IDX \
             -k 31

FWD_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_1.fastq.gz' | tr '\n' ' '~`
REV_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_2.fastq.gz' | tr '\n' ' '~`


salmon quant -i $SALMON_IDX_DIR/$IDX \
             -l A \
             -1 $FWD_READS \
             -2 $REV_READS \
             -p 4 \
             --validateMappings \
             -o $OUT_DIR/salmon.out \
             2>&1 | tee $OUT_DIR/salmon_tee.log
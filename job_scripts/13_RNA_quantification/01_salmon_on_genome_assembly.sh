#!/bin/bash

SALMON_IDX_DIR="$HOME/Bioinformatics_data/salmon_idx"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/salmon/01_genome_assembly"
IDX="LFerr_genome_assembly"
TRANS_ANNOT="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/LFerr_merged.ffn"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"

mkdir $SALMON_IDX_DIR
cd $SALMON_IDX_DIR
mkdir $OUT_DIR

salmon index -t $TRANS_ANNOT \
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
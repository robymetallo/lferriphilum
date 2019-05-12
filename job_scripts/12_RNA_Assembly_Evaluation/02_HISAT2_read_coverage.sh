#!/bin/bash

REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr_trinity"
DB_PREFIX="LFerr_trinity"
# Build DB

mkdir -p $DB_DIR

hisat2-build $REF_GENOME \
             $DB_DIR/$DB_PREFIX \
             2>&1 | tee $DB_DIR/hisat2-build_tee.log

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/"

FWD_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_1.fastq.gz' | tr '\n' ' '~`
REV_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_2.fastq.gz' | tr '\n' ' '~`


HISAT2_INDEXES=$DB_DIR

# Align PE
hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/histat2.summary" \
       --met-file $OUT_DIR"/histat2.log" \
       --met 5 \
       --new-summary \
       --threads 4 \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x $DB_DIR/$DB_PREFIX \
       -1 $IN_DIR/$FWD_READS \
       -2 $IN_DIR/$REV_READS \
       > /dev/null

#!/bin/bash

REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr"
DB_PREFIX="LFerr_genome_assembly"
# Build DB

mkdir -p $DB_DIR

hisat2-build $REFERENCE \
             $DB_DIR/$DB_PREFIX \
             2>&1 | tee $DB_DIR/hisat2-build_tee.log


READS_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/HISAT2/investigating_low_mapping_rates"

mkdir -p $OUT_DIR

FWD_READS="$READS_DIR/ERR2036631/ERR2036631_OK_1.fastq.gz\
,$READS_DIR/ERR2117290/ERR2117290_OK_1.fastq.gz\
,$READS_DIR/ERR2036632/ERR2036632_OK_1.fastq.gz\
,$READS_DIR/ERR2117291/ERR2117291_OK_1.fastq.gz"

REV_READS="$READS_DIR/ERR2036631/ERR2036631_OK_2.fastq.gz\
,$READS_DIR/ERR2117290/ERR2117290_OK_2.fastq.gz\
,$READS_DIR/ERR2036632/ERR2036632_OK_2.fastq.gz\
,$READS_DIR/ERR2117291/ERR2117291_OK_2.fastq.gz"


# Align PE
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/histat2_genome_assembly_coverage.summary" \
       --met-file $OUT_DIR"/histat2_genome_assembly_coverage.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x $DB_DIR/$DB_PREFIX \
       -1 $FWD_READS \
       -2 $REV_READS \
       1> /dev/null | tee $OUT_DIR"/histat2_genome_assembly_coverage.summary.log"

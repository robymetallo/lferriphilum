#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_dedup/"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BWA"

FWD_READS="LFerr_OK_1_merged.fastq.gz"
REV_READS="LFerr_OK_2_merged.fastq.gz"
SING_READS="LFerr_singletons_merged.fastq.gz"

BWA_DB="$HOME/Bioinformatics_data/bwa_db/LFerriphilum"
DB_PREFIX="LFerr"
REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"

mkdir -p $OUT_DIR"/PE"
mkdir -p $OUT_DIR"/singletons"
mkdir -p $BWA_DB


DB=$BWA_DB/$DB_PREFIX

# BWA v0.7.17

# Build DB
bwa index $REFERENCE -p $DB

# Align PE
bwa mem -t 4 \
        -v 3 \
        $DB \
        $IN_DIR/$FWD_READS \
        $IN_DIR/$REV_READS \
        2> $OUT_DIR"/PE/BWA_PE.log" | \
samtools view -u | \
samtools sort -@2 \
              -m 2G \
              -l 9 \
              -o $OUT_DIR"/PE/LFerr_BWA_PE.bam"


# Align singletons
bwa mem -t 4 \
        -v 3 \
        $DB \
        $IN_DIR/$SING_READS \
        2> $OUT_DIR"/singletons/BWA_singletons.log" | \
samtools view -u | \
samtools sort -@4 \
              -m 1750M \
              -l 9 \
              -o $OUT_DIR"/singletons/LFerr_BWA_singletons.bam"

samtools merge $OUT_DIR/"LFerr_merged_for_trans_assembly.bam" \
               $OUT_DIR"/PE/*.bam" \
               $OUT_DIR"/singletons/*.bam"

samtools sort -@4 \
              -m 1750M \
              -l 9 \
              -o $OUT_DIR"LFerr_merged_for_trans_assembly_sorted.bam" \
              $OUT_DIR/"LFerr_merged_for_trans_assembly.bam"

rm $OUT_DIR/"LFerr_merged_for_trans_assembly.bam"
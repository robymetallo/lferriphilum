#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/00_dedup"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BWA/singletons"


BWA_DB="$HOME/Bioinformatics_data/bwa_db/LFerriphilum"
DB_PREFIX="LFerr"
REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"

mkdir -p $OUT_DIR
mkdir -p $BWA_DB


DB=$BWA_DB/$DB_PREFIX

# BWA v0.7.17

# Build DB
bwa index $REFERENCE -p $DB

# Align singletons
for FILE in $IN_DIR/*_singletons.fastq.gz;
do
   BASE_NAME=`basename $FILE _singletons.fastq.gz`
   bwa mem -t $(nproc) \
           -v 3 \
           $DB \
           $FILE 2> $OUT_DIR/$BASE_NAME"_singletons.log" | \
   samtools view -u | \
   samtools sort -@$(nproc) \
                 -m 1250M \
                 -l 9 \
                 -o $OUT_DIR/$BASE_NAME"_singletons.bam"
done;

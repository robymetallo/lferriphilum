#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J BWA_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs BWA to align Illumina reads to the newly assembled contig

# Load modules
module load bioinfo-tools
module load bwa/0.7.17
module load samtools/1.9

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_trimmed_reads"
OUT_DIR="$HOME/prj/data/RNA_data/BWA_PE_alignment"
TMP_DIR=$SNIC_TMP/BWA

BWA_DB="$HOME/private/BWA_dbdir/LFerriphilum"
DB_PREFIX="LFerr"
REFERENCE="$HOME/prj/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
PEXT1="P1.trim.fastq.gz"
PEXT2="P2.trim.fastq.gz"
SEXT1="S1.trim.fastq.gz"
SEXT2="S2.trim.fastq.gz"

mkdir -p $OUT_DIR
mkdir -p $BWA_DB
mkdir -p $TMP_DIR

DB=$BWA_DB/$DB_PREFIX

# BWA v0.7.17

# Build DB
bwa index $REFERENCE -p $BWA_DB/$DB_PREFIX

# Align reads using DB built on the reference sequence
for FILE in $IN_DIR/*P1.trim.fastq.gz;
do
   BASE_NAME=`basename $FILE P1.trim.fastq.gz`
   FWD_READS=$IN_DIR/$BASE_NAME$PEXT1
   REV_READS=$IN_DIR/$BASE_NAME$PEXT2
   bwa mem -t 4 \
           -v 3 \
           $DB \
           $FWD_READS \
           $REV_READS 2> $OUT_DIR/$BASE_NAME"PE.log" | \
   samtools view -u | \
   samtools sort -@4 \
                 -m 2G \
                 -l 9 \
                 -T $TMP_DIR \
                 -o $OUT_DIR/$BASE_NAME"PE.bam"


   SINGLETONS=$TMP_DIR/$BASE_NAME"singletons.fastq"
   zcat $IN_DIR/$BASE_NAME$SEXT1 $IN_DIR/$BASE_NAME$SEXT2 > $SINGLETONS
   
   bwa mem -t 4 \
           -v 2 \
           $DB \
           $SINGLETONS 2> $OUT_DIR/$BASE_NAME"singletons.log" | \
   samtools view -u | \
   samtools sort -@4 \
                 -m 2G \
                 -l 9 \
                 -T $TMP_DIR \
                 -o $OUT_DIR/$BASE_NAME"singletons.bam"


done;
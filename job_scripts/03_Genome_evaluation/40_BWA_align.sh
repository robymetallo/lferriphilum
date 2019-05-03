#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 01:00:00
#SBATCH -J BWA_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs BWA to align Illumina reads to the newly assembled contig

# Load modules
module load bioinfo-tools
module load bwa/0.7.17
module load samtools/1.9

# Input/Output Dir
IN_DIR="$HOME/prj/analysis/DNA/01_processed_reads"
OUT_DIR="$HOME/prj/data/DNA_data/BWA_alignment"
TMP_DIR=$SNIC_TMP/BWA

BWA_DB="$HOME/private/BWA_dbdir/LFerriphilum"
DB_PREFIX="LFerr"
REFERENCE="$HOME/prj/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
READS="02_decontaminated_reads.fasta.bz2"

mkdir -p $OUT_DIR
mkdir -p $BWA_DB
mkdir -p $TMP_DIR

DB=$BWA_DB/$DB_PREFIX

# BWA v0.7.17

# Build DB
bwa index $REFERENCE -p $BWA_DB/$DB_PREFIX

# Align reads using DB built on the reference sequence
BASE_NAME=`basename $IN_DIR/$READS .fasta.bz2`
pbzip2 -cd < $IN_DIR/$READS > $TMP_DIR/$BASE_NAME".fasta"

bwa mem -t 4 \
        -v 3 \
        $DB \
        $TMP_DIR/$BASE_NAME".fasta" 2> $OUT_DIR/$BASE_NAME".log" | \
samtools view -u | \
samtools sort -@4 \
              -m 2G \
              -l 9 \
              -T $TMP_DIR \
              -o $OUT_DIR/$BASE_NAME".bam"
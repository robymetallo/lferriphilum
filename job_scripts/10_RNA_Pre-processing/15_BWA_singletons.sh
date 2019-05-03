#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J BWA_sing_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs BWA to align Illumina reads to the newly assembled contig

# Load modules
module load bioinfo-tools
module load bwa/0.7.17
module load samtools/1.9

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_dedup/"
OUT_DIR="$HOME/prj/data/RNA_data/BWA/singletons"
TMP_DIR=$SNIC_TMP/BWA

BWA_DB="$HOME/private/BWA_dbdir/LFerriphilum"
DB_PREFIX="LFerr"
REFERENCE="$HOME/prj/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"

mkdir -p $OUT_DIR
mkdir -p $BWA_DB
mkdir -p $TMP_DIR

DB=$BWA_DB/$DB_PREFIX

# BWA v0.7.17

# Build DB
bwa index $REFERENCE -p $BWA_DB/$DB_PREFIX

# Align singletons
for FILE in $IN_DIR/*_singletons.fastq.gz;
do
   BASE_NAME=`basename $FILE _singletons.fastq.gz`
   bwa mem -t 4 \
           -v 3 \
           $DB \
           $FILE 2> $OUT_DIR/$BASE_NAME"_singletons.log" | \
   samtools view -u | \
   samtools sort -@4 \
                 -m 2G \
                 -l 9 \
                 -T $TMP_DIR \
                 -o $OUT_DIR/$BASE_NAME"_singletons.bam"
done;
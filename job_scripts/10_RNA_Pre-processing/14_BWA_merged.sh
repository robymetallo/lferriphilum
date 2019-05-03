#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 10:00:00
#SBATCH -J BWA_mrg_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs BWA to align Illumina reads to the newly assembled contig

# Load modules
module load bioinfo-tools
module load bwa/0.7.17
module load samtools/1.9

# Input/Output Dir
IN_DIR="$HOME/prj/analysis/RNA/01_processed_reads/01_merged"
OUT_DIR="$HOME/prj/data/RNA_data/BWA/merged"
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

# Align merged reads
for FILE in $IN_DIR/*_merged.fastq.gz;
do
   BASE_NAME=`basename $FILE .fastq.gz`
   bwa mem -t 4 \
           -v 3 \
           $DB \
           $FILE  2> $OUT_DIR/$BASE_NAME"_BWA.log" | \
   samtools view -u | \
   samtools sort -@4 \
                 -m 2G \
                 -l 9 \
                 -T $TMP_DIR \
                 -o $OUT_DIR/$BASE_NAME".bam"
done;

# Align unmerged reads
for FILE in $IN_DIR/*_FWD_unmerged.fastq.gz;
do
   BASE_NAME=`basename $FILE _FWD_unmerged.fastq.gz`
   FWD_READS=$FILE
   REV_READS=$IN_DIR/$BASE_NAME"_REV_unmerged.fastq.gz"
   bwa mem -t 4 \
           -v 3 \
           $DB \
           $FWD_READS \
           $REV_READS 2> $OUT_DIR/$BASE_NAME"_unmerged.log" | \
   samtools view -u | \
   samtools sort -@4 \
                 -m 2G \
                 -l 9 \
                 -T $TMP_DIR \
                 -o $OUT_DIR/$BASE_NAME"_unmerged.bam"
done;

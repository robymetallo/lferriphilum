#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 00:05:00
#SBATCH --qos=short
#SBATCH -J BWA_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs Satsuma to perform Synteny analysis between the genome assembled by me and the reference

module load bioinfo-tools
module load satsuma2

OUT_DIR="$HOME/prj/data/DNA_data/Satsuma2"

CONTIG="$HOME/prj/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
REFERENCE="$HOME/prj/data/raw_data/reference/OBMB01.fasta"

mkdir -p $OUT_DIR

SatsumaSynteny2 -threads 8 \
                -q $CONTIG \
                -t $REFERENCE \
                -o $OUT_DIR \
                 2>&1 | tee $OUT_DIR/SatsumaSynteny2_tee.log
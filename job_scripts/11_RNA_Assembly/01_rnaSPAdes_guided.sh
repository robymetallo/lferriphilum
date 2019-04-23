#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 02:00:00
#SBATCH -J rnaSPAdes_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs rnaSPAdes to assemble the transcriptome

module load bioinfo-tools
module load spades/3.12.0

IN_DIR="$HOME/prj/analysis"
OUT_DIR="$HOME/prj/data/RNA_data/rnaSPAdes/PE_guided"
TMP_OUT=$SNIC_TMP/rnaspades

mkdir -p $TMP_OUT
mkdir -p $OUT_DIR

REFERENCE="12_LFerr_without_contaminants_main_contig.fasta"
FWD_READS="LFer_RNA-Seq_FWD_clumped_norm.fastq.gz"
REV_READS="LFer_RNA-Seq_REV_clumped_norm.fastq.gz"
UNP_READS="LFer_RNA-Seq_singletons_clumped_norm.fastq.gz"

command time -v rnaspades.py \
                -o $OUT_DIR \
                -1 $IN_DIR/$FWD_READS \
                -2 $IN_DIR/$REV_READS \
                -s $IN_DIR/$UNP_READS \
                --trusted-contigs $IN_DIR/$REFERENCE
                g
                -t 6 \
                -m 38 \
                --tmp-dir $TMP_OUT \
                2>&1 | tee $OUT_DIR/rnaSPAdes_tee.log
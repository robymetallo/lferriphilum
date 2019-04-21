#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 24:00:00
#SBATCH -J Trinity_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs Trinity to pre-process and assemble the transcriptome
  
# Load modules
module load bioinfo-tools
module load trinity/2.8.2
module load samtools/1.9
module load Salmon/0.9.1
module load jellyfish/2.2.6

# Input/Output Dir
IN_DIR="$HOME/prj/analysis"
OUT_DIR="$HOME/prj/data/RNA_data/Trinity"
TMP_OUT=$SNIC_TMP/trinity

FWD_READS="LFer_RNA-Seq_FWD_clumped_norm_converted.fastq.bz2"
REV_READS="LFer_RNA-Seq_REV_clumped_norm_converted.fastq.bz2"

mkdir -p $TMP_OUT

# Trinity v2.8.2
command time -v Trinity --seqType fq --max_memory 64G  \
                --left $IN_DIR/$FWD_READS \
                --right $IN_DIR/$REV_READS \
                --output $TMP_OUT \
                --CPU 10 \
                --no_normalize_reads \
                2>&1 | tee $OUT_DIR/Trinity_tee.log

cp -r $TMP_OUT/*Trinity.fasta $OUT_DIR/

command time -v tar --use-compress-program=pbzip2 -cvf \
                $OUT_DIR/Trinity_WD.tar.bz2 \
                $TMP_OUT \
                2>&1 | tee $OUT_DIR/tar_tee.log

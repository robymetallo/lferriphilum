#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J circlator_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs circlator to circularize
# the contigs produced by canu
  
# Load modules
module load bioinfo-tools
module load AMOS/3.1.0
module load bwa/0.7.17
module load prodigal/2.6.3
module load samtools/1.9
module load MUMmer/3.23     # This version is required by AMOS
module load canu/1.7
module load spades/3.12.0

# Input/Output Dir
IN_DIR="$HOME/prj/analysis"
OUT_DIR="$HOME/prj/data/DNA_data/circlator"
CORR_READS="$HOME/prj/data/DNA_data/corrected_reads/LSP_ferriphilum.correctedReads.fasta.gz"
LOG_PATH="$HOME/prj/data/DNA_data/circlator_batch_job_07-04-2019.log"

# Settings:
CONTIG_IN="LSP_ferriphilum_polished.contigs.fasta"

# circlator v1.5.5
command time -v circlator all --assembler canu $IN_DIR/$CONTIG_IN $CORR_READS $OUT_DIR 2>&1 | tee -a $LOG_PATH

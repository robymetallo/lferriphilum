#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 12:00:00
#SBATCH -J canu_corr_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script assembles a genome with canu
# using the reads from fastq.gz files

# Load modules
module load bioinfo-tools
module load canu

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/DNA_raw_data"
OUT_DIR="$HOME/prj/data/DNA_data/corrected_reads"

# Settings:
PREFIX="LSP_ferriphilum"                # File name prefix of intermediate and output files
GENOME_SIZE="2.6m"                      # Expected genome size
STOP_ON_RQ="false"                      # stopOnReadQuality - Don't stop assembly
                                        # in case of low read quality
IN_FILES="ERR2028*.fastq.gz"            # This expression will be expanded to all fastq.gz
                                        # files in a directory

# This script was run locally using canu 1.8
canu -correct -p $PREFIX \
     genomeSize=$GENOME_SIZE \
     stopOnReadQuality=$STOP_ON_RQ \
     -d $OUT_DIR \
     -pacbio-raw $IN_DIR/$IN_FILES
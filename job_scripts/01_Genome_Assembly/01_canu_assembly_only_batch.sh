#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J canu_trim_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script assembles a genome with canu
# using the reads from fastq.gz files

# Load modules
module load bioinfo-tools
module load canu

# Input/Output Dir
IN_DIR="$HOME/prj/data/DNA_data/kraken2/03_proc_reads_humanDB"
OUT_DIR="$HOME/prj/data/DNA_data/assembly/01_without_contaminants"

# Settings:
PREFIX="LSP_ferriphilum"                # File name prefix of intermediate and output files
GENOME_SIZE="2.6m"                      # Expected genome size
                                        # Setting taken from the doc
IN_FILES="lferriphilum_kraken2_unclassified.fastq.bz2"

# This script was run locally using canu 1.8
canu -assemble -p $PREFIX \
     genomeSize=$GENOME_SIZE \
     -d $OUT_DIR \
     -pacbio-corrected $IN_DIR/$IN_FILES
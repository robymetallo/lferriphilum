#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J circlator_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs circlator to circulatize
# the contigs produced by canu
  
# Load modules
module load bioinfo-tools
module load AMOS/3.0.0
module load bwa/0.7.17
module load prodigal/2.6.3
module load samtools/1.9
module load MUMmer/3.23     # Version required by AMOS
module load canu/1.7
module load spades/3.12.0
module load perl_modules    # Required by minimus2

# Input/Output Dir
IN_DIR="$HOME/prj/analysis"
OUT_DIR="$HOME/prj/data/DNA_data/circlator"

# Settings:
CONTIG_IN="LSP_ferriphilum_polished.contigs.fasta"

# circlator v1.5.5
circlator minimus2 $IN_DIR/$CONTIG_IN \
                   "LSP_ferriphilum_polished_circ"

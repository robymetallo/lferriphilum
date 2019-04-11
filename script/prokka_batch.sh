#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 01:00:00
#SBATCH -J prokka_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs prokka to annotate the newly assembled genome
  
# Load modules
module load bioinfo-tools
module load prokka

# Input/Output Dir
CONTIG="$HOME/prj/analysis/LSP_ferriphilum_main_contig.fasta"
OUT_DIR="$HOME/prj/data/DNA_data/prokka"

# --usegenus   Use genus-specific BLAST databases
# --rfam       Enable searching for ncRNAs with Infernal+Rfam

# Prokka v1.12-12547ca

prokka --cpus 4
       --gram neg \
       --genus Leptospirillum \
       --usegenus \
       --rfam \
       -o $OUT_DIR \
       $CONTIG



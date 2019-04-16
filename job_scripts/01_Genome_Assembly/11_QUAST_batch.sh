#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:05:00
#SBATCH -J QUAST_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com
#SBATCH --qos=short

# This script runs QUAST to evaluate the assembly produced by canu
  
# Load modules
module load bioinfo-tools
module load quast


# Input/Output Dir
IN_DIR="$HOME/prj/data/DNA_data/assembly/01_without_contaminants"
OUT_DIR="$HOME/prj/data/DNA_data/QUAST/01_without_contaminants/"

# Settings:
REFERENCE="$HOME/prj/data/raw_data/reference/OBMB01.fasta"
QUAST_PATH="/sw/apps/bioinfo/quast/4.5.4/rackham/bin/quast.py"

# Contains only the longest contig
CONTIG="LSP_ferriphilum.contigs.fasta"

# QUAST v4.5.4
python3 $QUAST_PATH \
        -t 4 \
        --circos \
        --glimmer \
        --rna-finding \
        --conserved-genes-finding \
        -o $OUT_DIR/polished \
        -r $REFERENCE \
        --pacbio \
        $CONTIG

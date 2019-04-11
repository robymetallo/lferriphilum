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
IN_DIR="$HOME/prj/data/DNA_data/assembly"
OUT_POL_DIR="$HOME/prj/data/DNA_data/QUAST"

# Settings:
REFERENCE="$HOME/prj/data/raw_data/reference/OBMB01.fasta"
QUAST_PATH="/sw/apps/bioinfo/quast/4.5.4/rackham/bin/quast.py"

# AAAAA and GGGG contigs have been removed
CONTIG_POLISHED="LSP_ferriphilum_polished.contigs.fasta"

# Contains only the longest contig
CONTIG_MAIN="LSP_ferriphilum_main_contig.fasta"

# QUAST v4.5.4
python3 $QUAST_PATH \
        -t 4 \
        --glimmer \
        -o $OUT_DIR/polished \
        -r $REFERENCE \
        $CONTIG_POLISHED

# QUAST v4.5.4
python3 $QUAST_PATH \
        -t 4 \
        --glimmer \
        -o $OUT_DIR/main \
        -r $REFERENCE \
        $CONTIG_MAIN

python3 quast.py -o $HOME/Bioinformatics_data/data/DNA_data/QUAST/polished \
         -t 4 \
         --glimmer \
         -r $HOME/Bioinformatics_data/data/raw_data/reference/OBMB01.fasta \
         "$HOME/Bioinformatics_data/analysis/LSP_ferriphilum_polished.contigs.fasta"


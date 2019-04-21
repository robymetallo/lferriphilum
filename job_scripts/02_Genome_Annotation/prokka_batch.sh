#!/bin/bash -l

# Input/Output Dir
CONTIG="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/prokka/"

# --usegenus   Use genus-specific BLAST databases
# --rfam       Enable searching for ncRNAs with Infernal+Rfam
PREFIX="LFerr"

# Prokka v1.13.3
prokka --cpus 4 \
       --gram neg \
       --genus Leptospirillum \
       --usegenus \
       --rfam \
       --force \
       --prefix $PREFIX \
       -o $OUT_DIR \
       $CONTIG
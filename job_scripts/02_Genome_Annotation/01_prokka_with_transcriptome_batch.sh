#!/bin/bash -l

# Input/Output Dir
CONTIG="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/prokka_with_proteins"

# --usegenus   Use genus-specific BLAST databases
# --rfam       Enable searching for ncRNAs with Infernal+Rfam
PREFIX="LFerr_with_proteins"
PROTEINS="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/select_best_ORFs/LFerr_Transcriptome_Assembly_Trinity.fasta.transdecoder.cds"

# export PATH=$PATH:$HOME/GitHub/prokka/bin
# export PATH=$PATH:$HOME/Bioinformatics_tools/signalp-5.0/bin

# Prokka v1.13.3
prokka --cpus $(nproc) \
       --gram neg \
       --genus Leptospirillum \
       --usegenus \
       --rfam \
       --force \
       --proteins $PROTEINS \
       --prefix $PREFIX \
       -o $OUT_DIR \
       $CONTIG
#!/bin/bash


OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/MUMmer4"
PREFIX="LFerr"

# Settings:
REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/OBMB01.fasta"
CONTIG="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
MUMMER_HOME="$HOME/Bioinformatics_tools/mummer-4.0.0beta2"

mkdir -p "$OUT_DIR"

cd "$OUT_DIR"

"$MUMMER_HOME/./dnadiff" -p "$PREFIX" \
                         "$REFERENCE" \
                         "$CONTIG" \
                         2>&1 | tee MUMmer4_tee.log

mkdir -p "$OUT_DIR/plot"
cd "$OUT_DIR/plot"

"$MUMMER_HOME/./mummerplot" -p $PREFIX \
                            -R "$OUT_DIR/LFerr.rdiff" \
                            -Q "$OUT_DIR/LFerr.qdiff" \
                            --layout \
                            --title "LFerr Assembly VS Reference (0BMB01)" \
                            "$OUT_DIR/LFerr.delta" \
                            2>&1 | tee MUMmer4_plot_tee.log


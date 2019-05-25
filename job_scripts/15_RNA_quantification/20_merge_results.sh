#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/final"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/final"

IN_FILES=`find "$IN_DIR" -type d -wholename '*_salmon' | tr '\n' ' '~`
OUT_FILE="LFerr_genome_assembly_plus_proteins_salmon_merged.tsv"

mkdir -p $OUT_DIR

command time -v \
salmon quantmerge \
       --quants "$IN_FILES" \
       --column "numreads" \
       --missing "0" \
       -o "$OUT_DIR/$OUT_FILE" \
       2>&1 | tee "$OUT_DIR/salmone_quantmerge_tee.log"

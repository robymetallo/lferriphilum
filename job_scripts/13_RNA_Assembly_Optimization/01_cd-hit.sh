#!/bin/bash

TRANSCRIPTS="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/Trinity_second_run/Trinity_transctiptome_assembly_sith_merged_reads.fasta.transdecoder.cds"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/cd-hit"
OUT="LFerr_Transcriptome_Assembly_Trinity_second_run_selected_clustered.fasta"

mkdir -p "$OUT_DIR"

command time -v \
cd-hit-est -i "$TRANSCRIPTS" \
           -o "$OUT_DIR/$OUT" \
           -M 14000 \
           -T $(nproc) \
           2>&1 | tee "$OUT_DIR/cd-hit-est_tee.log"

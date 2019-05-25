#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BUSCO"

RAW_TRANS_ASSEMBLY="Trinity_transctiptome_assembly_sith_merged_reads.fasta"
OPT_TRANS_ASSEMBLY="LFerr_Transcriptome_Assembly_Trinity_selected_clustered.fasta"

PREFIX="LFerr_transcriptome_test"
DB="$HOME/Bioinformatics_data/busco_db/bacteria_odb9"


mkdir -p "$OUT_DIR/raw"

cd "$OUT_DIR/raw"

busco -i "$IN_DIR/$RAW_TRANS_ASSEMBLY" \
      -o "$PREFIX" \
      -l "$DB" \
      -c $(nproc) \
      --mode tran \
      --long \
      --tarzip \
      2>&1 | tee "$OUT_DIR/BUSCO_tee.log"


mkdir -p "$OUT_DIR/opt"

cd "$OUT_DIR/opt"

busco -i "$IN_DIR/$OPT_TRANS_ASSEMBLY" \
      -o "$PREFIX" \
      -l "$DB" \
      -c $(nproc) \
      --mode tran \
      --long \
      --tarzip \
      2>&1 | tee "$OUT_DIR/BUSCO_tee.log"
#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/select_best_ORFs"

REFERENCE="$HOME/Bioinformatics_data/uniprot/uniref/uniref90.fasta.gz"

DB_DIR="$HOME/Bioinformatics_data/diamond_db"
DB_NAME="UniRef90"
QUERY="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/filter_long_ORFs/longest_orfs.pep"
ALIGNED="LFerr_diamond_aligned.blastx"
UNALIGNED="LFerr_diamond_unaligned.blastx"
REPORT="LFerr_diamond.report"
TAX_DIR="$HOME/Bioinformatics_data/taxon_ncbi"
TAX_MAP=$TAX_DIR"/prot.accession2taxid.gz"
TAX_NODES=$TAX_DIR"/taxdump.tar.gz"

mkdir -p "$DB_DIR"
cd "$DB_DIR"

command time -v \
diamond makedb --in <(pigz -dc $REFERENCE) \
               --db "$DB_NAME" \
               2>&1 | tee "$DB_DIR/diamond_makedb_tee.log"

               # --taxonmap "$TAX_MAP" \
               # --taxonnodes "$TAX_NODES" \

DB="$DB_DIR/$DB_NAME.dmnd"

command time -v \
diamond blastp \
        -o "$OUT_DIR/$REPORT" \
        -f 6 \
        --header \
        --query "$QUERY" \
        --al "$OUT_DIR/$ALIGNED" \
        --un "$OUT_DIR/$UNALIGNED" \
        --min-orf 100 \
        --unal 1 \
        --max-target-seqs 1 \
        --sensitive \
        --masking 1 \
        --db "$DB" \
        2>&1 | tee "$OUT_DIR/diamond_tee.log"
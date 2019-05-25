#!/bin/bash

OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/Trinity_second_run"

TRANS_ASSEMBLY="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/Trinity_second_run/Trinity_transctiptome_assembly_sith_merged_reads.fasta"
TRANS_DECODER_HOME="$HOME/Bioinformatics_tools/TransDecoder-v5.5.0"
LONG_ORFS="longest_orfs.pep"


mkdir -p "$OUT_DIR"

# command time -v \
"$TRANS_DECODER_HOME/./TransDecoder.LongOrfs" \
                       -t $TRANS_ASSEMBLY \
                       -O "$OUT_DIR" \
                       2>&1 | tee "$OUT_DIR/TransDecoder.LongOrfs_tee.log"

LONG_ORFS="$OUT_DIR/$LONG_ORFS"

PFAM_DB="$HOME/Bioinformatics_data/pfam/Pfam-A.hmm"

PFAM_OUT="$OUT_DIR/pfam.domtblout"

# # Look for conserved protein domains
mkdir -p $OUT_DIR
cd $(dirname $PFAM_DB)

command time -v \
hmmpress $PFAM_DB \
         2>&1 | tee "$(dirname $PFAM_DB)/hmmpress_pfam_tee.log"

command time -v \
hmmscan --domtblout "$PFAM_OUT" \
        --cpu $(nproc) \
        $PFAM_DB \
        $LONG_ORFS \
        2>&1 | tee "$OUT_DIR/hmmscan_pfam_tee.log"


# BLAST Against a curated database of proteins


REFERENCE="$HOME/Bioinformatics_data/uniprot/uniref/uniref90.fasta.gz"
DB_DIR="$HOME/Bioinformatics_data/diamond_db"
DB_NAME="UniRef90"
QUERY="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/filter_long_ORFs/longest_orfs.pep"
ALIGNED="LFerr_diamond_aligned.blastp"
UNALIGNED="LFerr_diamond_unaligned.blastp"
BLAST_OUT="$OUT_DIR/blastp_diamond.outfmt6"

mkdir -p "$DB_DIR"
cd "$DB_DIR"

command time -v \
diamond makedb --in <(pigz -dc $REFERENCE) \
               --db "$DB_NAME" \
               2>&1 | tee "$DB_DIR/diamond_makedb_tee.log"

DB="$DB_DIR/$DB_NAME.dmnd"

command time -v \
diamond blastp \
        -o "$BLAST_OUT" \
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

# Drop first 3 lines
sed -i '1,3d' $BLAST_OUT

BEST_HITS="LFerr_Transcriptome_Assembly_Trinity_selected.fasta"


command time -v \
"$TRANS_DECODER_HOME/TransDecoder.Predict" \
                       -t "$TRANS_ASSEMBLY" \
                       --retain_pfam_hits "$PFAM_OUT" \
                       --retain_blastp_hits "$BLAST_OUT" \
                       --single_best_only \
                       -O "$OUT_DIR" \
                       | tee "$OUT_DIR/TransDecoder.Predict_tee.log"
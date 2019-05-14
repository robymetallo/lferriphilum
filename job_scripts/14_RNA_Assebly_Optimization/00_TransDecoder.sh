#!/bin/bash

OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/filter_long_ORFs"

TRANS_ASSEMBLY="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
TRANS_DECODER_HOME="$HOME/Bioinformatics_tools/TransDecoder-v5.5.0"
LONG_ORFS="longest_orfs.pep"


# mkdir -p "$OUT_DIR"

# command time -v \
# "$TRANS_DECODER_HOME/./TransDecoder.LongOrfs" \
#                        -t $TRANS_ASSEMBLY \
#                        -O "$OUT_DIR" \
#                        2>&1 | tee "$OUT_DIR/TransDecoder.LongOrfs_tee.log"

LONG_ORFS="$OUT_DIR/$LONG_ORFS"

OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder/select_best_ORFs"
PFAM_DB="$HOME/Bioinformatics_data/pfam/Pfam-A.hmm"

PFAM_OUT="$OUT_DIR/pfam.domtblout"

# Look for conserved protein domains
# mkdir -p $OUT_DIR
# cd $(dirname $PFAM_DB)

# command time -v \
# hmmpress $PFAM_DB \
#          2>&1 | tee "$(dirname $PFAM_DB)/hmmpress_pfam_tee.log"

# command time -v \
# hmmscan --domtblout "$PFAM_OUT" \
#         $PFAM_DB \
#         $LONG_ORFS \
#         2>&1 | tee "$OUT_DIR/hmmscan_pfam_tee.log"


# BLAST Against a curated database of proteins

UNIPROT_FOLDER="$HOME/Bioinformatics_data/uniprot/uniref"
UNIPR_DB="$UNIPROT_FOLDER/uniref90"

BLAST_OUT="$OUT_DIR/blastp.outfmt6"

# command time -v \
# gzip -cd "$UNIPROT_FOLDER/uniref90.fasta.gz" \
#      | makeblastdb -in - \
#      -title uniref90 \
#      -dbtype prot \
#      -out "$UNIPROT_FOLDER/uniref90" \
#      2>&1 | tee "$UNIPROT_FOLDER/uniref90.log"

command time -v \
blastp -query $LONG_ORFS \
       -db $UNIPR_DB \
       -max_target_seqs 1 \
       -outfmt 6 \
       -evalue 1e-5 \
       -num_threads $(nproc) \
       -out "$BLAST_OUT" \
       2>&1  | tee "$OUT_DIR/blastp_uniprot_tee.log"

BEST_HITS="LFerr_Transcriptome_Assembly_Trinity_selected.fasta"


command time -v \
"$TRANS_DECODER_HOME/./TransDecoder.Predict" \
                       -t $TRANS_ASSEMBLY \
                       --retain_pfam_hits $PFAM_OUT \
                       --retain_blastp_hits $BLAST_OUT \
                       --single_best_orf \
                       > "$OUT_DIR/$BEST_HITS" \
                       | tee "$OUT_DIR/TransDecoder.Predict_tee.log"
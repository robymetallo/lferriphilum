#!/bin/zsh

TRANS="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
OUT_DIR_TRANS_DECODER="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder"
TRANS_DECODER_HOME="$HOME/Bioinformatics_Programs/TransDecoder-TransDecoder-v5.5.0"
TRINOTATE_HOME="$HOME/Bioinformatics_Programs/Trinotate-git"

# Identify candidate coding regions within transcript sequences

mkdir -p $OUT_DIR_TRANS_DECODER

cd $OUT_DIR_TRANS_DECODER

# command time -v \
# $TRANS_DECODER_HOME/TransDecoder.LongOrfs -t $TRANS \
#                2>&1 | tee $OUT_DIR_TRANS_DECODER/TransDecoder_tee.log


# https://github.com/Trinotate/Trinotate.github.io/wiki/Software-installation-and-data-required#3-running-sequence-analyses

OUT_DIR_TRINOTATE="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinotate"
TRANS_DECODER_PEP="$OUT_DIR_TRANS_DECODER/LFerr_Transcriptome_Assembly_Trinity.fasta.transdecoder_dir/longest_orfs.pep"

mkdir -p $OUT_DIR_TRINOTATE

# command time -v \
# blastx -query $TRANS \
#        -db "$TRINOTATE_HOME/uniprot_sprot.pep" \
#        -num_threads $(nproc) \
#        -max_target_seqs 1 \
#        -outfmt 6 \
#        -evalue 1e-3 \
#        1> "$OUT_DIR_TRINOTATE/blastx.outfmt6" \
#        | tee "$OUT_DIR_TRINOTATE/blastx.log"

# command time -v \
# blastp -query $TRANS_DECODER_PEP \
#        -db $TRINOTATE_HOME"/uniprot_sprot.pep" \
#        -num_threads $(nproc) \
#        -max_target_seqs 1 \
#        -outfmt 6 \
#        -evalue 1e-3 \
#        1> "$OUT_DIR_TRINOTATE/blastp.outfmt6" \
#        | tee "$OUT_DIR_TRINOTATE/blastp.log"

# command time -v \
# hmmscan --cpu $(nproc) \
#         --domtblout $OUT_DIR_TRINOTATE/"TrinotatePFAM.out" \
#         "$TRINOTATE_HOME/Pfam-A.hmm" \
#         $TRANS_DECODER_PEP \
#         | tee "$OUT_DIR_TRINOTATE/hmmscan.log"

# SIGNALP_HOME="$HOME/Bioinformatics_Programs/signalp-5.0"
# cd $SIGNALP_HOME

# command time -v \
# bin/./signalp -format short \
#         -prefix "$OUT_DIR_TRINOTATE/signalp.out" \
#         -org gram- \
#         -fasta $TRANS_DECODER_PEP \
#         2>&1 | tee "$OUT_DIR_TRINOTATE/hmmscan.log"



# THIS ISN'T WORKLINGGGGGGGG

# TMHMM_HOME="$HOME/Bioinformatics_Programs/tmhmm-2.0c"

# cd $TMHMM_HOME

# command time -v \
# cat $TRANS_DECODER_PEP | $TMHMM_HOME"/bin/tmhmm" --short > $OUT_DIR_TRINOTATE"/tmhmm.out" 
# \
                        # 2>&1 | tee "$OUT_DIR_TRINOTATE/tmhmm.log"

RNAMMER_HOME="$HOME/Bioinformatics_Programs/rnammer-1.2.src"

command time -v \
$TRINOTATE_HOME"/util/rnammer_support/RnammerTranscriptome.pl" \
               --transcriptome $TRANS \
               --path_to_rnammer $RNAMMER_HOME"/rnammer" \
               --org_type "bac" \
               2>&1 | tee "$OUT_DIR_TRINOTATE/rnammer.log"

# SQLITE_DB="$TRINOTATE_HOME/Trinotate.sqlite"
# GENE_TRANS_MAP="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity_gene_to_trans_map"

# command time -v \
# "$TRINOTATE_HOME/Trinotate" $SQLITE_DB init \
#                             --gene_trans_map $GENE_TRANS_MAP \
#                             --transcript_fasta $TRANS \
#                             --transdecoder_pep $TRANS_DECODER_PEP \
#                             2>&1 | tee "$OUT_DIR_TRINOTATE/Trinotate.log"
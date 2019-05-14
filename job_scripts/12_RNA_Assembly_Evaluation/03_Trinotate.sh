#!/bin/bash

TRANS="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
OUT_DIR_TRANS_DECODER="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/TransDecoder"
TRANS_DECODER_HOME="$HOME/Bioinformatics_Programs/TransDecoder-TransDecoder-v5.5.0"
TRINOTATE_HOME="$HOME/Bioinformatics_Programs/Trinotate-git"

# Identify candidate coding regions within transcript sequences

mkdir -p $OUT_DIR_TRANS_DECODER
cd $OUT_DIR_TRANS_DECODER

command time -v \
$TRANS_DECODER_HOME/TransDecoder.LongOrfs -t $TRANS \
               2>&1 | tee $OUT_DIR_TRANS_DECODER/TransDecoder_tee.log


# https://github.com/Trinotate/Trinotate.github.io/wiki/Software-installation-and-data-required#3-running-sequence-analyses

OUT_DIR_TRINOTATE="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinotate"
TRANS_DECODER_PEP="$OUT_DIR_TRANS_DECODER/LFerr_Transcriptome_Assembly_Trinity.fasta.transdecoder_dir/longest_orfs.pep"

mkdir -p $OUT_DIR_TRINOTATE

# Search against Uniprot and pfam databases

command time -v \
blastx -query $TRANS \
       -db "$TRINOTATE_HOME/uniprot_sprot.pep" \
       -num_threads $(nproc) \
       -max_target_seqs 1 \
       -outfmt 6 \
       -evalue 1e-3 \
       1> "$OUT_DIR_TRINOTATE/blastx.outfmt6" \
       | tee "$OUT_DIR_TRINOTATE/blastx.log"

command time -v \
blastp -query $TRANS_DECODER_PEP \
       -db $TRINOTATE_HOME"/uniprot_sprot.pep" \
       -num_threads $(nproc) \
       -max_target_seqs 1 \
       -outfmt 6 \
       -evalue 1e-3 \
       1> "$OUT_DIR_TRINOTATE/blastp.outfmt6" \
       | tee "$OUT_DIR_TRINOTATE/blastp.log"

command time -v \
hmmscan --cpu $(nproc) \
        --domtblout $OUT_DIR_TRINOTATE/"TrinotatePFAM.out" \
        "$TRINOTATE_HOME/Pfam-A.hmm" \
        $TRANS_DECODER_PEP \
        | tee "$OUT_DIR_TRINOTATE/hmmscan.log"

# Predict signal peptides and clivage sites

SIGNALP_HOME="$HOME/Bioinformatics_Programs/signalp-5.0"
cd $SIGNALP_HOME

command time -v \
bin/./signalp -format short \
        -prefix "$OUT_DIR_TRINOTATE/signalp.out" \
        -gff3 \
        -mature \
        -org gram- \
        -fasta $TRANS_DECODER_PEP \
        2>&1 | tee "$OUT_DIR_TRINOTATE/hmmscan.log"


# Predict TM helices

# For some wierd reason, tmhmm produces an empty output (error 13 broken pipe)
# I had to run tmhmm on rackham

# TMHMM_HOME="$HOME/Bioinformatics_Programs/tmhmm-2.0c"
# cat $TRANS_DECODER_PEP | "$TMHMM_HOME/bin/tmhmm" --short > $OUT_DIR_TRINOTATE"/tmhmm.out"

# Predict rRNA

RNAMMER="$HOME/Bioinformatics_Programs/rnammer-1.2.src/rnammer"

cd $OUT_DIR_TRINOTATE
command time -v \
"$TRINOTATE_HOME/util/rnammer_support/RnammerTranscriptome.pl" \
                --transcriptome $TRANS \
                --path_to_rnammer $RNAMMER \
                --org_type bac \
                2>&1 | tee "$OUT_DIR_TRINOTATE/rnammer.log"


# Alternative to rnammer. Requires output post-processing

# barrnap --kingdom bac \
#         --threads 4 \
#         --outseq "$OUT_DIR_TRINOTATE/rrna_barrnap.fasta" \
#         "$RNAMMER_HOME/transcriptSuperScaffold.fasta"

# Populate DB

SQLITE_DB="$TRINOTATE_HOME/Trinotate.sqlite"
GENE_TRANS_MAP="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity_gene_to_trans_map"
TRINOTATE_SQL="./Trinotate Trinotate.sqlite"

cd $TRINOTATE_HOME

./Trinotate Trinotate.sqlite init \
            --gene_trans_map $GENE_TRANS_MAP \
            --transcript_fasta $TRANS \
            --transdecoder_pep $TRANS_DECODER_PEP \
            2>&1 | tee "$OUT_DIR_TRINOTATE/Trinotate.log"


./Trinotate Trinotate.sqlite LOAD_swissprot_blastp "$OUT_DIR_TRINOTATE/blastp.outfmt6" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"
./Trinotate Trinotate.sqlite LOAD_pfam "$OUT_DIR_TRINOTATE/TrinotatePFAM.out" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"
./Trinotate Trinotate.sqlite LOAD_tmhmm "$OUT_DIR_TRINOTATE/tmhmm.out" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"
./Trinotate Trinotate.sqlite LOAD_signalp "$OUT_DIR_TRINOTATE/signalp.out_summary.signalp5" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"

./Trinotate Trinotate.sqlite LOAD_swissprot_blastx "$OUT_DIR_TRINOTATE/blastx.outfmt6" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"

./Trinotate Trinotate.sqlite LOAD_rnammer "$OUT_DIR_TRINOTATE/LFerr_Transcriptome_Assembly_Trinity.fasta.rnammer.gff" \
            2>&1 | tee -a "$OUT_DIR_TRINOTATE/Trinotate.log"

./Trinotate Trinotate.sqlite report > "$OUT_DIR_TRINOTATE/trinotate_annotation_report.xls"



# View results in a browser - http://localhost:8080/cgi-bin/index.cgi

google-chrome-stable "http://localhost:8080/cgi-bin/index.cgi?sqlite_db=%2Fhome%2Froby%2FBioinformatics_Programs%2FTrinotate-git%2FTrinotate.sqlite"
cd $TRINOTATE_HOME && ./run_TrinotateWebserver.pl 8080

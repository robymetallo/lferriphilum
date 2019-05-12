#!/bin/bash -l


IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BWA"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Stringtie"

BAM="LFerr_merged_for_trans_assembly.bam"
REF_ANNOTATION="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/prokka/LFerr.gff"
TRANSCRIPT_CVG="LFerr_transcript_coverage.gtf"
OUT_GTF="LFerr_transcripts.gtf"

mkdir -p $OUT_DIR

stringtie $IN_DIR/$BAM \
          -p 4 \
          -G $REF_ANNOTATION \
          -C $TRANSCRIPT_CVG \
          2>&1 | tee $OUT_DIR/stringtie_tee.log

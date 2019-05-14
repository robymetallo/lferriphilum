#!/bin/bash -l


IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/02_aligned_reads"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Stringtie"

BAM="LFerr_merged_for_trans_assembly_sorted.bam"
REF_ANNOTATION="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/prokka/20_LFerr_genome_assembly_final/LFerr.gff"
TRANSCRIPT_CVG="LFerr_transcript_coverage.gtf"
OUT_GTF="LFerr_transcripts.gtf"

mkdir -p $OUT_DIR

command time -v \
stringtie $IN_DIR/$BAM \
          -p $(nproc) \
          -G $REF_ANNOTATION \
          -C $OUT_DIR/$TRANSCRIPT_CVG \
          -o $OUT_DIR/$OUT_GTF \
          2>&1 | tee $OUT_DIR/stringtie_tee.log

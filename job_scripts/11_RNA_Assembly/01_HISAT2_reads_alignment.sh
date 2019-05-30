#!/bin/bash

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr"
DB_PREFIX="LFerr"


mkdir -p "$DB_DIR"

# Build DB
hisat2-build "$REF_GENOME" \
             "$DB_DIR/$DB_PREFIX" \
             2>&1 | tee "$DB_DIR/hisat2-build_tee.log"

IN_READS="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/04_Normalized/LFerr_RNA_normalized_for_trinity.fastq.gz"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/HISAT2"

TMP_BAM="LFerr_Transcriptome_tmp.bam"
OUT_BAM="LFerr_RNA_normalized_sorted_for_trinity.bam"

mkdir -p "$OUT_DIR"

HISAT2_INDEXES="$DB_DIR"

# Align PE
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file "$OUT_DIR/histat2.summary" \
       --met-file "$OUT_DIR/histat2.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x "$DB_DIR/$DB_PREFIX" \
       -U "$IN_READS" | \
samtools view -@1 \
         -b \
         -1 \
         -o "$OUT_DIR/$TMP_BAM" \
         2>&1 | tee "$OUT_DIR/samsort_tee.log"

command time -v \
samtools sort -@$(nproc) \
              -m 1250M \
              -l 9 \
              -o "$OUT_DIR/$OUT_BAM" \
              "$OUT_DIR/$TMP_BAM" \
              2>&1 | tee "$OUT_DIR/samtools_sort_tee.log"

rm "$OUT_DIR/$TMP_BAM"

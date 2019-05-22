#!/bin/bash

SALMON_IDX_DIR="$HOME/Bioinformatics_data/salmon_idx/salmon_idx_genome_assembly"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/genome_assembly/with_replicates/batch_colture"
IDX="LFerr_genome_assembly"
TRANS_ANNOT="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/LFerr_with_proteins_merged.ffn"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"

mkdir -p "$SALMON_IDX_DIR"
mkdir -p "$OUT_DIR"

cd "$SALMON_IDX_DIR"

salmon index -t "$TRANS_ANNOT" \
             -i "$IDX" \
             -k 31

FWD_READS="$READS_DIR/ERR2036631/ERR2036631_OK_1.fastq.gz\
 $READS_DIR/ERR2117290/ERR2117290_OK_1.fastq.gz\
 $READS_DIR/ERR2036632/ERR2036632_OK_1.fastq.gz\
 $READS_DIR/ERR2117291/ERR2117291_OK_1.fastq.gz"

REV_READS="$READS_DIR/ERR2036631/ERR2036631_OK_2.fastq.gz\
 $READS_DIR/ERR2117290/ERR2117290_OK_2.fastq.gz\
 $READS_DIR/ERR2036632/ERR2036632_OK_2.fastq.gz\
 $READS_DIR/ERR2117291/ERR2117291_OK_2.fastq.gz"


command time -v \
salmon quant -i "$SALMON_IDX_DIR/$IDX" \
             -l A \
             -1 $FWD_READS \
             -2 $REV_READS \
             -p $(nproc) \
             --validateMappings \
             --gcBias \
             -o "$OUT_DIR/LFerr_batch_salmon.out" \
             2>&1 | tee "$OUT_DIR/LFerr_batch_salmon_tee.log"


FWD_READS="$READS_DIR/ERR2036630/ERR2036630_OK_1.fastq.gz\
 $READS_DIR/ERR2117289/ERR2117289_OK_1.fastq.gz\
 $READS_DIR/ERR2036633/ERR2036633_OK_1.fastq.gz\
 $READS_DIR/ERR2117292/ERR2117292_OK_1.fastq.gz\
 $READS_DIR/ERR2036629/ERR2036629_OK_1.fastq.gz\
 $READS_DIR/ERR2117288/ERR2117288_OK_1.fastq.gz"

REV_READS="$READS_DIR/ERR2036630/ERR2036630_OK_2.fastq.gz\
 $READS_DIR/ERR2117289/ERR2117289_OK_2.fastq.gz\
 $READS_DIR/ERR2036633/ERR2036633_OK_2.fastq.gz\
 $READS_DIR/ERR2117292/ERR2117292_OK_2.fastq.gz\
 $READS_DIR/ERR2036629/ERR2036629_OK_2.fastq.gz\
 $READS_DIR/ERR2117288/ERR2117288_OK_2.fastq.gz"

OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/genome_assembly/with_replicates/continuos_colture"
mkdir -p $OUT_DIR

command time -v \
salmon quant -i "$SALMON_IDX_DIR/$IDX" \
             -l A \
             -1 $FWD_READS \
             -2 $REV_READS \
             -p $(nproc) \
             --validateMappings \
             --gcBias \
             -o "$OUT_DIR/LFerr_continuos_salmon.out" \
             2>&1 | tee "$OUT_DIR/LFerr_continuos_salmon_tee.log"
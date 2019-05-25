#!/bin/bash

SALMON_IDX_DIR="$HOME/Bioinformatics_data/salmon_idx"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Salmon/final"
IDX="LFerr_genome_assembly_plus_proteins"
TRANS_ANNOT="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/prokka/LFerr_with_proteins.ffn"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
TRANS_TO_GENE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/transcripts_to_gene.map"


mkdir -p "$SALMON_IDX_DIR"
mkdir -p "$OUT_DIR"

cd "$SALMON_IDX_DIR"

salmon index -t "$TRANS_ANNOT" \
             -i "$IDX" \
             -k 31


FWD_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_1.fastq.gz' | tr '\n' ' '~`
REV_READS=`find $READS_DIR -wholename '*BBDuk/ERR*/*OK_2.fastq.gz' | tr '\n' ' '~`

FWD_READS=("$READS_DIR/ERR2117288/ERR2117288_OK_1.fastq.gz $READS_DIR/ERR2036629/ERR2036629_OK_1.fastq.gz"
           "$READS_DIR/ERR2036630/ERR2036630_OK_1.fastq.gz $READS_DIR/ERR2117289/ERR2117289_OK_1.fastq.gz"
           "$READS_DIR/ERR2117292/ERR2117292_OK_1.fastq.gz $READS_DIR/ERR2036633/ERR2036633_OK_1.fastq.gz"
           "$READS_DIR/ERR2117290/ERR2117290_OK_1.fastq.gz $READS_DIR/ERR2036631/ERR2036631_OK_1.fastq.gz"
           "$READS_DIR/ERR2036632/ERR2036632_OK_1.fastq.gz $READS_DIR/ERR2117291/ERR2117291_OK_1.fastq.gz")

REV_READS=("$READS_DIR/ERR2117288/ERR2117288_OK_2.fastq.gz $READS_DIR/ERR2036629/ERR2036629_OK_2.fastq.gz"
           "$READS_DIR/ERR2036630/ERR2036630_OK_2.fastq.gz $READS_DIR/ERR2117289/ERR2117289_OK_2.fastq.gz"
           "$READS_DIR/ERR2117292/ERR2117292_OK_2.fastq.gz $READS_DIR/ERR2036633/ERR2036633_OK_2.fastq.gz"
           "$READS_DIR/ERR2117290/ERR2117290_OK_2.fastq.gz $READS_DIR/ERR2036631/ERR2036631_OK_2.fastq.gz"
           "$READS_DIR/ERR2036632/ERR2036632_OK_2.fastq.gz $READS_DIR/ERR2117291/ERR2117291_OK_2.fastq.gz")

OUT_NAMES=("Continuous_1" "Continuous_2" "Continuous_3" "Batch_1" "Batch_2")

for i in $(seq 0 ${#OUT_NAMES[@]}); do

   mkdir -p "$OUT_DIR/${OUT_NAMES[i]}"_salmon

   command time -v \
   salmon quant -i "$SALMON_IDX_DIR/$IDX" \
                -l A \
                -1 ${FWD_READS[i]} \
                -2 ${REV_READS[i]} \
                -p $(nproc) \
                --gcBias \
                --validateMappings \
                --sigDigits 0 \
                --geneMap $TRANS_TO_GENE \
                -o "$OUT_DIR/${OUT_NAMES[i]}"_salmon \
                2>&1 | tee "$OUT_DIR/${OUT_NAMES[i]}"_salmon/salmon_tee.log
done
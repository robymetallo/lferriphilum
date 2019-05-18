#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/03_BBmerge"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinity_norm/merged"

FQ_MERGED="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/03_BBmerge/LFerr_RNA_BBMerge_merged_renamed.fastq.gz"

# Normalize reads
TRINITY_HOME="$HOME/Bioinformatics_tools/Trinity-git"

command time -v \
$TRINITY_HOME/util/insilico_read_normalization.pl \
             --seqType fq \
             --max_cov 20 \
             --JM 14G \
             --single "$FQ_MERGED" \
             --output $OUT_DIR \
             --CPU $(nproc) \
             2>&1 | tee "$OUT_DIR/Trinity_normalization_tee.log"


OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinity_norm/unmerged"
FQ_MERGED="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/03_BBmerge/LFerr_RNA_BBMerge_unmerged_renamed.fastq.gz"

command time -v \
$TRINITY_HOME/util/insilico_read_normalization.pl \
             --seqType fq \
             --max_cov 20 \
             --JM 14G \
             --single "$FQ_MERGED" \
             --output $OUT_DIR \
             --CPU $(nproc) \
             2>&1 | tee "$OUT_DIR/Trinity_normalization_tee.log"


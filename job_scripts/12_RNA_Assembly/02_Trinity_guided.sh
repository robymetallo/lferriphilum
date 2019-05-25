#!/bin/bash


OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinity/"

BAM_FILE="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinity_norm/merged/LFerr_merged_only_sorted.bam"

TRINITY_HOME="$HOME/Bioinformatics_tools/Trinity-git"

mkdir -p "$OUT_DIR"

# Trinity v2.8.2
command time -v \
"$TRINITY_HOME/Trinity" --genome_guided_bam "$BAM_FILE" \
                        --genome_guided_max_intron 1 \
                        --max_memory 16G \
                        --output "$OUT_DIR" \
                        --CPU $(nproc) \
                        --bflyHeapSpaceMax 12G \
                        --bflyGCThreads 4 \
                        2>&1 | tee "$OUT_DIR/Trinity_tee.log"






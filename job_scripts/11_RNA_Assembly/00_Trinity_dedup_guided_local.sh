#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/02_aligned_reads"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Trinity"

BAM_FILE="LFerr_dedup_sorted.bam"

mkdir -p $OUT_DIR

# Trinity v2.8.2
command time -v Trinity --genome_guided_bam $IN_DIR/$BAM_FILE \
                        --genome_guided_max_intron 1 \
                        --max_memory 16G \
                        --output $OUT_DIR \
                        --CPU 4 \
                        --bflyHeapSpaceMax 16G \
                        --bflyGCThreads 1 \
                        --bflyCalculateCPU \
                        2>&1 | tee -a $OUT_DIR/Trinity_tee.log

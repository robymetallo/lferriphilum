#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/corrected_reads"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/trimmed_reads"

# Settings:
PREFIX="LFerr"                          # File name prefix of intermediate and output files
GENOME_SIZE="2.6m"                      # Expected genome size
IN_FILES="LFerr.correctedReads.fasta.gz"

# Canu 1.8 r9408 (6eafac5e650165cc7aba34a9539e7a3b7596bb9c)
command time -v \
canu -trim \
     -p $PREFIX \
     -d $OUT_DIR \
      genomeSize=$GENOME_SIZE \
     -pacbio-corrected $IN_DIR/$IN_FILES \
      2>&1 | tee $OUT_DIR/canu_tee.log

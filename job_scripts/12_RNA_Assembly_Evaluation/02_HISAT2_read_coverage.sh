#!/bin/bash

REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/Trinity_transctiptome_assembly_sith_merged_reads.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr_trinity_raw"
DB_PREFIX="LFerr_trinity_raw"
# Build DB

mkdir -p "$DB_DIR"

hisat2-build "$REFERENCE" \
             "$DB_DIR/$DB_PREFIX" \
             2>&1 | tee $DB_DIR/hisat2-build_tee.log


IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_trimmed"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/coverage_raw_assembly"

FWD_READS=`find $IN_DIR -wholename '*ERR*/*OK_1.fastq.gz' | tr '\n' ' '~ | tr ' ' ','`
REV_READS=`find $IN_DIR -wholename '*ERR*/*OK_2.fastq.gz' | tr '\n' ' '~ | tr ' ' ','`

FWD_READS=${FWD_READS: : -1}
REV_READS=${REV_READS: : -1}

HISAT2_INDEXES="$DB_DIR"

mkdir -p "$OUT_DIR"

# Align PE
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file "$OUT_DIR/histat2_coverage.summary" \
       --met-file "$OUT_DIR/histat2_coverage.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x "$DB_DIR/$DB_PREFIX" \
       -1 "$FWD_READS" \
       -2 "$REV_READS" \
       1> /dev/null | tee "$OUT_DIR/histat2_coverage.summary.log"


DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr_trinity_opt"
DB_PREFIX="LFerr_trinity_opt"
REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity_selected_clustered.fasta"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/coverage_opt_assembly"
# Build DB

mkdir -p "$DB_DIR"

hisat2-build "$REFERENCE" \
             "$DB_DIR/$DB_PREFIX" \
             2>&1 | tee "$DB_DIR/hisat2-build_tee.log"

mkdir -p "$OUT_DIR"


# Align PE
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file "$OUT_DIR/histat2_coverage.summary" \
       --met-file "$OUT_DIR/histat2_coverage.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x "$DB_DIR/$DB_PREFIX" \
       -1 "$FWD_READS" \
       -2 "$REV_READS" \
       1> /dev/null | tee "$OUT_DIR/histat2_coverage.summary.log"
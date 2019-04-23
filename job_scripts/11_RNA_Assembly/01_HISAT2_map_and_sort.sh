#!/bin/bash

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/12_LFerr_without_contaminants_main_contig.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/leptospirillum_ferriphilum"
DB_PREFIX="leptospirillum_ferriphilum"

# Build DB

# mkdir -p $DB

# hisat2-build $REF_GENOME \
#              $DB_DIR/$DB_PREFIX \
#              2>&1 | tee $DB_DIR/hisat2-build_tee.log

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_Trimmed/00_merged/"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/StringTie"

FWD_READS="LFer_RNA-Seq_FWD_clumped.fastq.bz2"
REV_READS="LFer_RNA-Seq_REV_clumped.fastq.bz2"
UNP_READS="LFer_RNA-Seq_singletons_clumped.fastq.bz2"

TMP_BAM="LFerr_Transcriptome.bam"
OUT_BAM="LFerr_Transcriptome_sorted.bam"

mkdir -p $OUT_DIR
# samtools sort \
#          --threads 4 \
#          $OUT_DIR/$TMP_BAM > $OUT_DIR/$OUT_BAM

HISAT2_INDEXES=$DB_DIR

hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR/histat2.summary \
       --new-summary \
       --threads 3 \
       --dta \
       -x $DB_DIR/$DB_PREFIX \
       -1 $IN_DIR/$FWD_READS \
       -2 $IN_DIR/$REV_READS | \
samtools view \
         -b \
         -1 \
         > $OUT_DIR/$TMP_BAM

samtools sort \
         --threads 4 \
         $OUT_DIR/$TMP_BAM > $OUT_DIR/$OUT_BAM

# rm $OUT_DIR/$TMP_BAM
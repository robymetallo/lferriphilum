#!/bin/bash

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr"
DB_PREFIX="LFerr"
# Build DB

mkdir -p $DB_DIR

hisat2-build $REF_GENOME \
             $DB_DIR/$DB_PREFIX \
             2>&1 | tee $DB_DIR/hisat2-build_tee.log

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_dedup/"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/HISAT2"

FWD_READS="LFerr_OK_1_merged.fastq.gz"
REV_READS="LFerr_OK_2_merged.fastq.gz"
SING_READS="LFerr_singletons_merged.fastq.gz"

TMP_BAM_PE="LFerr_Transcriptome_PE.bam"
TMP_BAM_SING="LFerr_Transcriptome_singletons.bam"
TMP_BAM_MRG="LFerr_merged_for_trans_assembly.bam"
OUT_BAM="LFerr_Transcriptome_sorted.bam"

mkdir -p $OUT_DIR/PE
mkdir -p $OUT_DIR/singletons

HISAT2_INDEXES=$DB_DIR

# Align PE
hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/PE/histat2.summary" \
       --met-file $OUT_DIR"/PE/histat2.log" \
       --met 5 \
       --new-summary \
       --threads 4 \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x $DB_DIR/$DB_PREFIX \
       -1 $IN_DIR/$FWD_READS \
       -2 $IN_DIR/$REV_READS | \
samtools view \
         -b \
         -l 6 \
         -o $OUT_DIR"/PE/"$TMP_BAM_PE



hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/singletons/histat2.summary" \
       --met-file $OUT_DIR"/singletons/histat2.log" \
       --met 5 \
       --new-summary \
       --threads 4 \
       --dta \
       --time \
       -U $IN_DIR/$SING_READS | \
samtools view \
         -b \
         -l 6 \
         -o  $OUT_DIR"/singletons/"$TMP_BAM_SING

samtools merge $OUT_DIR/$TMP_BAM_MRG \
               $OUT_DIR"/PE/*.bam" \
               $OUT_DIR"/singletons/*.bam"

samtools sort -@4 \
              -m 1750M \
              -l 9 \
              -o $OUT_DIR"LFerr_merged_for_trans_assembly_sorted.bam" \
              $OUT_DIR/$TMP_BAM_MRG

rm $OUT_DIR"/PE/"$TMP_BAM_PE
rm $OUT_DIR"/singletons/"$TMP_BAM_SING
rm $OUT_DIR/$TMP_BAM_MRG
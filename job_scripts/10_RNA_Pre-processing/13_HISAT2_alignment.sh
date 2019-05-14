#!/bin/bash

REF_GENOME="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"
DB_DIR="$HOME/Bioinformatics_data/hisat2db/LFerr"
DB_PREFIX="LFerr"


mkdir -p $DB_DIR

# Build DB
hisat2-build $REF_GENOME \
             $DB_DIR/$DB_PREFIX \
             2>&1 | tee $DB_DIR/hisat2-build_tee.log

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/00_dedup/01_all_samples"
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
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/PE/histat2.summary" \
       --met-file $OUT_DIR"/PE/histat2.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -I 350 \
       -X 375 \
       -x $DB_DIR/$DB_PREFIX \
       -1 $IN_DIR/$FWD_READS \
       -2 $IN_DIR/$REV_READS | \
samtools view -@1 \
         -b \
         -1 \
         -o $OUT_DIR"/PE/"$TMP_BAM_PE \
         2>&1 | tee $OUT_DIR"/PE/hisat2_PE_tee.log"


# # Align singletons
command time -v \
hisat2 --no-spliced-alignment \
       --summary-file $OUT_DIR"/singletons/histat2.summary" \
       --met-file $OUT_DIR"/singletons/histat2.log" \
       --met 5 \
       --new-summary \
       --threads $(nproc) \
       --dta \
       --time \
       -x $DB_DIR/$DB_PREFIX \
       -U $IN_DIR/$SING_READS | \
samtools view -@1\
         -b \
         -1 \
         -o  $OUT_DIR"/singletons/"$TMP_BAM_SING \
         2>&1 | tee $OUT_DIR"/singletons/hisat2_singletons_tee.log"

# Merge PE and singletons
command time -v \
samtools merge -@$(nproc) \
               $OUT_DIR/$TMP_BAM_MRG \
               $OUT_DIR"/PE/$TMP_BAM_PE" \
               $OUT_DIR"/singletons/$TMP_BAM_SING" \
               2>&1 | tee $OUT_DIR"/samtools_merge_tee.log"

command time -v \
samtools sort -@$(nproc) \
              -m 1250M \
              -l 9 \
              -o $OUT_DIR"/LFerr_merged_for_trans_assembly_sorted.bam" \
              $OUT_DIR/$TMP_BAM_MRG \
              2>&1 | tee $OUT_DIR"/samtools_sort_tee.log"

# rm $OUT_DIR"/PE/"$TMP_BAM_PE
# rm $OUT_DIR"/singletons/"$TMP_BAM_SING
rm $OUT_DIR/$TMP_BAM_MRG
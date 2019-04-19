#!/bin/bash

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/raw_data/old/RNA_raw_data/"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/trinity_test"
# TMP_OUT=$SNIC_TMP/trinity

# Trimmomatic
ADAPTERS="$HOME/Bioinformatics_Programs/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa"
SEED="2"         # Look for seed matches (16nt) allowing maximally 2 mismatches
PE_THRESH="30"   # Extend and clip PE reads only if a score of 30 is reached (about 50nt)
SE_THRESH="10"   # Extend and clip SE reads only if a score of 10 is reached (about 17nt)
RM_LEAD_CLP="3"  # Remove leading bases with quality < 3
RM_TRAIL_CLP="3" # Remove trailing bases with quality < 3
SW="4:15"        # Scan reads using a sliding window of 4 bases and cut
                 # when avg quality < 15
MIN_LEN="36"     # Discard trimmed reads that are less than 36nt long

# MAXINFO settings
# Transcriptome assembly
TARGET_LEN="75"      # Longer read length it's better for transcriptome assembly
STRICTNESS="0.2"     # Favour lenght over correctness

# Gene expression analysis
# TARGET_LEN="50"      # For gene expression alaysis 50bp should be enough
# STRICTNESS="0.8"     # Favour correctness over length

# OTHER GLOBAL SETTINGS
# Remove low quality bases (q < 3)
RM_LEADING="3"
RM_TRAILING="3"
SW_GLOBAL="4:15"
MINLEN="36"

# TRIMMOMATIC_STRING=ILLUMINACLIP:$ADAPTERS:$SEED:$PE_THRESH:$SE_THRESH MAXINFO:$TARGET_LEN:$STRICTNESS LEADING:$RM_LEADING TRAILING:$RM_TRAILING SLIDINGWINDOW:$SW_GLOBAL MINLEN:$MINLEN

# echo $TRIMMOMATIC_STRING

# Settings:
# FWD_FASTQ="ERR2*_1.fastq.gz"
# REV_FASTQ="ERR2*_2.fastq.gz"

# FWD_LIST=`ls $IN_DIR/$FWD_FASTQ | tr "\n" ","`
# FWD_LIST=${FWD_LIST::-1}

# REV_LIST=`ls $IN_DIR/$REV_FASTQ | tr "\n" ","`
# REV_LIST=${FWD_LIST::-1}

SAMPLE_FILE="$HOME/GitHub/lferriphilum/job_scripts/11_RNA_Assembly/Sample_table_gzip.tsv"

# SOFTWARE_NAME SOFTWARE_VERSION
# Trinity --seqType fq --max_memory 15G \
#          --samples_file $SAMPLE_FILE \
#          --trimmomatic \
#          --quality_trimming_params "ILLUMINACLIP:$ADAPTERS:$SEED:$PE_THRESH:$SE_THRESH MAXINFO:$TARGET_LEN:$STRICTNESS LEADING:$RM_LEADING TRAILING:$RM_TRAILING SLIDINGWINDOW:$SW_GLOBAL MINLEN:$MINLEN" \
#          --output $OUT_DIR \
#          --CPU 4


Trinity --seqType fq --max_memory 15G \
         --left $HOME/Downloads/ERR2036629_1_converted.fastq.gz \
         --right $HOME/Downloads/ERR2036629_2_converted.fastq.gz \
         --trimmomatic \
         --quality_trimming_params "ILLUMINACLIP:$ADAPTERS:$SEED:$PE_THRESH:$SE_THRESH MAXINFO:$TARGET_LEN:$STRICTNESS LEADING:$RM_LEADING TRAILING:$RM_TRAILING SLIDINGWINDOW:$SW_GLOBAL MINLEN:$MINLEN" \
         --output $OUT_DIR \
         --CPU 4

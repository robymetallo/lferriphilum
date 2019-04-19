#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 10:00:00
#SBATCH -J Trinity_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs Trinity to pre-process and assemble the transcriptome
  
# Load modules
module load bioinfo-tools
module load Trinity/2.8.2
module load samtools/1.9
module load Salmon/0.9.1
module load jellyfish/2.2.6
# module load MODULE_NAME

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_raw_data"
OUT_DIR="$HOME/prj/data/RNA_data/Trinity"
TMP_OUT=$SNIC_TMP/trinity

# Trimmomatic
ADAPTERS="/sw/apps/bioinfo/trimmomatic/0.36/rackham/adapters/TruSeq3-PE-2.fa"
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

TRIMMOMATIC_STRING="ILLUMINACLIP:$ADAPTERS:$SEED:$PE_THRESH:$SE_THRESH \
                   MAXINFO:$TARGET_LEN:$STRICTNESS \
                   LEADING:$RM_LEADING \
                   TRAILING:$RM_TRAILING \
                   SLIDINGWINDOW:$SW_GLOBAL \
                   MINLEN:$MINLEN"
SAMPLE_FILE="TO-DO"

mkdir -p $TMP_OUT

# SOFTWARE_NAME SOFTWARE_VERSION
Trinity --seqType fq --max_memory 35G  \
         --samples_file $SAMPLE_FILE \
         --trimmomatic \
         --quality_trimming_params "$TRIMMOMATIC_STRING" \
         --full_cleanup \
         --output $TMP_OUT \
         --CPU 6

cp -r $TMP_OUT/*Trinity.fasta $OUT_DIR
#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 06:00:00
#SBATCH -J trimmomatic_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs Trimmomatic on raw RNA-Seq reads
  
# Load modules
module load bioinfo-tools
module load trimmomatic

# Input/Output Dir
IN_DIR="$HOME/prj/data/raw_data/RNA_raw_data"
OUT_DIR="$HOME/prj/data/RNA_data/trimmomatic"
IN_FILES="ERR2*_1.fastq.gz"
TMP_DIR=$SNIC_TMP/trimmomatic

# ILLUMINACLIP settings
# ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismatches>:
#              <palindrome clip threshold>:<simple clip threshold>
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

# Create tmp output dir
mkdir -p $TMP_DIR

# File name processing
PE_EXT1="_1.fastq.gz"
PE_EXT2="_2.fastq.gz"

# Trimmomatic v0.36
for FILE in $IN_DIR/$IN_FILES;
do
   BASE_NAME=`basename $FILE | cut -d "_" -f 1`
   WD=$OUT_DIR/$BASE_NAME
   TMP_WD=$TMP_DIR/$BASE_NAME
   FWD_FASTQ=$IN_DIR/$BASE_NAME$PE_EXT1
   REV_FASTQ=$IN_DIR/$BASE_NAME$PE_EXT2
   mkdir -p $TMP_WD
   mkdir -p $WD
   trimmomatic PE \
               -threads 2 \
               -basein $FWD_FASTQ $REV_FASTQ \
               -baseout $TMP_WD \
               -summary $WD/$BASE_NAME.summary \
               -validatePairs \
               ILLUMINACLIP:$ADAPTER:$SEED:$PE_THRESH:$SE_TRESH \
               MAXINFO:$TARGET_LEN:$STRICTNESS \
               LEADING:$RM_LEADING \
               TRAILING:$RM_TRAILING \
               SLIDINGWINDOW:$SW_GLOBAL \
               MINLEN:$MINLEN

   # Compress FASTQ files using pbzip2
   for TMP_FILE in $TMP_WD;
      do
         OUT_BASE_NAME=`basename $TMP_FILE`
         pbzip2 --keep -v -p2 -c < $TMP_FILE > $WD/$OUT_BASE_NAME.fastq.bz2
   done;
   rm $TMP_FILE

done;
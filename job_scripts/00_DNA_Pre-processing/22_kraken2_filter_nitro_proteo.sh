#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 00:15:00
#SBATCH --qos=short
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com


# Load modules
module load bioinfo-tools
module load Kraken2

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/kraken2/02_corr_reads_filter_nitro_proteo"
# TMP_OUT_DIR=$SNIC_TMP/kraken2_output

MY_DB="$HOME/Bioinformatics_data/krakenDB/nitro_and_proteo"
IN_FILES="01_trimmed_reads.bz2"
REPORT_FILE="lferriphilum_kraken2_nitro_and_proteo.report"
# OUT_FILE="lferriphilum_kraken2_nitro_and_proteo.out"
CLASS_FILE="lferriphilum_kraken2_nitro_and_proteo_classified.fastq"
UNCLASS_FILE="lferriphilum_kraken2_nitro_and_proteo_unclassified.fastq"

# Create temp output directory
# mkdir -p $TMP_OUT_DIR

# Kraken2 2.0.7-beta-bc14b13
command time -v \
kraken2 --threads 4 \
        --db $MY_DB \
        --report $OUT_DIR/$REPORT_FILE \
        --output /dev/null \
        --classified-out $OUT_DIR/$CLASS_FILE \
        --unclassified-out $OUT_DIR/$UNCLASS_FILE \
        $IN_DIR/$IN_FILES

# Compress FASTQ files using pbzip2

# pbzip2 --keep -v -p6 -m2000 -c < $OUT_DIR/$OUT_FILE > $OUT_DIR/$OUT_FILE.bz2
pbzip2 --keep -v -p4 -m2000 -c < $OUT_DIR/$CLASS_FILE > $OUT_DIR/$CLASS_FILE.bz2
pbzip2 --keep -v -p4 -m2000 -c < $OUT_DIR/$UNCLASS_FILE > $OUT_DIR/$UNCLASS_FILE.bz2



IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/kraken2/02_corr_reads_filter_nitro_proteo"
MY_DB="$HOME/Bioinformatics_data/krakenDB/human"
IN_FILES="lferriphilum_kraken2_nitro_and_proteo_unclassified.fastq.bz2"
REPORT_FILE="lferriphilum_kraken2_human_on_unclassified.report"
UNCLASS_FILE="lferriphilum_kraken2_human_on_unclassified.fastq"

command time -v \
kraken2 --threads 4 \
        --db $MY_DB \
        --report $OUT_DIR/$REPORT_FILE \
        --output /dev/null \
        --unclassified-out $OUT_DIR/$UNCLASS_FILE \
        $IN_DIR/$IN_FILES

pbzip2 --keep -v -p4 -m2000 -c < $OUT_DIR/$UNCLASS_FILE > $OUT_DIR/$UNCLASS_FILE.bz2

bzcat $OUT_DIR/lferriphilum_kraken2_nitro_and_proteo_classified.fastq.bz2 \
$OUT_DIR/lferriphilum_kraken2_human_on_unclassified.fastq.bz2 | pbzip2 -c -p4 -m2000 \
> $OUT_DIR/lferriphilum_kraken2_decontaminated.fastq.bz2

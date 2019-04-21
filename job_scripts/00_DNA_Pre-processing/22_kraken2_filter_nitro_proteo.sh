#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/trimmed_reads"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/kraken2/02_corr_reads_filter_nitro_proteo"

MY_DB="$HOME/Bioinformatics_data/krakenDB/nitro_and_proteo"
IN_FILES="LFerr.trimmedReads.fasta.gz"
REPORT_FILE="LFerr_nitro_and_proteo_kraken2.report"
CLASS_FILE="LFerr_nitro_and_proteo_classified.fastq"
UNCLASS_FILE="LFerr_nitro_and_proteo_unclassified.fastq"

mkdir -p $OUT_DIR

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
pbzip2 -v -p4 -m2000 -c < $OUT_DIR/$CLASS_FILE > $OUT_DIR/$CLASS_FILE.bz2
pbzip2 -v -p4 -m2000 -c < $OUT_DIR/$UNCLASS_FILE > $OUT_DIR/$UNCLASS_FILE.bz2
rm $OUT_DIR/$CLASS_FILE && rm $OUT_DIR/$UNCLASS_FILE


WD=$OUT_DIR
MY_DB="$HOME/Bioinformatics_data/krakenDB/human"
IN_FILES=$UNCLASS_FILE.bz2
REPORT_FILE="LFerr_human_on_unclass_kraken2.report"
UNCLASS_FILE="LFerr_human_on_unclass_unclassified.fastq"

# Kraken2 2.0.7-beta-bc14b13
command time -v \
kraken2 --threads 4 \
        --db $MY_DB \
        --report $WD/$REPORT_FILE \
        --output /dev/null \
        --unclassified-out $WD/$UNCLASS_FILE \
        $WD/$IN_FILES

pbzip2 --keep -v -p4 -m2000 -c < $WD/$UNCLASS_FILE > $WD/$UNCLASS_FILE.bz2
rm $WD/$UNCLASS_FILE

FINAL_OUT="LFerr_decontaminated.fastq.bz2"

bzcat $WD/$CLASS_FILE.bz2 \
$WD/$UNCLASS_FILE.bz2 | pbzip2 -c -p4 -m2000 \
> $WD/$FINAL_OUT

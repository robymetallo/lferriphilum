#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/01_processed_reads/03_BBmerge"


find $IN_DIR -wholename '*_merged.fastq.gz' | while read FILE; do

   BASE_NAME=`basename $FILE _merged.fastq.gz`
   BASE_DIR=`dirname $FILE`
   pigz -cd $FILE | perl -pe 's/\@ERR\d+.\d+ /\@/g' | pigz -9 > "$BASE_DIR/$BASE_NAME""_merged_renamed.fastq.gz"

done;
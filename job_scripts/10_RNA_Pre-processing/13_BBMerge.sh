#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/dedup"

FWD_IN="_OK_1.fastq.gz"
REV_IN="_OK_2.fastq.gz"

for FILE in `find $IN_DIR -type f -name '*_dedup_OK_1.fastq.gz'`
do
   BASE_NAME=`basename $FILE _dedup_OK_1.fastq.gz`
   WD=`dirname $FILE`

   bbmerge-auto.sh in=$WD/$BASE_NAME"_dedup_OK_1.fastq.gz" \
                   in2=$WD/$BASE_NAME"_dedup_OK_2.fastq.gz" \
                   out=$WD/$BASE_NAME"_merged.fastq.gz" \
                   outu=$WD/$BASE_NAME"_FWD_unmerged.fastq.gz" \
                   outu2=$WD/$BASE_NAME"_REV_unmerged.fastq.gz" \
                   rem k=62 \
                   extend2=50 \
                   ecct \
                   verystrict \
                   -Xmx12g \
                   2>&1 | tee $WD/BBMerge_tee.log
done;
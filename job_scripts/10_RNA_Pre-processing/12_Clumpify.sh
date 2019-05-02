#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/dedup"

FWD="_OK_1.fastq.gz"
REV="_OK_2.fastq.gz"
SNG="_singletons.fastq.gz"


TMPDIR="$HOME/clumpify_tmp"
mkdir $TMPDIR
mkdir $OUT_DIR


# Clumpify v38.44
for FILE in `find $IN_DIR -type f -name '*_OK_1.fastq.gz'`
do
   BASE_NAME=`basename $FILE _OK_1.fastq.gz`
   WD=$OUT_DIR/$BASE_NAME
   mkdir $WD

   clumpify.sh in1=$IN_DIR/$BASE_NAME/$BASE_NAME$FWD \
               in2=$IN_DIR/$BASE_NAME/$BASE_NAME$REV \
               out1=$WD/$BASE_NAME"_dedup"$FWD \
               out2=$WD/$BASE_NAME"_dedup"$REV \
               tmpdir=$TMPDIR \
               usetmpdir \
               dedupe \
               groups=auto \
               blocksize=900 \
               -Xmx13g

   clumpify.sh in=$IN_DIR/$BASE_NAME/$BASE_NAME$SNG \
               out=$WD/$BASE_NAME"_dedup"$SNG \
               tmpdir=$TMPDIR \
               usetmpdir \
               dedupe \
               groups=auto \
               blocksize=900 \
               -Xmx13g
   rm -r $TMPDIR
done;
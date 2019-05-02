#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/raw_data/RNA_raw_data"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk"
IN_FILES="ERR2*_1.fastq.gz"

PE_EXT1="_1.fastq.gz"
PE_EXT2="_2.fastq.gz"

O1="_OK_1.fastq.gz"
O2="_OK_2.fastq.gz"
F1="_F_1.fastq.gz"
F2="_F_2.fastq.gz"
SI="_singletons.fastq.gz"
STATS_1="_contaminants.report"
STATS_2="_ref.report"

# BBDuk
for FILE in $IN_DIR/$IN_FILES;
do
   BASE_NAME=`basename $FILE | cut -d "_" -f 1`
   WD=$OUT_DIR/$BASE_NAME
   TMP_WD=$OUT_DIR/$BASE_NAME/tmp
   FWD_FASTQ=$IN_DIR/$BASE_NAME$PE_EXT1
   REV_FASTQ=$IN_DIR/$BASE_NAME$PE_EXT2
   FWD_OUT_OK=$WD/$BASE_NAME$O1
   REV_OUT_OK=$WD/$BASE_NAME$O2
   FWD_OUT_F=$WD/$BASE_NAME$F1
   REV_OUT_F=$WD/$BASE_NAME$F2
   SINGLETONS=$WD/$BASE_NAME$SI
   REPORT_1=$WD/$BASE_NAME$STATS_1
   REPORT_2=$WD/$BASE_NAME$STATS_2
   PLOT_DIR=$WD/plot

   mkdir -p $TMP_WD
   mkdir -p $WD
   mkdir -p $PLOT_DIR

   command time bbduk.sh in1=$FWD_FASTQ \
                         in2=$REV_FASTQ \
                         out=$FWD_OUT_OK \
                         out2=$REV_OUT_OK \
                         outm=$FWD_OUT_F \
                         outm2=$REV_OUT_F \
                         outs=$SINGLETONS \
                         stats=$REPORT_1 \
                         refstats=$REPORT_2 \
                         ref=adapters,phix,artifacts \
                         ktrim=r \
                         k=23 \
                         mink=11 \
                         hdist=1 \
                         tpe \
                         tbo \
                         qtrim=r \
                         trimq=10 \
                         maq=10 \
                         minlen=75 \
                         ftm=5 \
                         bhist=$PLOT_DIR/bhist.txt \
                         qhist=$PLOT_DIR/qhist.txt \
                         gchist=$PLOT_DIR/gchist.txt \
                         aqhist=$PLOT_DIR/aqhist.txt \
                         lhist=$PLOT_DIR/lhist.txt \
                         gcbins=auto \
                         prealloc \
                         -Xmx10g \
                         showspeed \
                         2>&1 | tee $WD/BBDuk_tee.log
done;

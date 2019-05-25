#!/bin/bash -l

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/QUAST"
READS_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/01_processed_reads"

REFERENCE="$HOME/Bioinformatics_data/lferriphilum/data/raw_data/reference/OBMB01.fasta"

# Decompress reads
bzcat $READS_DIR"/01_trimmed_reads.fasta.bz2" \
> $READS_DIR"/01_trimmed_reads.fasta"
bzcat $READS_DIR"/02_decontaminated_reads.fasta.bz2" \
> $READS_DIR"/02_decontaminated_reads.fasta"

for FILE in $IN_DIR/*.fasta; do
   # QUAST v5.0.2
   WD=${FILE#*_LFerr_}
   WD=`basename $WD .fasta`
   WD=$OUT_DIR/$WD

   mkdir $WD


   if echo $WD | grep -q "without_contaminants_"; then
      READS=$READS_DIR"/02_decontaminated_reads.fasta"
   else
      READS=$READS_DIR"/01_trimmed_reads.fasta"
   fi

   /bin/python $HOME/Bioinformatics_Programs/quast-5.0.2/quast.py \
               -t $(nproc) \
               --glimmer \
               --circos \
               --rna-finding \
               --conserved-genes-finding \
               --k-mer-stats \
               --pacbio $READS \
               -o $WD \
               -r $REFERENCE \
               $FILE \
               2>&1 | tee $WD/QUAST_tee.log
done;

rm $READS_DIR"/01_trimmed_reads.fasta"
rm $READS_DIR"/02_decontaminated_reads.fasta"

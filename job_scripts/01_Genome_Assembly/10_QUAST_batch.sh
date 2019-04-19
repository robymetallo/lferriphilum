#!/bin/bash -l
# This script runs QUAST to evaluate the assembly produced by canu

# Input/Output Dir
IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/02_contigs"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/QUAST/"

REFERENCE="$HOME/Bioinformatics_data/lferriphilum/data/raw_data/reference/OBMB01.fasta"

alias quast=""

bzcat "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/02_decontaminated_reads.fasta.bz2" \
> "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/02_decontaminated_reads.fasta"

bzcat "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/01_trimmed_reads.fasta.bz2" \
> "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/01_trimmed_reads.fasta"

for FILE in $IN_DIR/*.fasta; do
   # QUAST v5.0.2
   WD=${FILE#*_LFerr_}
   WD=`basename $WD .fasta`
   WD=$OUT_DIR/$WD

   mkdir $WD

   if echo $WD | grep -q "without_contaminants"; then
      READS="$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/02_decontaminated_reads.fasta"
   else
      READS="$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/01_trimmed_reads.fasta"
   fi

   /bin/python $HOME/Bioinformatics_Programs/quast-5.0.2/quast.py \
               -t 4 \
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

rm "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/02_decontaminated_reads.fasta"
rm "$HOME/Bioinformatics_data/lferriphilum/analysis/01_processed_reads/DNA/01_trimmed_reads.fasta"

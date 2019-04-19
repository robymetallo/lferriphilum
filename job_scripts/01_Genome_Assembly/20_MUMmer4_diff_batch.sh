#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:15:00
#SBATCH -J MUMmer4_lferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com
#SBATCH --qos=short

# This script runs MUMmer4 to evaluate the assembly produced by canu
  
# Load modules
module load bioinfo-tools
module load MUMmer/4.0.0beta2

OUT_DIR="$HOME/prj/data/DNA_data/MUMmer4"
PREFIX="mummer4"

# Settings:
REFERENCE="$HOME/prj/data/raw_data/reference/OBMB01.fasta"
CONTIGS="$HOME/prj/analysis/02_contigs/*.fasta"

# MUMmer/4.0.0beta2

for CONTIG in $CONTIGS; do
   WD=${CONTIG#*_LFerr_}
   BASE_NAME=`basename $WD .fasta`
   WD=$OUT_DIR/$BASE_NAME

   mkdir $WD && cd $WD

   dnadiff -p $BASE_NAME \
         $REFERENCE \
         $CONTIG \
         2>&1 | tee MUMmer4_tee.log

   mkdir $WD/plot
   mummerplot -p $WD/plot \
            -R $WD/$BASE_NAME.rdiff\
            -Q $WD/$BASE_NAME.qdiff \
            --layout \
            --title "$BASE_NAME VS Reference (0BMB01)" \
            $WD/$BASE_NAME.delta \
            2>&1 | tee MUMmer4_plot_tee.log
done;


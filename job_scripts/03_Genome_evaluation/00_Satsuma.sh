#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 06:00:00
#SBATCH -J BWA_RNA_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs Satsuma to perform Synteny analysis between the genome assembled by me and the reference

SatsumaSynteny -q $CONTIG \
               -r $REFERENCE \
               -o $OUT_DIR



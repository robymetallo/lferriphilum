#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 5
#SBATCH -t 00:30:00
#SBATCH -J kraken2_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs kraken2 to check for
# reads contamination in fastq.gz files
  
# Load modules
module load bioinfo-tools
module load Kraken2


# IN_DIR="$HOME/prj/data/raw_data/DNA_raw_data"
IN_DIR="$HOME/prj/data/raw_data/reference"
OUT_DIR="$HOME/prj/data/DNA_data/kraken2"

# Copy Kraken2 DB on local node
MY_DB_DIR=$SNIC_TMP/Kraken2
MY_DB=$MY_DB_DIR/${KRAKEN2_DEFAULT_DB##*/}
mkdir -p $MY_DB
cp -av $KRAKEN2_DEFAULT_DB/* $MY_DB/

# Custom settings:

# IN_FILES="ERR2028*.fastq.gz"
IN_FILES="OBMB01.fasta"

# Kraken2 2.0.7-beta-bc14b13
kraken2 --threads 5 $IN_DIR/$IN_FILES


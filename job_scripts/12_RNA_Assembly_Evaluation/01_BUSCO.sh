#!/bin/bash

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 00:15:00
#SBATCH --qos=short
#SBATCH -J BUSCO_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# Load modules
module load bioinfo-tools
module load BUSCO/3.0.2b

OUT_DIR="$HOME/prj/data/RNA_data/BUSCO"

TRANS_ASSEMBLY="$HOME/prj/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
PREFIX="LFerr"
DB=$BUSCO_LINEAGE_SETS/bacteria_odb9


mkdir -p $OUT_DIR

python $BUSCO -i $TRANS_ASSEMBLY \
                -o $PREFIX \
                -l $DB \
                -c $(nproc) \
                --mode tran \
                --long \
                --tarzip \
                2>&1 | tee $OUT_DIR/BUSCO_tee.log

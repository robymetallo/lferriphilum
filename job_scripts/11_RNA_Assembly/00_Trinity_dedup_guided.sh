#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 24:00:00
#SBATCH -J Trinity_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

  
# Load modules
module load bioinfo-tools
module load trinity/2.8.2
module load samtools/1.9
module load Salmon/0.9.1
module load jellyfish/2.2.6

# Input/Output Dir
IN_DIR="$HOME/prj/analysis/RNA/02_aligned_reads"
OUT_DIR="$HOME/prj/data/RNA_data/Trinity"
TMP_OUT=$SNIC_TMP/trinity

BAM_FILE="LFerr_dedup_sorted.bam"

mkdir -p $TMP_OUT
mkdir -p $OUT_DIR

# Trinity v2.8.2
command time -v Trinity --genome_guided_bam $IN_DIR/$BAM_FILE \
                        --genome_guided_max_intron 1 \
                        --max_memory 64G \
                        --output $TMP_OUT \
                        --CPU 10 \
                        --bflyHeapSpaceMax 12G \
                        --bflyGCThreads 1 \
                        --bflyCalculateCPU \
                        2>&1 | tee -a $OUT_DIR/Trinity_tee.log

cp -r $TMP_OUT/*Trinity.fasta $OUT_DIR/

command time -v tar --use-compress-program=pbzip2 -cvf \
                $OUT_DIR/Trinity_WD.tar.bz2 \
                $TMP_OUT \
                2>&1 | tee $OUT_DIR/tar_tee.log

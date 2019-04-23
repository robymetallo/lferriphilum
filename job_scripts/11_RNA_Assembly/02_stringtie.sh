#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 02:00:00
#SBATCH -J Stringtie_LFerr
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/HISAT2"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Stringtie"

BAM="LFerr_Transcriptome_sorted.bam"
REF_ANNOTATION="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/prokka/LFerr.gff"
TRANSCRIPT_LVL="LFerr_transcript_levels.tsv"
OUT_GTF="LFerr_transcripts.gtf"

mkdir -p $OUT_DIR

stringtie $IN_DIR/$BAM \
          -p 4 \
          -G $REF_ANNOTATION \
          -A $OUT_DIR/$TRANSCRIPT_LVL \
          2>&1 | tee $OUT_DIR/stringtie_tee.log
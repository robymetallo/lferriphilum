IN_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBDuk/merged"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/BBMerge"

FWD_IN="LFer_RNA-Seq_FWD_clumped.fastq.bz2"
REV_IN="LFer_RNA-Seq_REV_clumped.fastq.bz2"
OUT_MERGED="LFer_RNA-Seq_FWD_clumped_merged.fastq.bz2"
REV_OUT_MERGED="LFer_RNA-Seq_REV_clumped_merged.fastq.bz2"
REV_OUT_UNMERGED="LFer_RNA-Seq_REV_clumped_unmerged.fastq.bz2"

bbmerge-auto.sh in=$IN_DIR/$FWD_IN in2=$IN_DIR/$REV_IN \
                out=$OUT_DIR/$OUT_MERGED \
                outu=$OUT_DIR/$FWD_OUT_UNMERGED outu2=$OUT_DIR/$REV_OUT_UNMERGED \
                rem k=62 \
                extend2=50 \
                ecct \
                verystrict \
                -Xmx12g \
                2>&1 | tee $OUT_DIR/BBMerge_tee.log
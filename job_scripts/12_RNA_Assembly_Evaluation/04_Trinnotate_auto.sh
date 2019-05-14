#!/bin/bash

TRINOTATE_HOME="$HOME/Bioinformatics_Programs/Trinotate-git"

TRANS="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"

auto/autoTrinotate.pl --Trinotate_sqlite $TRINOTATE_HOME"/Trinotate.sqlite" \
                      --transcripts $TRANS \
                      --gene_to_trans_map
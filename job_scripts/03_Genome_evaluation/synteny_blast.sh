#!/bin/bash

WD="$HOME/Bioinformatics_data/lferriphilum/data/DNA_data/synteny_comparison"

SUB="12_LFerr_without_contaminants_main_contig.fasta"
QUERY="OBMB01.fasta"
OUT="LFerr_main_vs_Reference.blastn"

blastn -subject $WD/$SUB \
        -query $WD/$QUERY \
        -outfmt 6 > $WD/$OUT

QUERY="Thermodesulfovibrio_yellowstonii_GCF_000020985.1_ASM2098v1.fasta"
OUT="LFerr_main_vs_TYellow.blastn"

blastn -subject $WD/$SUB \
        -query $WD/$QUERY \
        -outfmt 6 > $WD/$OUT

QUERY="Leptospirillum_ferrooxidans_GCF_000284315.1_ASM28431v1_genomic.fasta"
OUT="LFerr_main_vs_LFerrooxidans.blastn"
blastn -subject $WD/$SUB \
        -query $WD/$QUERY \
        -outfmt 6 > $WD/$OUT
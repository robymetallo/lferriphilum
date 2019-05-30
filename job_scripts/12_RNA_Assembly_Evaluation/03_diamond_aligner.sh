#!/bin/bash

IN_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome"
OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/data/RNA_data/Diamond"

REFERENCE="$HOME/Bioinformatics_data/proteins_db/FASTA/Nitrospira_genbank/ncbi-genomes-2019-05-13/*.faa.gz"

DB_DIR="$HOME/Bioinformatics_data/proteins_db/diamond_db"
DB_NAME="Nitrospira_Genbank"
QUERY="LFerr_Transcriptome_Assembly_Trinity.fasta"
ALIGNED="LFerr_Transcriptome_Assembly_Trinity_aligned.blastx"
UNALIGNED="LFerr_Transcriptome_Assembly_Trinity_unaligned.blastx"
REPORT="LFerr_Transcriptome_Assembly_Trinity_diamond.report"
TAX_DIR="$HOME/Bioinformatics_data/taxon_ncbi"
TAX_MAP=$TAX_DIR"/prot.accession2taxid.gz"
TAX_NODES=$TAX_DIR"/taxdmp.zip"

mkdir -p $DB_DIR
cd $DB_DIR

diamond makedb --in <(pigz -dc $REFERENCE) \
               --db $DB_NAME \
               --taxonmap $TAX_MAP \
               --taxonnodes $TAX_NODES \

DB=$DB_DIR/$DB_NAME".dmnd"

command time -v \
diamond blastx \
        -o $OUT_DIR/$REPORT \
        -f 6 \
        --header \
        --query $IN_DIR/$QUERY \
        --al $OUT_DIR/$ALIGNED \
        --un $OUT_DIR/$UNALIGNED \
        --id 60 \
        --query-cover 75 \
        --unal 1 \
        --max-target-seqs 25 \
        --sensitive \
        --masking 1 \
        --db $DB \
        2>&1 | tee $OUT_DIR/diamond_tee.log
#!/bin/bash

OUT_DIR="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/04_assembly_evaluation/BLAST"
DB_DIR="$HOME/Bioinformatics_data/nucleotides_db/BLAST/LFerr_assembly"

DB_NAME="LFerr_genome_assembly"
DB_TITLE="Leptospirilum_Ferriphilum_Genome_Assembly"
REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/02_contigs/20_LFerr_genome_assembly_final.fasta"

TRANS_ASSEMBLY="$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"

mkdir -p $DB_DIR
mkdir -p $OUT_DIR

command time -v \
makeblastdb -in "$REFERENCE" \
            -dbtype nucl -out \
            "$DB_DIR/$DB_NAME" \
            -title "$DB_TITLE" \
            2>&1 | tee "$DB_DIR/$DB_NAME"_makeblastdb.log

DB="$DB_DIR/$DB_NAME"
TABLE_HEADER="Query Seq-id\tSubject Seq-id\tPercentage of identical matches\t\
Alignment length\tNumber of mismatches\tNumber of gap openings\t\
Start of alignment in query\tEnd of alignment in query\t\
Start of alignment in subject\tEnd of alignment in subject\t\
Expect value\tBit score\tPercentage of positively scoring matches"

echo -e $TABLE_HEADER > "$OUT_DIR/LFerr_Trinity_vs_genome_assembly.blastn"

command time -v \
blastn -query "$TRANS_ASSEMBLY" \
       -db "$DB" \
       -num_threads $(nproc) \
       -outfmt "6 std ppos qlen slen" \
       1>> "$OUT_DIR/LFerr_Trinity_vs_genome_assembly.blastn" \
       | tee "$OUT_DIR/LFerr_Trinity_vs_genome_assembly.blastn.log"


REFERENCE="$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/LFerr_merged.ffn"
DB_NAME="LFerr_genome_annotation"
DB_TITLE="Leptospirilum_Ferriphilum_Genome_Assembly_Annotation"

command time -v \
makeblastdb -in "$REFERENCE" \
            -dbtype nucl -out \
            "$DB_DIR/$DB_NAME" \
            -title "$DB_TITLE" \
            2>&1 | tee "$DB_DIR/$DB_NAME"_makeblastdb.log

echo -e $TABLE_HEADER > "$OUT_DIR/LFerr_Trinity_vs_genome_annotation.blastn"

DB="$DB_DIR/$DB_NAME"

command time -v \
blastn -query "$TRANS_ASSEMBLY" \
       -db "$DB" \
       -num_threads $(nproc) \
       -outfmt "6 std ppos qlen slen" \
       1>> "$OUT_DIR/LFerr_Trinity_vs_genome_annotation.blastn" \
       | tee "$OUT_DIR/LFerr_Trinity_vs_genome_annotation.blastn.log"
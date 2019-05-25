import csv
import csv
from Bio import SeqIO

prokka_fasta = "$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/prokka/20_LFerr_genome_assembly_final/LFerr.ffn"
eggNOG_ann = "$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/eggNOG-mapper/LFerr.ffn.emapper.annotations"
output_name = "$HOME/Bioinformatics_data/lferriphilum/analysis/DNA/04_genome_annotation/LFerr_merged.ffn"


def read_csv():
    eggNOG_annotation = {}
    with open(eggNOG_ann) as csvfile:
        data = csv.reader(csvfile, delimiter="\t")
        for line in data:
            eggNOG_annotation[line[0]] = [line[4], line[-1]]
    return eggNOG_annotation


def main():
    eggNOG_annotation = read_csv()
    prokka_annotation = SeqIO.parse(prokka_fasta, "fasta")
    with open(output_name, "w") as out_fasta:
        for record in prokka_annotation:
            if record.id in eggNOG_annotation.keys():
                record.description = (f"Prokka: {record.description.lstrip(record.id)}" +
                                      f"; eggNOG[{eggNOG_annotation[record.id][0]}]: " +
                                      f"{eggNOG_annotation[record.id][1]}")
            SeqIO.write(record, out_fasta, "fasta")


main()

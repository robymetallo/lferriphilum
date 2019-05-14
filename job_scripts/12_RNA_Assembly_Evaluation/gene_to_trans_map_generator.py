from Bio import SeqIO
import re

trinity_assembly = "$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
output_name = "$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity_gene_to_trans_map"
regexp = r"(TRINITY_DN\d+_c\d+_g\d+)"


def main():
    multifasta = SeqIO.parse(trinity_assembly, "fasta")
    with open(output_name, "w") as text_file:
        for record in multifasta:
            gene = re.search(regexp, record.id).group(0)
            text_file.write(f"{gene}\t{record.id}\n")


main()

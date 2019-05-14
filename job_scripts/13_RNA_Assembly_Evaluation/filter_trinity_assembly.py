from Bio import SeqIO
import csv

base_dir = "$HOME/Bioinformatics_data/lferriphilum/analysis/RNA/"
base_name = "LFerr_Trinity_vs_genome_annotation"

trinity_assembly = base_dir + "03_assembled_transcriptome/LFerr_Transcriptome_Assembly_Trinity.fasta"
blast_file = base_dir + "04_assembly_evaluation/BLAST/" + base_name + ".blastn"
out_match = base_dir + \
    "03_assembled_transcriptome/" + base_name + "_match.fasta"
out_umatch = base_dir + \
    "03_assembled_transcriptome/" + base_name + "_unmatch.fasta"


def read_csv():
    blast_table = {}
    with open(blast_file) as csvfile:
        data = csv.reader(csvfile, delimiter="\t")
        for line in data:
            # Query Seq-id, Percentage of identical matches, Alignment length,
            # Expected value, Percentage of positively scoring matches
            blast_table[line[0]] = [line[0], line[2], line[3],
                                    line[10], line[12]]
    return blast_table


blast_table = read_csv()
multifasta = SeqIO.parse(trinity_assembly, "fasta")
with open(out_match, "w") as match:
    with open(out_umatch, "w") as umatch:
        for record in multifasta:
            if record.id in blast_table.keys():
                # t_id = blast_table[record.id][0]
                # pct_id = blast_table[record.id][1]
                # algn_len = blast_table[record.id][2]
                # e_val = blast_table[record.id][3]
                t_id, pct_id, algn_len, e_val, pct_pos = blast_table[record.id]

                record.description += (f" blastn=[seq-id: {t_id}, " +
                                       f"identity: {pct_id}%, " +
                                       f"alignment-len: {algn_len}, " +
                                       f"e-value: {e_val}, " +
                                       f"pos-scoring: {pct_pos}%]")

                SeqIO.write(record, match, "fasta")
            else:
                SeqIO.write(record, umatch, "fasta")

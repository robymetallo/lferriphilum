import numpy as np
import matplotlib.pyplot as plt
import sys


def extract_significant_data(input_file):
    raw_table = np.genfromtxt(input_file, dtype=None, delimiter="\t",
                              encoding="UTF-8", usecols=(0, 3, 5))
    polished_table = []
    # print(raw_table)
    for row in raw_table:
        # print(type(row[1]))
        if (row[0] > 1.0) and (row[1] == "P") or row[2] == "unclassified":
            polished_table.append([row[2].strip(), row[0]])
    return polished_table


def plot(data, plot_name, plot_title, reads_num):

    width = 0.35
    bins = [row[0] for row in data]
    freq = [row[1] for row in data]
    plot = plt.bar(bins, freq, width)

    xlocs, _ = plt.xticks()
    for rect in plot:
        height = rect.get_height()
        plt.text(rect.get_x()+rect.get_width()/2., height + 0.1,
                 f"{height:.2f}%", ha='center', va='bottom')

    plt.text(0.17, 85, f"N. of reads: {reads_num}", horizontalalignment='center',
             verticalalignment='center')

    plt.xlabel("Phylum", fontsize=14)
    plt.ylabel("Frequency (%)", fontsize=14)
    plt.title(plot_title, fontsize=18)
    plt.yticks(np.arange(0, 100, 10), fontsize=12)
    plt.xticks(rotation=35, fontsize=10)
    plt.tight_layout
    plt.subplots_adjust(bottom=0.22)
    plt.savefig(plot_name, dpi=300)
    plt.clf()


def main():
    """Usage: This scripts requires 3 arguments:
       1. Path to Kraken2's report file;
       2. Path to output (plot);
       3. Title of the plot;
       4. Reads num;"""

    input_file = sys.argv[1]
    plot_name = sys.argv[2]
    plot_title = sys.argv[3]
    reads_num = sys.argv[4]
    print("Processing file:", input_file)
    data = extract_significant_data(input_file)
    print(data)
    plot(data, plot_name, plot_title, reads_num)


main()

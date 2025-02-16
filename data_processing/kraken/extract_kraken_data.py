import numpy as np
import glob
import os.path
import matplotlib.pyplot as plt
import sys


def extract_significant_data(input_file):
    raw_table = np.genfromtxt(
        input_file, dtype=None, delimiter="\t", encoding="UTF-8", usecols=(0, 3, 5))
    polished_table = []
    # print(raw_table)
    for row in raw_table:
        # print(type(row[1]))
        if (row[0] > 1.0) and (row[1] == "P"):
            polished_table.append([row[2].strip(), row[0]])
    return polished_table


def plot(data, bins, plot_name):
    width = 0.35
    bot_coord = 0
    for key, value in data.items():
        plt.bar(bins, value, width, bottom=bot_coord, label=key)
        bot_coord += value

    plt.legend()
    plt.xlabel("Samples", fontsize=14)
    plt.ylabel("Frequency (%)", fontsize=14)
    plt.title("Kraken2: Classified RAW Reads", fontsize=18)
    plt.yticks(np.arange(0, 75, 5), fontsize=12)
    plt.xticks(rotation=35, fontsize=10)
    plt.tight_layout
    plt.subplots_adjust(bottom=0.22)
    plt.savefig(plot_name, dpi=300)
    plt.clf()


def main():
    """Usage: This scripts requires 2 arguments:
       1. Path to the directory with Kraken2's report files;
       2. Path to output (plot);"""

    input_dir = sys.argv[1]
    plot_name = sys.argv[2]
    file_glob = "*.report"
    d = dict()
    input_list = glob.glob(input_dir + file_glob)
    bins = []
    for file in input_list:
        print("Processing file:", file)
        data = extract_significant_data(file)
        bins.append(os.path.basename(os.path.splitext(file)[0]))
        for key, val in data:
            if key in d:
                d[key] = np.append(d[key], val)
            else:
                d[key] = np.array(val)
    print(d)
    plot(d, bins, plot_name)


main()

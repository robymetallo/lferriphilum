#!/bin/bash

# Creating an array of the modules required to install and run circlator
# NOTE: The authors advise using spades 3.7.1,
#       which is not available on UPPMAX
MODULE_LIST=("bioinfo-tools" "bwa/0.7.17" "prodigal/2.6.3" \
             "samtools/1.9" "MUMmer/4.0.0beta2" "canu/1.7" \
             "spades/3.12.0")

# Install and update pip and setuptools
python3 -m ensurepip --user
python3 -m pip install pip --upgrade --user
python3 -m pip install setuptools --upgrade --user

# Load modules required by circlator
for MODULE in "${MODULE_LIST[@]}"
do
   module load "$MODULE"
done

# Install circlator
python3 -m pip install circlator --user

# Unload modules before updating PATH
for MODULE in "${MODULE_LIST[@]}"
do
   module unload "$MODULE"
done

# Adding circlator to PATH
echo -n "# Adding python packages to $PATH\n"\
        "export PATH=$PATH:"$HOME"/.local/bin" >> $HOME"/.bashrc"

export PATH=$PATH:"$HOME"/.local/bin

# Re-load modules
for MODULE in "${MODULE_LIST[@]}"
do
   module load "$MODULE"
done

# Test circlator
circlator progcheck

# Add minimus2 to path

cp "/sw/apps/bioinfo/AMOS/3.1.0/milou/bin/minimus2.acf" $HOME"/bin/minimus2"
chmod 700 $HOME"/bin/minimus2"

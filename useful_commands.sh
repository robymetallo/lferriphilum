## UPPMAX commands
# Allocate an interactive compute session
salloc -A ***REMOVED*** -p core -n 4 -t 1:00:00

# Look for jobs in queue
squeue | grep rober

# Submit batch job
sbatch script_name



## UNIX commands
# Set permission of all files in a dir to 440
find . -type f -exec chmod 400 -- {} +

# Set permission of all folders in a dir to 700
find . -type d -exec chmod 700 -- {} +

# Compress folder and subfolders
tar  -c input_folder | pbzip2 --keep -v -p4 -m2000 > compressed_folder.tar.bz2

# Compress fastq files with pbzip2
pbzip2 --keep -v -p4 -m2000 -c < input_file.fastq > output_file.fastq.bz2

# Convert .gz to .bz2

for file in *.gz; do
   name=`basename $file .gz`
   gzip -cd $file | pbzip2 -c -p4 -m2000 > $name.bz2
done;

# Tee usage
program 2>&1 | tee program.log

# Copy files that match a pattern
find . -type f -name '*key*' -exec cp '{}' dst/ ';'
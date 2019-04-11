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

# Set permission of all folders in a dir to 550
find . -type d -exec chmod 500 -- {} +

#!/bin/bash -l

#SBATCH -A ***REMOVED***
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:00:00
#SBATCH -J JOB_NAME_l_ferriphilum
#SBATCH --mail-type=ALL
#SBATCH --mail-user robymetallo@users.noreply.github.com

# This script runs TOOL_NAME to SHORT_DESCRIPTION
  
# Load modules
module load bioinfo-tools
# module load MODULE_NAME

# Input/Output Dir
IN_DIR="$HOME/prj/input"
OUT_DIR="$HOME/prj/output"

# Init operations
# Set ENV variable(s)
# Create directories etc...

# Settings:
SETT_1="change_me"
SETT_2="me_too!"

# SOFTWARE_NAME SOFTWARE_VERSION
foo --param1 $SETT_1 \
   --param2 $SETT_2

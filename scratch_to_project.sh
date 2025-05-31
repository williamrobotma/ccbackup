#!/usr/bin/env bash

usage() { echo "Usage: $0 [-d <string>] [-t <H:M:S>] [-m <string>] PROJECT_NAME" 1>&2; exit 1; }

def_dest_dir="${HOME}/nearline/${SLURM_ACCOUNT}/${USER}/"

slurm_time="12:00:00"
slurm_mem="32G"
cpus=1
compress=0

while getopts ":d:t:m:c:z" flag; do
    case $flag in
        d) # Handle the -d flag with an argument
        dest_dir=$OPTARG;;
        t) # Handle the -t flag with an argument
        slurm_time=$OPTARG;;
        m) # Handle the -m flag with an argument
        slurm_mem=$OPTARG;;
	c) cpus=$OPTARG;;
	z) compress=1;;
        \?) echo "$0: Error: Invalid option: -${OPTARG}"; usage;;
        :) echo "$0: Error: option -${OPTARG} requires an argument"; usage;;
   esac
done

shift $((OPTIND - 1))
scratch_proj="${1}"
dest_dir="${def_dest_dir}"

dest_fname="${scratch_proj}.$(date +'%FT%H%M%z').tar"
if [ $compress == 1 ]; then
    dest_fname="${dest_fname}.zst"
fi

dest_path="${dest_dir}/${dest_fname}"
# cd "${HOME}/scratch/"

# echo "${PWD}"
# echo "${scratch_proj}"
# echo "${dest_path}"

mkdir -p "logs"

set -x

sbatch --export=ALL,origin_dir="${HOME}/scratch/",origin_basename="${scratch_proj}",dest_targz_path="${dest_path}",compress=$compress \
    --mem="${slurm_mem}" --cpus-per-task=$cpus --time="${slurm_time}" --output="logs/${dest_fname}.log" compress_job.sh




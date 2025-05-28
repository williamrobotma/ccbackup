#!/usr/bin/env bash

def_dest_dir="${HOME}/nearline/${SLURM_ACCOUNT}/${USER}/"

slurm_time="1:0:0"
slurm_mem="4G"

while getopts ":d:t:m:" flag; do
    case $flag in
        d) # Handle the -d flag with an argument
        dest_dir=$OPTARG;;
        t) # Handle the -t flag with an argument
        slurm_time=$OPTARG;;
        m) # Handle the -m flag with an argument
        slurm_mem=$OPTARG;;
       \?) echo "$0: Error: Invalid option: -${OPTARG}" >&2; exit 1;;
        :) echo "$0: Error: option -${OPTARG} requires an argument" >&2; exit 1;;
   esac
done

shift $((OPTIND - 1))
scratch_proj="${1}"
dest_dir="${def_dest_dir}"

dest_fname="${scratch_proj}.$(date +'%FT%H%M%z').tar.gz"
dest_path="${dest_dir}/${dest_fname}"
# cd "${HOME}/scratch/"

# echo "${PWD}"
# echo "${scratch_proj}"
# echo "${dest_path}"

mkdir -p "logs"

set -x

sbatch --export=ALL,origin_dir="${HOME}/scratch/",origin_basename="${scratch_proj}",dest_targz_path="${dest_path}" --mem="${slurm_mem}" --time="${slurm_time}" --output="logs/${dest_fname}.log" compress_job.sh




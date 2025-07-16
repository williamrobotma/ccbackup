#!/usr/bin/env bash

usage() { echo "Usage: [-t <H:M:S>] [-m <string>] [-c <int>] [-a <string>] ARCHIVE_PATH" 1>&2; exit 1; }

# def_dest_dir="${HOME}/nearline/${SLURM_ACCOUNT}/${USER}/"

slurm_time="12:00:00"
slurm_mem="32G"
cpus=1
compress=0
afterok=""

while getopts ":t:m:c:a:" flag; do
    case $flag in
        t) # Handle the -t flag with an argument
        slurm_time=$OPTARG;;
        m) # Handle the -m flag with an argument
        slurm_mem=$OPTARG;;
        c) cpus=$OPTARG;;
        a) afterok="--depend=afterok:${OPTARG}";;
        \?) echo "$0: Error: Invalid option: -${OPTARG}"; usage;;
        :) echo "$0: Error: option -${OPTARG} requires an argument"; usage;;
   esac
done

shift $((OPTIND - 1))
dest_path="${1}"

dest_fname=$(basename "${dest_path}")

# Remove the date pattern and extension
scratch_proj="${dest_fname%%.[0-9][0-9][0-9][0-9]-*}"

extract_dirname="${dest_fname%%.tar.*}"


mkdir -p "logs"

mkdir -p "${HOME}/scratch/${extract_dirname}"

set -x

sbatch --export=ALL,origin_dir="${HOME}/scratch/${extract_dirname}",origin_basename="${scratch_proj}",dest_targz_path="${dest_path}" \
    --mem="${slurm_mem}" --cpus-per-task=$cpus --time="${slurm_time}" --output="logs/extract-${dest_fname}.log" $afterok decompress_job.sh




#!/bin/bash
#SBATCH --cpus-per-task=2

set -x

start=`date +%s`

cd "${origin_dir}"
tar --exclude="${origin_basename}/.git" --exclude="${origin_basename}/.venv" -cvzf "${dest_targz_path}" "${origin_basename}"


end=`date +%s`
echo "script time: $(($end-$start))"


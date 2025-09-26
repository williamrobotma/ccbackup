#!/bin/bash
# #SBATCH --cpus-per-task=2

set -x

start=`date +%s`

cd "${origin_dir}"
if [ $compress == 1 ]; then
    # tar --exclude="${origin_basename}/.git" --exclude="${origin_basename}/.venv" --exclude="__pycache__" -I "zstd -8 -T0" -cvf "${dest_targz_path}" "${origin_basename}"
    tar --exclude="${origin_basename}/.venv" --exclude="__pycache__" -I "zstd -8 -T0" -cvf "${dest_targz_path}" "${origin_basename}"
else
    # tar --exclude="${origin_basename}/.git" --exclude="${origin_basename}/.venv" --exclude="__pycache__" -cvf "${dest_targz_path}" "${origin_basename}"
    tar --exclude="${origin_basename}/.venv" --exclude="__pycache__" -cvf "${dest_targz_path}" "${origin_basename}"
fi

end=`date +%s`
echo "script time: $(($end-$start))"


#!/usr/bin/env bash


set -x

start=`date +%s`

# mkdir -p "${origin_dir}"
cd "${origin_dir}"

if [[ $dest_targz_path == *.zst ]]; then
    tar --use-compress-program=unzstd -xvf "${dest_targz_path}"
else
    tar -xvf "${dest_targz_path}"
fi

mv "${origin_basename}/*" "${origin_dir}/" && rm -r "${origin_basename}"

end=`date +%s`
echo "script time: $(($end-$start))"

#!/bin/bash
#Copyright (C) 2017 Hanyuan Liu (lhy2871@126.com)
set -u #use utf-8
LANG="" #use default language coding

opath="${1%/*}"
newpath="${opath%/*}"

newfileName="`basename ${1%_*}`""_20"".ac3"
log=${newpath}/"_amixLog_""${newfileName}"".log"
#echo -e "\n\033[42;37;1mProgressing...\033[0m\n"

ffmpeg -i "$1" -i "$2" -filter_complex "[0:a][1:a]amerge=inputs=2[aout]" -map "[aout]" -c:a ac3 "${newpath}"/"_""${newfileName}" 2>&1 | tee "${log}"

echo -e "\n\033[42;37;1mFinished at <--`date`-->\033[0m\n"

exit 0

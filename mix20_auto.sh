#!/bin/bash
#Copyright (C) 2019 Hanyuan Liu (lhy2871@126.com)
set -u #use utf-8
LANG="" #use default language coding
opath="$1" #get the latest file folder which contans the main files
newpath="$1"

newfileName="_""${1##*_}""_2ch"".ac3"
log="$1""/""_mix51Log""${newfileName}"".log"
wavfile=(L R);

#/GenereateLogName

function mix20 {
    if [ -s "${newfileName}" ];then
        echo -e "\033[41;37;5m\nAlready Have ac3 file\n\033[0m"
        return 1;
    else
    	ffmpeg -hide_banner -i "${wavfile[0]}" -i "${wavfile[1]}" -filter_complex "[0:a][1:a]amerge=inputs=2[aout]" -map "[aout]" -c:a ac3 "${newpath}"/"${newfileName}" 2>&1 | tee "${log}"
    fi
}

function show_error {
	echo -e "\033[41;37;5m\nSource folder is empty.\nMIX20 FAILED\n\033[0m"
}

function scandir {
    cd "$1" 
    for fileName in $(find . -type f ! -name ".*" -print)
    do
    	local fileName1=$(echo ${fileName} | tr [a-z] [A-Z])
            if [ "${fileName1:0-5}" == "L.WAV" ];then
            	wavfile[0]="${fileName}"
            elif [[ "${fileName1:0-5}" == "R.WAV" ]]; then
            	wavfile[1]="${fileName}"
        	fi
    done
    cd "$1"
    if [ "${wavfile[0]}" == "L" ]; then
    	echo -e "\033[41;37;5m\nMissing L file\n\033[0m"
    	return 1
    elif [[ "${wavfile[1]}" == "R" ]]; then
    	echo -e "\033[41;37;5m\nMissing R file\n\033[0m"
    	return 1
    else mix20
	#else echo $newfileName
    fi
}

#Main_body_mix
clear
echo -e  "\033[42;37;1m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\033[0m"
echo -e  "\033[42;37;1m@  Script written by Hanyuan  Apr-9-2019  @\033[0m"
echo -e  "\033[42;37;1m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\033[0m"


if [ "`ls "$1"`" = "" ]; then # if the source foder is not empty
    show_error
	exit 0
else
    #mkdir "$1""/""${newfolder}"
    echo -e "New file folder is \033[42;37;1m""${newpath}""\033[0m\n"
	scandir "$1"
    if [ "$?" = "0" ] ; then
    	echo -e "\033[42;37;1mAll audio tracks has mixed to 2.0 ac3 codec!\nHave a nice day!\033[0m\n"
	else
		echo -e "\033[41;37;5m\nMayday! Mayday! Mayday!\n\033[0m"
        exit 0
	fi
fi

echo -e "\n\033[42;37;1mFinished at <--`date`-->\033[0m\n"
exit 0

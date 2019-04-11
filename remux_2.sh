#!/bin/bash
#Copyright (C) 2016 Hanyuan Liu (lhy2871@126.com)
set -u #use utf-8
LANG="" #use default language coding
mainfolder="${1##*/}" #get the latest file folder which contans the main files
newfolder="remux_""$(date +%Y%b%d)""$(date +_%H%M%S)"

#GenereateLogName
cd "$1"
if [ "$1" = "/" ]
then
    #return ""
    log="/"${newfolder}"/"${newfolder}".log"
    realpath="/"
else
    #return $(pwd)
    log="$(pwd)""/""${newfolder}""/""${newfolder}"".log"
    realpath="$(pwd)"
fi
cd ..
#/GenereateLogName

function remux_2 {
    newfileName="${realpath}""/${newfolder}/"`basename "$1" ".pjt"`".wav"
    #echo -e ${newfileName}
    #cd "$1"
    if [ -s "${newfileName}" ];then
        return 0;
    else
        #echo "debug"
        echo -ne "Remuxing: \033[43;37m`basename "$1" ".pjt"`".wav"\033[0m\r"
        ffmpeg -i "1.wav" -i "2.wav" -filter_complex "join=inputs=2:channel_layout=stereo:map=0.0-FL|1.0-FR" -ac 2 -acodec pcm_s24le ${newfileName} 2>> ${log}
        echo -e "\n" >> ${log}
    fi
}

function show_error {
	echo -e "\033[41;37;5m\nSource folder is empty.\nREMUX FAILED\n\033[0m"
}

function scandir {
	local cur_dir in_dir
    in_dir="$1"
    cd "${in_dir}"
    if [ "${in_dir}" = "/" ]
    then
        cur_dir=""
    else
        cur_dir="$(pwd)"
    fi

    for dirlist in $(find . -type d ! -name "remux_*" ! -name ".*" ! -path "*/.*" -print)
    do
            cd "${dirlist}"
            remux_2 "${dirlist}"
            cd "$1"
    done
}

clear
echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo -e "@ Script written by Hanyuan  Feb-26-2017  @"
echo    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -e "Source folder is \033[42;37;1m"${mainfolder}"\033[0m"

#Main_body_remux
if [ "`ls "$1"`" = "" ]; then # if the source foder is not empty
    show_error
	exit 0
else
    mkdir "$1""/""${newfolder}"
    echo -e "New file folder is \033[42;37;1m"${newfolder}"\033[0m\n"
	scandir "$1"
    echo -e "\033[42;37;1mAll audio tracks has Remuxed!\nHave a nice day!\033[0m\n"
    #find . -type d ! -name "remux_*" ! -name ".*" ! -path "*/.*" -print
fi
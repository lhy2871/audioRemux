#!/bin/bash
#Copyright (C) 2019 Hanyuan Liu (lhy2871@126.com)
set -u #use utf-8
LANG="" #use default language coding
opath="$1" #get the latest file folder which contans the main files
newpath="$1"

newfileName="_""${1##*_}""_6ch"".ac3"
log="$1""/""_mix51Log""${newfileName}"".log"
wavfile=(L R C LFE Ls Rs);

#/GenereateLogName

function mix51 {
    if [ -s "${newfileName}" ];then
        echo -e "\033[41;37;5m\nAlready Have ac3 file\n\033[0m"
        return 1;
    else
        #echo "debug"
        #echo -ne "Mixing: \033[43;37m`basename "$1"`\033[0m\r"
        #ffmpeg -i "${wavfile[0]}" -i "${wavfile[1]}" -i "${wavfile[2]}" -i "${wavfile[3]}" -i "${wavfile[4]}" -i "${wavfile[5]}" -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a]amerge=inputs=6[aout]" -map "[aout]" -c:a ac3 "${newpath}"/"_""${newfileName}"
        #ffmpeg -v warning -stats -threads 4 -i "${wavfile[0]}" -i "${wavfile[1]}" -i "${wavfile[2]}" -i "${wavfile[3]}" -i "${wavfile[4]}" -i "${wavfile[5]}" -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a]amerge=inputs=6[aout]" -map "[aout]" -c:a ac3 "${newpath}"/"${newfileName}" 2>&1 | tee "${log}"
    	ffmpeg -hide_banner -i "${wavfile[0]}" -i "${wavfile[1]}" -i "${wavfile[2]}" -i "${wavfile[3]}" -i "${wavfile[4]}" -i "${wavfile[5]}" -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a]amerge=inputs=6[aout]" -map "[aout]" -c:a ac3 "${newpath}"/"${newfileName}" 2>&1 | tee "${log}"
        #echo -e "\n" >> "${log}"
    fi
}

function show_error {
	echo -e "\033[41;37;5m\nSource folder is empty.\nMIX51 FAILED\n\033[0m"
}

function scandir {
    cd "$1" 
    for fileName in $(find . -type f ! -name ".*" -print)
    do
    	local fileName1=$(echo ${fileName} | tr [a-z] [A-Z])
         #    if [ "${fileName1##*_}" == "L.WAV" ];then
         #    	wavfile[0]="${fileName}"
         #    elif [[ "${fileName1##*_}" == "R.WAV" ]]; then
         #    	wavfile[1]="${fileName}"
         #    elif [[ "${fileName1##*_}" == "C.WAV" ]]; then
         #    	wavfile[2]="${fileName}"
         #    elif [[ "${fileName1##*_}" == "LFE.WAV" ]]; then
         #    	wavfile[3]="${fileName}"
        	# elif [[ "${fileName1##*_}" == "LS.WAV" ]]; then
        	# 	wavfile[4]="${fileName}"
        	# elif [[ "${fileName1##*_}" == "RS.WAV" ]]; then
        	# 	wavfile[5]="${fileName}"
        if [ "${fileName1:0-5}" == "L.WAV" ];then
            wavfile[0]="${fileName}"
            elif [[ "${fileName1:0-5}" == "R.WAV" ]]; then
                wavfile[1]="${fileName}"
            elif [[ "${fileName1:0-5}" == "C.WAV" ]]; then
                wavfile[2]="${fileName}"
            elif [[ "${fileName1:0-7}" == "LFE.WAV" ]]; then
                wavfile[3]="${fileName}"
            elif [[ "${fileName1:0-6}" == "LS.WAV" ]]; then
                wavfile[4]="${fileName}"
            elif [[ "${fileName1:0-6}" == "RS.WAV" ]]; then
                wavfile[5]="${fileName}"
        	fi
    done
    cd "$1"
    if [ "${wavfile[0]}" == "L" ]; then
    	echo -e "\033[41;37;5m\nMissing L file\n\033[0m"
    	return 1
    elif [[ "${wavfile[1]}" == "R" ]]; then
    	echo -e "\033[41;37;5m\nMissing R file\n\033[0m"
    	return 1
    elif [[ "${wavfile[2]}" == "C" ]]; then
    	echo -e "\033[41;37;5m\nMissing C file\n\033[0m"
    	return 1
    elif [[ "${wavfile[3]}" == "LFE" ]]; then
    	echo -e "\033[41;37;5m\nMissing LFE file\n\033[0m"
    	return 1
    elif [[ "${wavfile[4]}" == "Ls" ]]; then
    	echo -e "\033[41;37;5m\nMissing Ls file\n\033[0m"
    	return 1
    elif [[ "${wavfile[5]}" == "Rs" ]]; then
    	echo -e "\033[41;37;5m\nMissing Rs file\n\033[0m"
    	return 1
    else mix51
	#else echo $newfileName
    fi
}

#Main_body_mix
clear
echo -e  "\033[42;37;1m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\033[0m"
echo -e  "\033[42;37;1m@  Script written by Hanyuan  Apr-9-2019  @\033[0m"
echo -e  "\033[42;37;1m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\033[0m"

#echo -e "\n\033[42;37;1mProgressing...\033[0m\n"

if [ "`ls "$1"`" = "" ]; then # if the source foder is not empty
    show_error
	exit 0
else
    #mkdir "$1""/""${newfolder}"
    echo -e "New file folder is \033[42;37;1m"${newpath}"\033[0m\n"
	scandir "$1"
    if [ "$?" = "0" ] ; then
    	echo -e "\033[42;37;1mAll audio tracks has mixed to 5.1 ac3 codec!\nHave a nice day!\033[0m\n"
	else
		echo -e "\033[41;37;5m\nMayday! Mayday! Mayday!\n\033[0m"
        exit 0
	fi
fi

echo -e "\n\033[42;37;1mFinished at <--`date`-->\033[0m\n"

exit 0

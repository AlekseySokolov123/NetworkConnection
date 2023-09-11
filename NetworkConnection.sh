#!/bin/bash

GLOBAL_DATETIME="$(date +%y%m%d-%H%M%S)"
GLOBAL_SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
GLOBAL_SCRIPT_NAME="$(basename "$(readlink -f "$0")")"
GLOBAL_SHOST="$(hostname -s | tr -d '\040\011\012\015')"
GLOBAL_LOG_NAME="ping_result_${GLOBAL_SHOST}_${GLOBAL_DATETIME}.log"
GLOBAL_LOG_FILE="${GLOBAL_SCRIPT_DIR}/${GLOBAL_LOG_NAME}"
GLOBAL_INFO_NAME="system_info_${GLOBAL_SHOST}_${GLOBAL_DATETIME}.txt"
GLOBAL_INFO_FILE="${GLOBAL_SCRIPT_DIR}/${GLOBAL_INFO_NAME}"

commands=(
"ip route"
"ip link"
"ip address"
"ip neigh"
"uname -a"
"df -hT"
)



pings=(
"ping x.x.x.x -c 4" #ping IP address
"ping -I ens192 x.x.x.x -c 4" #ping IP address from interface
)




for command in "${commands[@]}"; do
        echo -e "\n\n\n---------------------------" &>> "${GLOBAL_INFO_FILE}"
        echo "${command}" &>> "${GLOBAL_INFO_FILE}"
        echo "---------------------------" &>> "${GLOBAL_INFO_FILE}" 
        ( bash -c "${command}") &>> "${GLOBAL_INFO_FILE}"
done 



for ping in "${pings[@]}"; do
	( bash -c "${ping}" &> /dev/null ) 
        t=$?
	if [ "$t" -gt 0 ]
	  then
            echo "${ping} - failed"
            echo "${ping} - failed" &>> "${GLOBAL_LOG_FILE}"
          else 
            echo "${ping} - success" 
            echo "${ping} - success" &>> "${GLOBAL_LOG_FILE}"
        fi
done


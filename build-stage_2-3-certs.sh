#!/bin/bash
ZBUILD=${ZBUILD:-/zbuild}
ZBefore=`date +%s`

zbuild_wait() {
    echo "Press [SPACE] to skip 5s wait, or wait to continue..."
    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi
}
zbuild_check() {
    local file="$1"
    if [[ -f ${ZBUILD}/${file} ]]; then
        return 0
    else
        echo "Error: Missing $file ... Exiting"
        exit 1
    fi
}
zbuild_exec() {
    local file="$1"
    echo "Executing $file"
    ${ZBUILD}/zbuild "${ZBUILD}/$file" || { echo "Error: $file - Exiting: $?"; exit 1; }
}
stage3=(301-lfs-bootscripts-20240825.zbc 302-libtasn1-4.20.0.zbc 303-p11-kit-0.25.5.zbc 304-make-ca-1.16.1.zbc
 305-libunistring-1.3.zbc 306-libidn2-2.3.8.zbc 307-which-2.23.zbc 308-whois-5.4.3.zbc 309-wget-1.25.0.zbc
 317-openssh-10.0p1.zbc 318-gpm-1.20.7.zbc 319-bootscript-sshd-gpm.zbc)

for zbcfile in ${stage3[@]}; do
    zbuild_check "stage_2-3_finalize/$zbcfile"
    zbuild_wait
    zbuild_exec "stage_2-3_finalize/$zbcfile"
done

ZAfter=`date +%s`
let Duration=ZAfter-ZBefore
printf "Started: ${ZBefore} \n"
printf "Finished: ${ZAfter} \n"
printf "Duration: ${Duration} seconds \n\n"

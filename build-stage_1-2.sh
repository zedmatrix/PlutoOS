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
stage1=(201-gettext-0.25.zbc 202-bison-3.8.2.zbc 203-perl-5.40.2.zbc 204-Python-3.13.5.zbc
 205-texinfo-7.2.zbc 206-util-linux-2.41.zbc 207-nano-8.5.zbc 208-less-678.zbc)

for zbcfile in ${stage1[@]}; do
    zbuild_check "stage_2-1_extra-tools/$zbcfile"
    zbuild_wait
    zbuild_exec "stage_2-1_extra-tools/$zbcfile"
done

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete

## Clean Up Harmful tmp and log directories
rm -rf /tools
rm -rf /zbuild/log/*
rm -rf /zbuild/tmp/*

printf "At This Point you can Exit and Save the Stage 1 LFS Temporary Tools\n"
printf "Will Still haveto exit to download the second batch of source files\n\n"

printf "Instructions: exit && cd $LFS \n\n"

printf " $ZBUILD/stage_2-2_base-system/200-get-packages \n"

printf " tar --exclude='sources' -cJpf $ZSRC/lfs-temp-tools-r12.3-sysv.tar.xz . \n"

ZAfter=`date +%s`
let Duration=ZAfter-ZBefore
printf "Started: ${ZBefore} \n"
printf "Finished: ${ZAfter} \n"
printf "Duration: ${Duration} seconds \n\n"

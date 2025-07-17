#!/bin/bash
LFS=${LFS:-/mnt/lfs}
ZBUILD=${ZBUILD:-/$LFS/zbuild}
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
stage1=(101-binutils-2.44.zbc 102-gcc-14.3.0.zbc 103-linux-6.6.97.zbc 104-glibc-2.41.zbc
 105-Libstdcpp.zbc 106-m4-1.4.20.zbc 107-ncurses-6.5.zbc 108-bash-5.2.37.zbc 109-coreutils-9.7.zbc
 110-diffutils-3.12.zbc 111-file-5.46.zbc 112-findutils-4.10.0.zbc 113-gawk-5.3.2.zbc
 114-grep-3.12.zbc 115-gzip-1.14.zbc 116-make-4.4.1.zbc 117-patch-2.8.zbc 118-sed-4.9.zbc
 119-tar-1.35.zbc 120-xz-5.8.1.zbc 121-binutils-2.44.zbc 122-gcc-14.3.0.zbc)

for zbcfile in ${stage1[@]}; do
    zbuild_check "stage_1_temptools/$zbcfile"
    zbuild_wait
    zbuild_exec "stage_1_temptools/$zbcfile"
done

echo " Glibc Test Suite Exec: stage_1_temptools/104.1.glibc-tests.sh "
echo " Now Exec: ${ZBUILD}/Zlfs-chroot.sh "

ZAfter=`date +%s`
let Duration=ZAfter-ZBefore
printf "Started: ${ZBefore} \n"
printf "Finished: ${ZAfter} \n"
printf "Duration: ${Duration} seconds \n\n"

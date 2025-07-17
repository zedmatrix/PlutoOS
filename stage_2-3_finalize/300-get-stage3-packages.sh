#!/bin/bash
print() { printf "%s\n" "$*"; }
# Get the Limited Packages for stage3

print "Getting Stage 3 Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
ZSRC=${ZSRC:-$LFS/sources}
ZBUILD=${ZBUILD:-$LFS/zbuild}
ZBefore=`date +%s`

download() {
    # Usage: $1 = file , $2 = url , $3 = md5
    local file=$1
    local url=$2
    local md5=$3
    print "Checking for $file ..."
    wget -nc -P $ZSRC "${url}"

    local newmd5=$(md5sum "$ZSRC/$file" | awk '{print $1}')
    echo "$newmd5 $file" >> stage2-3_md5sums
    [[ $newmd5 == $md5 ]] && print "Ok" || print "Fail $newmd5"
}

while IFS=' ' read -r md5 url; do
    # Skip empty lines and comments
    [[ -z "$md5" || "$md5" == \#* ]] && continue

    archive=$(basename "$url")
    echo "Archive: $archive URL: $url"
    if [[ ! -f "${ZSRC}/$file" ]]; then
        download "$archive" "$url" "$md5"
    else
        print "Skipping ${archive}"
    fi
done < $ZBUILD/stage_2-3_finalize/300-finalize-wget-list

ZAfter=`date +%s`
let Duration=ZAfter-ZBefore
print "Started: ${ZBefore} "
print "Finished: ${ZAfter} "
print "Duration: ${Duration} seconds \n"

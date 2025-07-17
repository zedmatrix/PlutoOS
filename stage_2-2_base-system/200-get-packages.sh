#!/bin/bash
# Get the Limited Packages for stage3

print() { printf "%s\n" "$*"; }

print "Getting Limited Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
ZSRC=${ZSRC:-$LFS/sources}

download() {
    # Usage: $1 = file , $2 = url
    local file=$1
    local url=$2

    wget -nc -P $ZSRC "${url}"
    local newmd5=$(md5sum "$ZSRC/$file" | awk '{print $1}')
    echo "$newmd5 $file" >> md5sums
    #[[ $newmd5 == $md5 ]] && print "Ok" || print "Fail $newmd5"
}

while IFS=' ' read -r url; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" == \#* ]] && continue

    archive=$(basename "$url")
    echo "Archive: $archive URL: $url"
    if [[ ! -f $ZSRC/$archive ]]; then
        print "Downloading $file "
        download "$archive" "$url"
    else
        print "Skipping $archive"
    fi
done < 000-wget-list-sysv

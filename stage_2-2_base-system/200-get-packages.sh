#!/bin/bash
# Get the Limited Packages for stage3

print() { printf "%s\n" "$*"; }

print "Getting Limited Packages"
set +h
umask 022
# LFS=${LFS:-/mnt/lfs}
# ZSRC=${ZSRC:-$LFS/sources}
DEST=/mnt/usb/sources
ZSRC=/srv/www/sources
ZPAT=/srv/www/patches

download() {
    # Usage: $1 = file , $2 = url
    local file=$1
    local url=$2
    wget -nc -P $DEST "${url}"
}

while IFS=' ' read -r url; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" == \#* ]] && continue

    archive=$(basename "$url")
    fileext=${filename##*.}
    if [[ -f $DEST/$archive ]]; then
        print "$archive found skipping!"
        continue
    fi

    echo "Archive: $archive URL: $url"
    if [[ ${fileext} == "patch" && -f $ZPAT/$archive ]]; then
        print "Copying $archive to $DEST"
        cp -n $ZPAT/$archive $DEST
        continue
    fi

    if [[ ! -f $ZSRC/$archive ]]; then
        print "Downloading $file "
        download "$archive" "$url"
    else
        print "Copying $archive to $DEST"
        cp -n $ZSRC/$archive $DEST
    fi

done < 200-wget-list-musl

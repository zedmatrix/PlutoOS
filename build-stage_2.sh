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
stage2=(201-man-pages-6.14.zbc 202-iana-etc-20250519.zbc 203-glibc-2.41.zbc 204-zlib-1.3.1.zbc 205-bzip2-1.0.8.zbc
 206-xz-5.8.1.zbc 207-lz4-1.10.0.zbc 208-zstd-1.5.7.zbc 209-file-5.46.zbc 210-readline-8.3-rc2.zbc 211-m4-1.4.20.zbc
 212-bc-7.0.3.zbc 213-flex-2.6.4.zbc 214-tcl-8.6.16.zbc 215-expect-5.45.4.zbc 216-dejagnu-1.6.3.zbc
 217-pkgconf-2.4.3.zbc 218-binutils-2.44.zbc 219-gmp-6.3.0.zbc 220-mpfr-4.2.2.zbc 221-mpc-1.3.1.zbc
 222-attr-2.5.2.zbc 223-acl-2.3.2.zbc 224-libcap-2.76.zbc 225-libxcrypt-4.4.38.zbc 226-shadow-4.17.4.zbc
 227-gcc-14.3.0.zbc 228-ncurses-6.5.zbc 229-sed-4.9.zbc 230-psmisc-23.7.zbc 231-gettext-0.25.zbc 232-bison-3.8.2.zbc
 233-grep-3.12.zbc 234-bash-5.2.37.zbc 235-libtool-2.5.4.zbc 236-gdbm-1.25.zbc 237-gperf-3.3.zbc 238-expat-2.7.1.zbc
 239-inetutils-2.6.zbc 240-less-678.zbc 241-perl-5.40.2.zbc 242-xml-parser-2.47.zbc 243-intltool-0.51.0.zbc
 244-autoconf-2.72.zbc 245-automake-1.18.zbc 246-openssl-3.5.0.zbc 247-libelf_elfutils-0.193.zbc 248-libffi-3.5.1.zbc
 249-Python-3.13.5.zbc 250-flit_core-3.12.0.zbc 251-packaging-25.0.zbc 252-wheel-0.46.1.zbc 253-setuptools-80.9.0.zbc
 254-ninja-1.12.1.zbc 255-meson-1.8.2.zbc 256-kmod-34.2.zbc 257-coreutils-9.7.zbc 258-diffutils-3.12.zbc
 259-gawk-5.3.2.zbc 260-findutils-4.10.0.zbc 261-groff-1.23.0.zbc 262-grub-2.12.zbc 263-gzip-1.14.zbc
 264-iproute2-6.15.0.zbc 265-kbd-2.8.0.zbc 266-libpipeline-1.5.8.zbc 267-make-4.4.1.zbc 268-patch-2.8.zbc
 269-tar-1.35.zbc 270-texinfo-7.2.zbc 271-nano-8.5.zbc 272-markupsafe-3.0.2.zbc 273-jinja2-3.1.6.zbc
 274-Udev-from-systemd-257.6.zbc 275*.zbc 276-man-db-2.13.1.zbc 277-procps-ng-4.0.5.zbc 278-utili-linux-2.41.zbc
 279-e2fsprogs-1.47.2.zbc 280-sysklogd-2.7.0.zbc 281-sysvinit-3.14.zbc)

for zbcfile in ${stage2[@]}; do
    zbuild_check "stage_2-2_base-system/$zbcfile"
    zbuild_wait
    zbuild_exec "stage_2-2_base-system/$zbcfile"
done

## Clean Up Harmful tmp and log directories
rm -rf /tmp/{*,.*}
#rm -rf /zbuild/log/*
rm -rf /zbuild/tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester

printf "\t Don't Forget to Set Your ROOT Password: passwd root \n\n"

ZAfter=`date +%s`
let Duration=ZAfter-ZBefore
printf "Started: ${ZBefore} \n"
printf "Finished: ${ZAfter} \n"
printf "Duration: ${Duration} seconds \n\n"

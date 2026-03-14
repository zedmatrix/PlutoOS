#!/bin/bash
mkdir -v gcc-14.3.0-test
pushd gcc-14.3.0-test

echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
#		[Requesting program interpreter: /lib/ld-musl-aarch64.so.1]

grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
# /usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/../../../../lib/Scrt1.o succeeded
# /usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/../../../../lib/crti.o succeeded
# /usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/../../../../lib/crtn.o succeeded

grep -B4 '^ /usr/include' dummy.log
# ignoring nonexistent directory "/usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/../../../../aarch64-unknown-linux-musl/include"
# #include "..." search starts here:
# #include <...> search starts here:
#  /usr/local/include
#  /usr/include

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# SEARCH_DIR("/usr/aarch64-unknown-linux-musl/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/aarch64-unknown-linux-musl/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");

grep "/lib.*/libc.so " dummy.log
# attempt to open /usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/libc.so failed
# attempt to open /usr/lib/gcc/aarch64-unknown-linux-musl/14.3.0/../../../../lib/libc.so succeeded

/usr/lib/libc.so --version
# musl libc (aarch64)
# Version 1.2.5
# Dynamic Program Loader
# Usage: /usr/lib/libc.so [options] [--] pathname [args]

# grep found dummy.log

popd

rm -rf gcc-14.3.0-test && echo "Removed testdir"

echo " Finished "

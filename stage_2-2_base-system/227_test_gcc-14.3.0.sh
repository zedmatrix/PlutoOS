#!/bin/bash
mkdir -v gcc-14.3.0-test
pushd gcc-14.3.0-test

echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

popd

rm -rf gcc-14.3.0-test && echo "Removed testdir"

echo " Finished "

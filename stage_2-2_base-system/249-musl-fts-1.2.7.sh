description=("Implements the fts(3) functions fts_open, fts_read, fts_children, fts_set and fts_close, which are missing in musl libc.")

package=(
  name: musl-fts
  version: 1.2.7
  rel: 1
  archive: false
  delete: true)

sources=(
  - url: https://trak4.com/musl-from-scratch/musl-packages/musl-fts-v1.2.7.tar.gz
    md5: bce0b5de0cf2519a74fbfacead60369d
    sha256: 49ae567a96dbab22823d045ffebe0d6b14b9b799925e9ca9274d47d26ff482a6)

extract=(' xtar /sources/musl-fts-v1.2.7.tar.gz ')

prepare() {
  ./bootstrap.sh;
  ./configure --prefix=/usr;
}
# real    1m3.129s
# user    0m40.287s
# sys     0m25.260s

build() {
  make
}
# real    0m11.564s
# user    0m9.310s
# sys     0m2.240s

install() {
  make install
}
# real    0m1.576s
# user    0m0.720s
# sys     0m1.151s

required=('musl')

clean=(' cd ../ && rm -rf musl-fts-1.2.7 ')

#  /usr/bin/mkdir -p '/usr/include'
#  /usr/bin/mkdir -p '/usr/lib/pkgconfig'
#  /usr/bin/install -c -m 644 fts.h '/usr/include'
#  /usr/bin/mkdir -p '/usr/lib'
#  /usr/bin/install -c -m 644 musl-fts.pc '/usr/lib/pkgconfig'
#  /bin/sh ./libtool   --mode=install /usr/bin/install -c   libfts.la '/usr/lib'
# libtool: install: /usr/bin/install -c .libs/libfts.so.0.0.0 /usr/lib/libfts.so.0.0.0
# libtool: install: (cd /usr/lib && { ln -s -f libfts.so.0.0.0 libfts.so.0 || { rm -f libfts.so.0 && ln -s libfts.so.0.0.0 libfts.so.0; }; })
# libtool: install: (cd /usr/lib && { ln -s -f libfts.so.0.0.0 libfts.so || { rm -f libfts.so && ln -s libfts.so.0.0.0 libfts.so; }; })
# libtool: install: /usr/bin/install -c .libs/libfts.lai /usr/lib/libfts.la
# libtool: install: /usr/bin/install -c .libs/libfts.a /usr/lib/libfts.a

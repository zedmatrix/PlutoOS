required=('musl', 'libedit', 'zlib', 'tcl', 'ncurses')
package=(
  name: sqlite
  version: 3.51.2
  rel: 1
  archive: false
  delete: true)

sources=(
  - url: https://sqlite.org/2025/sqlite-autoconf-3510200.tar.gz
    md5: 49600a5739d382c648b1a317e4b57446
  - url: https://anduin.linuxfromscratch.org/LFS/sqlite-doc-3510200.tar.xz
    md5: 6f798c5dcd409ee563684c70be7e16fe)

extract=(' xtar /sources/sqlite-autoconf-3510200.tar.gz ')

prepare() {
  ./configure --prefix=/usr --disable-static --enable-fts{4,5} \
    CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 -D SQLITE_ENABLE_UNLOCK_NOTIFY=1 \
              -D SQLITE_ENABLE_DBSTAT_VTAB=1 -D SQLITE_SECURE_DELETE=1"
}
# real    0m21.640s
# user    0m13.557s
# sys     0m7.663s

build() {
  make LDFLAGS.rpath=""
}
# real    14m45.226s
# user    25m26.019s
# sys     0m34.672s

install() {
  make install
}
# real    0m0.298s
# user    0m0.172s
# sys     0m0.320s

final() {
  tar -xf /sources/sqlite-doc-3510200.tar.xz
  install -v -m755 -d /usr/share/doc/sqlite-3.51.2
  cp -v -R sqlite-doc-3510200/* /usr/share/doc/sqlite-3.51.2
}

clean=(' cd ../ && rm -rf sqlite-autoconf-3510200 ')

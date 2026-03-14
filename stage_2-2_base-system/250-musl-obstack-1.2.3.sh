description=("A copy + paste of the obstack functions and macros found in GNU gcc libiberty library for use with musl libc.")
required=('musl')

package=(
  name: musl-obstack
  version: 1.2.3
  rel: 1
  archive: false
  delete: true)

sources=(
  - url: https://trak4.com/musl-from-scratch/musl-packages/musl-obstack-v1.2.3.tar.gz
    md5: e4f1d16aa3187e8d071f656dd2b10a9e
    sha256: 9ffb3479b15df0170eba4480e51723c3961dbe0b461ec289744622db03a69395)

extract=(' xtar /sources/musl-obstack-v1.2.3.tar.gz ')

prepare() {
  ./bootstrap.sh; ./configure --prefix=/usr;
}
# real    0m57.477s
# user    0m37.448s
# sys     0m22.406s

build() {
  make
}
# real    0m4.597s
# user    0m3.882s
# sys     0m2.671s

install() {
  make install
}
# real    0m1.499s
# user    0m0.722s
# sys     0m1.077s

clean=(' cd ../ && rm -rf musl-obstack-1.2.3 ')

#  /usr/bin/mkdir -p '/usr/include'
#  /usr/bin/mkdir -p '/usr/lib/pkgconfig'
#  /usr/bin/mkdir -p '/usr/lib'
#  /bin/sh ./libtool   --mode=install /usr/bin/install -c   libobstack.la '/usr/lib'
#  /usr/bin/install -c -m 644 obstack.h '/usr/include'
#  /usr/bin/install -c -m 644 musl-obstack.pc '/usr/lib/pkgconfig'
# libtool: install: /usr/bin/install -c .libs/libobstack.so.1.0.0 /usr/lib/libobstack.so.1.0.0
# libtool: install: (cd /usr/lib && { ln -s -f libobstack.so.1.0.0 libobstack.so.1 || { rm -f libobstack.so.1 && ln -s libobstack.so.1.0.0 libobstack.so.1; }; })
# libtool: install: (cd /usr/lib && { ln -s -f libobstack.so.1.0.0 libobstack.so || { rm -f libobstack.so && ln -s libobstack.so.1.0.0 libobstack.so; }; })
# libtool: install: /usr/bin/install -c .libs/libobstack.lai /usr/lib/libobstack.la
# libtool: install: /usr/bin/install -c .libs/libobstack.a /usr/lib/libobstack.a

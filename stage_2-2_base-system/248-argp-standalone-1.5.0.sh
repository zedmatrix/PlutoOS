package=(
  name: argp-standalone
  version: 1.5.0
  rel: 1
  archive: false
  delete: true
)

sources=(
  - url: https://trak4.com/musl-from-scratch/musl-packages/argp-standalone-1.5.0.tar.xz
    md5: ea34a1306850b574cac3dff2ae3d470b
    sha256: 4ab09d3baa63b8bef0319767c8c62e4b2af384531866c0afa543fe68776828ec
)
extract=(' xtar /sources/argp-standalone-1.5.0.tar.xz ')

prepare() {
  autoreconf -vif
# real    0m20.109s
# user    0m16.692s
# sys     0m2.364s
  CFLAGS="-fPIC" ./configure --prefix=/usr
}
# real    0m30.150s
# user    0m15.498s
# sys     0m15.091s

build() {
  make
}
# real    0m3.897s
# user    0m6.513s
# sys     0m2.474s

check() {
  make check
}

install() {
  cp -v argp.h /usr/include/argp.h
  cp -v libargp.a /usr/lib/libargp.a
}
# real    0m0.705s
# user    0m0.298s
# sys     0m0.538s


clean=(' cd ../ && rm -rf arg_parse-1.5.0 ')

description=("A continuation of Niels Möller's work on an argp library for systems which don't provide one themselves (most non-GNU ones).")

# PASS: ex1
# PASS: permute
# ==================
# All 2 tests passed
# ==================

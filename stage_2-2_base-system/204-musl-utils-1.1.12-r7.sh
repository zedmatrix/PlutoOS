
giturl=('https://github.com/aeltra/musl-utils')
pkgname=('musl-utils')
pkgver=('1.1.12-r7')
pkgurl=('http://10.0.0.100/sources/musl-utils-1.1.12.tar.xz')
pkgmd5=('f548c56dc566141268003b48bcbfd241')

extract=(' xtar /sources/musl-utils-1.1.12.tar.xz ')

prepare() {
	./configure --prefix=/usr
}
# real    0m10.892s
# user    0m5.010s
# sys     0m6.403s

build() {
	make
}
# real    0m3.260s
# user    0m4.694s
# sys     0m1.040s

install() {
	make install
}
# real    0m0.372s
# user    0m0.171s
# sys     0m0.285s

clean=(' cd ../ && rm -rf musl-utils-1.1.12-r7 ')

# Provides: /usr/bin/install -c getconf getent iconv '/usr/bin'

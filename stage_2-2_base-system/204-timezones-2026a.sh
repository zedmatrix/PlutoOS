#!/bin/sh
pkgname=('')
pkgver=('2026a')
pkgsrc=('timezone-musl-2026a.tar.xz')
pkgsha256=('899e02f96d0ba18423da7b9eb1dfd098b2f01e9f047943c3c9c9fd251b77a59d')
pkgmd5=('4a5e4f2f177ffb277a36bc75741d3a09')

extract=(' xtar /sources/timezone-musl-2026a.tar.xz ')

build() {
  make CC=gcc zic zdump tzselect
}
# real    0m10.687s
# user    0m17.861s
# sys     0m1.789s

install() {
  install -vm755 zic /usr/bin
  install -vm755 zdump /usr/bin
  install -vm755 tzselect /usr/bin
}

final() {
  mkdir -pv /usr/share/zoneinfo/{posix,right}
  for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d /usr/share/zoneinfo ${tz}
    zic -L /dev/null   -d /usr/share/zoneinfo/posix ${tz}
    zic -L leapseconds -d /usr/share/zoneinfo/right ${tz}
  done

  cp -v zone.tab zone1970.tab iso3166.tab /usr/share/zoneinfo
  zic -d /usr/share/zoneinfo -p America/New_York
  ln -sv /usr/share/zoneinfo/Canada/Pacific /etc/localtime
}

clean=(' cd ../ && rm -rf timezone-musl-2026a ')

#!/bin/sh

giturl=('https://git.adelielinux.org/adelie/musl-locales.git')
pkgname=('musl-locales')
pkgver=('0.1.0-6-g2936dfd')

pkgsrc=('http://10.0.0.100/sources/musl-locales-0.1.0.tar.xz')

extract=(' xtar /sources/musl-locales-0.1.0.tar.xz ')

prepare() {
  meson setup build --prefix=/usr
}

build() {
  ninja -C build
}

install() {
  ninja -C build install
}

clean=(' cd ../ && rm -rf musl-locales-0.1.0 ')

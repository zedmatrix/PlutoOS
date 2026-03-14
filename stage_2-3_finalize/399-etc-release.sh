#!/bin/bash

release="aarch64-musl"
name="Pluto_Musl"

echo ${release} > /etc/lfs-release
[ -f /etc/lfs-release ] && echo "* Created: /etc/lfs-release"

cat > /etc/lsb-release <<EOF
DISTRIB_ID="Zirconium AArch64 From Scratch"
DISTRIB_RELEASE="${release}"
DISTRIB_CODENAME="${name}"
DISTRIB_DESCRIPTION="Zirconium AArch64 From Scratch"
EOF
[ -f /etc/lsb-release ] && echo "* Created: /etc/lsb-release"

cat > /etc/os-release <<EOF
NAME="Zirconium AArch64 From Scratch"
VERSION="${release}"
ID=lfs
PRETTY_NAME="Zirconium AArch64 From Scratch ${release}"
VERSION_CODENAME="${name}"
HOME_URL="https://zedmatrix.github.io/PlutoOS/"
RELEASE_TYPE="development"
EOF
[ -f /etc/os-release ] && echo "* Created: /etc/os-release"

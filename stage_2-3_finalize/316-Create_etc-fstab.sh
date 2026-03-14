#!/bin/bash
RELEASE="systemd"
DRIVE="/dev/vdb"
ROOT=$(blkid -o value -s UUID ${DRIVE}3)
SWAP=$(blkid -o value -s UUID ${DRIVE}2)
ESP=$(blkid -o value -s UUID ${DRIVE}1)

if [[ $RELEASE == "sysv" ]]; then
    cat > /etc/fstab <<SYSV
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

UUID=${ROOT}      /              ext4     defaults            1     1
UUID=${SWAP}      swap           swap     pri=1               0     0
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
SYSV
   [ -f /etc/fstab ] && echo "*** Created: /etc/fstab "
elif [[ $RELEASE == "systemd" ]]; then
    cat > /etc/fstab <<SYSD
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

UUID=${ROOT}   /          ext4    defaults  1  1
UUID=${SWAP}   swap       swap    pri=1     0  0
UUID=${ESP}    /boot/efi  vfat    noauto,codepage=437,iocharset=iso8859-1  0  1
SYSD
   [ -f /etc/fstab ] && echo "*** Created: /etc/fstab "
else
   echo "Please Set RELEASE variable, /etc/fstab Not Created"
fi

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
[ -f /etc/modprobe.d/usb.conf ] && echo "*** Created: /etc/modprobe.d/usb.conf "

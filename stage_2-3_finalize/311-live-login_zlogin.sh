echo -e "\t\033[1;31;41m    \033[32;42m    \033[33;43m    \033[34;44m    \033[35;45m    \033[36;46m    \033[0m\n
\033[1;37m\t Welcome to the Linux From Scratch Live ISO \033[0m \n
\033[1;34m\t Packages Installed: curl, wget, links, nano, ssh, ping, dhcpcd \033[0m \n
\033[1;37m\t Mount Your Partition to get Started - version-check available\033[0m \n
\033[1;33m\t Type or Copy: links http://www.linuxfromscratch.org \033[0m \n
\033[1;31m\t Auto Scrambling root password for security. \033[0m \n
\t\033[1;31;41m    \033[32;42m    \033[33;43m    \033[34;44m    \033[35;45m    \033[36;46m    \033[0m\n
\033[1;35m\t To Start sshd: set a root password: passwd root \033[0m
\033[1;35m\t And Type /etc/init.d/sshd start \033[0m\n
\t\033[1;31;41m    \033[32;42m    \033[33;43m    \033[34;44m    \033[35;45m    \033[36;46m    \033[0m\n" > /etc/zlogin

[ -f /etc/zlogin ] && echo "Created: /etc/zlogin"

cat > /etc/rc.d/init.d/live-login << "EOF"
#!/bin/bash
# Begin /etc/rc.d/init.d/live-login
### BEGIN INIT INFO
# Provides: live login
# Required-Start: $local_fs
# Default-Start: 3
# Default-Stop:
# Short-Description: Login and Root Password Scramble

[ -f "/etc/zlogin" ] && cat /etc/zlogin
PASS=$(openssl rand -base64 16)
HASH=$(mkpasswd -m sha-512 "$PASS")
usermod -p "$HASH" root
echo "Temporary Password: $PASS" > /tmp/root-pass.txt
chmod 600 /tmp/root-pass.txt

# End /etc/rc.d/init.d/live-login
EOF
chmod -v 755 /etc/rc.d/init.d/live-login
ln -sfv ../init.d/live-login /etc/rc.d/rc3.d/S99live-login

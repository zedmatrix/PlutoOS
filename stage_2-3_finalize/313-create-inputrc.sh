#!/bin/bash
printf "\n\t Creating /etc/inputrc \n"
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

printf "\n\t Creating /etc/shells \n"
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

#!/bin/bash
printf "\n\t == Creating /etc/motd == \n"
cat > /etc/motd << "EOF"
#!/bin/bash
# Begin /etc/motd

zprint "Welcome to the Linux From Scratch SystemV LiveCD!"
zprint "Live CD Reborn - Type 'help' to get started"
zprint " or prepare your drive and mount your build partition."

# End /etc/motd
EOF

echo " Done "

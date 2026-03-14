#!/bin/bash
printf "\n\t Creating /etc/profile \n "

cat > /etc/profile << "EOF"
# Begin /etc/profile

# Unset any previously set locale vars
for var in LANG LANGUAGE LC_{ALL,COLLATE,CTYPE,MESSAGES,MONETARY,NUMERIC,TIME}; do
  unset $var
done

# Set a safe default LANG
# C.UTF-8 is ideal for LiveCDs: minimal, POSIX-compatible, UTF-8 support
if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  # Allow for extension/modification by users
  export LANG=${LANG:-en_US.UTF-8}
fi

if [ -d /etc/profile.d ]; then
    for script in /etc/profile.d/*.sh; do
        if [[ -r "$script" ]]; then
            chmod +x "$script" 2>/dev/null
            . "$script"
        fi
    done
fi
unset script

zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zzblue="${zzblue:-\033[1;34m}"
zzpurple="${zzpurple:-\033[1;35m}"
zzcyan="${zzcyan:-\033[1;36m}"
zzreset="${zzreset:-\033[0m}"
zprint() { printf "${zzgreen} *** %s *** ${zzreset}\n" "$*"; }

export zzred zzgreen zzyellow zzblue zzpurple zzcyan zzreset
export -f zprint

[ -f /etc/motd ] && bash /etc/motd

# End /etc/profile
EOF
[ -f /etc/profile ] && echo "Created /etc/profile"

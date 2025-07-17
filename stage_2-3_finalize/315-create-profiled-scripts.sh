#!/bin/bash
printf "\n\t Creating /etc/profile.d scripts \n"
install -v --directory --mode=0755 --owner=root --group=root /etc/profile.d
install -v --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d

cat > /etc/profile.d/00path-functions.sh << "EOF"
# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend
EOF
[ -f /etc/profile.d/00path-functions.sh ] && printf "\t Created path-functions.sh \n"

cat > /etc/profile.d/bash_completion.sh << "EOF"
# Begin /etc/profile.d/bash_completion.sh
# Import bash completion scripts

# If the bash-completion package is installed, use its configuration instead
if [ -f /usr/share/bash-completion/bash_completion ]; then

  # Check for interactive bash and that we haven't already been sourced.
  if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -z "${BASH_COMPLETION_VERSINFO-}" ]; then

    # Check for recent enough version of bash.
    if [ ${BASH_VERSINFO[0]} -gt 4 ] || \
       [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then
       [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] && \
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
       if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
          # Source completion code.
          . /usr/share/bash-completion/bash_completion
       fi
    fi
  fi

else

  # bash-completions are not installed, use only bash completion directory
  if shopt -q progcomp; then
    for script in /etc/bash_completion.d/* ; do
      if [ -r $script ] ; then
        . $script
      fi
    done
  fi
fi

# End /etc/profile.d/bash_completion.sh
EOF
[ -f /etc/profile.d/bash_completion.sh ] && printf "\t Created bash_completion.sh \n"

cat > /etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi
EOF
[ -f /etc/profile.d/dircolors.sh ] && printf "\t Created dircolors.sh \n"

cat > /etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

if [ -d /usr/local/share ]; then
        pathprepend /usr/local/share XDG_DATA_DIRS
fi

# Set some defaults before other applications add to these paths.
pathappend /usr/share/info INFOPATH
EOF
[ -f /etc/profile.d/extrapaths.sh ] && printf "\t Created extrapaths.sh \n"

cat > /etc/profile.d/readline.sh << "EOF"
# Set up the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF
[ -f /etc/profile.d/readline.sh ] && printf "\t Created readline.sh \n"

cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF
[ -f /etc/profile.d/umask.sh ] && printf "\t Created umask.sh \n"

cat > /etc/profile.d/i18n.sh << "EOF"
# Set up i18n variables
for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  # Allow for extension/modification by users
  export LANG=${LANG:-en_US.UTF-8}
fi
EOF
[ -f /etc/profile.d/i18n.sh ] && printf "\t Created i18n.sh \n"

cat > /etc/profile.d/CurlPaste.sh << "EOF"
#!/bin/bash
[ -x /usr/bin/curl ] || return
CurlPaste() {
    local file=$1
    if [[ -z $file ]]; then
        printf "Error: Usage: $0 [file] \n"
        return 1
    fi

    if [[ -f $file ]]; then
        printf "\n\t Uploading ${file} to 0x0 \n"
        curl -F'file=@-' https://0x0.st < "${file}"
    else
        printf "\n\t Warning: File does not exist. \n"
        return 1
    fi
}
export -f CurlPaste
EOF
[ -f /etc/profile.d/CurlPaste.sh ] && printf "\t Created CurlPaste.sh \n"

printf "\n\t === Finished === \n\n"

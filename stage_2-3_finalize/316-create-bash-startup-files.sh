#!/bin/bash
printf "\n\t === Creating Bash Startup Files === \n"
install -v -d --mode=0755 --owner=root --group=root /etc/skel

cat > /etc/bashrc << "EOF"
#!/bin/bash
# Begin /etc/bashrc
# Written for Linux From Scratch
# System wide aliases and functions.

alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias grep='grep --color=auto'

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

unset RED GREEN NORMAL

# GnuPG wants this or it'll fail with pinentry-curses under some
# circumstances (for example signing a Git commit)
tty -s && export GPG_TTY=$(tty)

# End /etc/bashrc
EOF

printf "\n\t Creating ~/.bash_profile \n"
cat > ~/.bash_profile << "EOF"
# Begin ~/.bash_profile
# Written for Linux From Scratch
# Personal environment variables and startup programs.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

# End ~/.bash_profile
EOF
cp -v ~/.bash_profile /etc/skel

printf "\n\t Creating ~/.profile \n"
cat > ~/.profile << "EOF"
# Begin ~/.profile
# Personal environment variables and startup programs.

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Set up user specific i18n variables
export LANG=${LANG:-en_US.UTF-8}

# End ~/.profile
EOF
cp -v ~/.profile /etc/skel

printf "\n\t Creating ~/.bashrc \n"
cat > ~/.bashrc << "EOF"
# Begin ~/.bashrc
# Written for Linux From Scratch

# Personal aliases and functions.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

# Set up user specific i18n variables
export LANG=${LANG:-en_US.UTF-8}

# End ~/.bashrc
EOF
cp -v ~/.bashrc /etc/skel

printf "\n\t Setting Up dircolors \n"
dircolors -p > /etc/dircolors
cp -v /etc/dircolors /etc/skel/.dircolors

printf "\n\t === Finished === \n\n"

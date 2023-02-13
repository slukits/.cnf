#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

# PS1='[\u@\h \W]\$ '

PATH="/home/goedel/.local/bin:/home/goedel/go/bin:/usr/local/go/bin"$PATH
export EDITOR=vim
export GTK_THEME=Arc-Gruvbox
export SYSTEMD_EDITOR=vim

set -o vi
bind '"jk":vi-movement-mode'

alias ls='ls --color=auto'
alias rm=trash
alias rrm='/usr/bin/rm'
alias less='less --chop-long-lines'
alias cnf='/usr/bin/git --git-dir=$HOME/.cnf/ --work-tree=$HOME'
cnf config --local status.showUntrackedFiles no

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash

[ -f /usr/share/git/completion/git-completion.bash ] && source /usr/share/git/completion/git-completion.bash


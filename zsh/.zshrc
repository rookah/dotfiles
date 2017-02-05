source ~/.git-prompt.sh #git prompt

[[ $- != *i* ]] && return

#loading
autoload -U colors && colors
autoload -Uz compinit promptinit
compinit
promptinit; prompt gentoo

#completion
source /usr/share/racket/pkgs/shell-completion/racket-completion.zsh #racket completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


#less
zmodload zsh/zpty

pty() {
	zpty pty-${UID} ${1+$@}
	if [[ ! -t 1 ]];then
		setopt local_traps
		trap '' INT
	fi
	zpty -r pty-${UID}
	zpty -d pty-${UID}
}

cless() {
	pty $@ | less
}

#dircolors directory (default /etc/DIR_COLORS)
eval "$(dircolors ~/.dircolors)";

ttyctl -f

#PATH
export PATH="$PATH:/home/roukah/.local/bin/"

#ENV
export KEYTIMEOUT=1
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history

export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

#Aliases
alias ls='ls++'
alias grep="grep --color=auto"
alias shutdown='sudo shutdown -P 0'
alias reboot='sudo reboot'
alias ..='cd ..'
alias vimtex='vim --servername VIM'
alias scrot="scrot '%Y_%s_\$wx\$h.png' -e 'mv \$f ~/Pictures/Screenshots/'"

#custom functions

function mkcdir() {
    /bin/mkdir -p $@ && cd "$_"
}



#ncmpcpp script
ncmpcppShow() { ncmpcpp <$TTY; zle redisplay; }
zle -N ncmpcppShow
bindkey '^n' ncmpcppShow

#History
[[ -n "^[[A"   ]]  && bindkey  "^[[A"    history-beginning-search-backward
[[ -n "^[[B" ]]  && bindkey  "^[[B"  history-beginning-search-forward

typeset -Ag FG BG
RESET="%{[00m%}"
for color in {0..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done


#Prompt style
setopt PROMPT_SUBST
export PS1="$FG[236]$BG[235]$FG[9] %~ $FG[235]$BG[1]$FG[0]\$(__git_ps1 '  %s')$RESET$FG[1] $RESET"
#PROMPT="$FG[2]$BG[0] %~$FG[8] ❯$FG[2]❯$RESET "
unset FG BG RESET


#Misc
bindkey -v #vim-mode
bindkey -M vicmd 'j' history-beginning-search-backward
bindkey -M vicmd 'k' history-beginning-search-forward

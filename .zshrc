source ~/.git-prompt.sh

[[ $- != *i* ]] && return

#loading
autoload -U colors && colors
autoload -Uz compinit promptinit
compinit
promptinit; prompt gentoo

#completion
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#dircolors directory (default /etc/DIR_COLORS)
eval "$(dircolors ~/.dircolors)";

ttyctl -f

#PATH
export PATH="$PATH:/home/lucas/.bin/"

#ENV
export KEYTIMEOUT=1
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history

#Aliases
alias ls='ls++'
alias grep="grep --color=auto"
alias shutdown='sudo shutdown -P 0'
alias reboot='sudo reboot'
alias ..='cd ..'

#custom functions

function mkcdir() {
    /bin/mkdir -p $@ && cd "$_"
}



#ncmpcpp script
ncmpcppShow() { ncmpcpp <$TTY; zle redisplay; }
zle -N ncmpcppShow
bindkey '^n' ncmpcppShow

#irssi script
irssiShow() { irssi <$TTY; zle redisplay; }
zle -N irssiShow
bindkey '^e' irssiShow


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

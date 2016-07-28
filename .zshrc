source ~/.git-prompt.sh

[[ $- != *i* ]] && return

#dircolors directory (default /etc/DIR_COLORS)
eval "$(dircolors ~/.dircolors)";

ttyctl -f
zstyle ':completion:*' rehash true

#PATH
export PATH="$PATH:/home/lucas/.bin/"

#ENV
export KEYTIMEOUT=1
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

#Aliases
alias ls='ls --color=always -h'
alias shutdown='sudo shutdown -P 0'
alias reboot='sudo reboot'
alias ..='cd ..'
alias eduroam='sudo netctl start eduroam'
alias appart='sudo netctl start xx_kevin_xx'
alias maison='sudo netctl start Livebox-Tramole'
alias rmtorrents='rm ~/Downloads/Torrent/.torrent_files'
alias mvtorrents='mv ~/Downloads/Firefox/*.torrent ~/Downloads/Torrent/.torrent_files'
alias colemak='setxkbmap us -variant colemak'

alias install='sudo pacman -S $1'
alias search='pacman -Ss $1'
alias update='sudo pacman -Syu'
alias upgrade='sudo pacman -Syyu'
alias remove='sudo pacman -Rs $1'
alias cleanup='sudo pacman -Rs $(pacman -Qdtq)'


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

autoload -U colors && colors

typeset -Ag FG BG
RESET="%{[00m%}"
for color in {0..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done


#Prompt style
setopt PROMPT_SUBST
#export PS1="$FG[236]$BG[235]$FG[9] %~ $FG[235]$BG[1]$FG[0]\$(__git_ps1 '  %s')$RESET$FG[1] $RESET"
PROMPT="$FG[2]$BG[0] %~$FG[8] ❯$FG[2]❯$RESET "



unset FG BG RESET



if [ -z "${FASTFETCH_SHOWN:-}" ]; then
  export FASTFETCH_SHOWN=1
  clear
  command -v fastfetch >/dev/null && fastfetch
fi

export EDITOR="nvim"
export VISUAL="nvim"
alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/.config/lazydocker:/.config/jesseduffield/lazydocker lazyteam/lazydocker'
alias w='curl wttr.in/harlow'

alias set1080p='xrdb -merge ~/.Xresources-1080p && xrandr --dpi 96 && i3-msg restart'
alias lg="lazygit"

alias grh='git reset HEAD~1'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gs='git stash'
alias gdtc='git diff --staged | xclip -selection clipboard'

alias ws='windsurf . && exit'
alias wsb='windsurf ~/.bashrc'
alias wsi3='windsurf ~/.config/i3/config'
alias wst='windsurf ~/.tmux.conf'

alias mark='~/Scripts/find/mark-here.sh'

alias penv='source venv/bin/activate'
alias pdisactivate='deactivate'

## K8s
alias kubectl='minikube kubectl --'

# Tells bash to append to history everytime prompt is show
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# examples

# if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
# 	exec tmux
# fi

#export FZF_DEFAULT_COMMAND='find . -type f ! -path "*git*"'
export FZF_DEFAULT_COMMAND='fdfind . ~ --hidden'
export FZF_DEFAULT_OPTS='-i --height=50% --header="CTRL-c or ESC to quit" '

eval "$(jump shell)"
g() {
	search="'$*'"
	xdg-open "http://www.google.com/search?q=$search"
}

alias cf='cat $(fzf)'
alias vs="vagrant status"

#google() {
#    search=""
#    echo "Googling: $@"
#    for term in $@; do
#        search="$search%20$term"
#    done
#    xdg-open "http://www.google.com/search?q=$search"
#}

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$\n '
if [ "$color_prompt" = yes ]; then
	PS1='[\[\e[38;5;202m\]\u\[\e[0m\]@\[\e[38;5;41m\]$(ip route get 1.1.1.1 | awk -F"src " '"'"'NR == 1{ split($2, a," ");print a[1]}'"'"')\[\e[0m\]]-[TTY:\l]-[\[\e[38;5;48m\]\w\[\e[0m\]]-[\[\e[3m\]$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)\[\e[0m\]]\n '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls -l --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# ADDITIONS #

# tmux

htmux() {
	echo t='tmux'
	echo -- list tmux sessions
	echo tls='tmux ls'
	echo -- connect to tmux session
	echo tat='tmux a -t'
	echo -- create a tmux session with a given name
	echo "tcs=tmux new -s <session-name>"
	echo -- rename tmux session
	echo "trs='tmux rename-session' -t <current-name> <new-name>"
	echo "-- kill session <name>"
	echo "tkst='tmux kill-ses -t <current-name>"
	echo -- kill all sessions but current
	echo tksa='tmux kill-session -a'
}

alias rmi='rm -rf -i'
alias ta='tmux a'
alias t='tmux'
alias tat='tmux a -t'
alias tls='tmux ls'
alias tcs='tmux new -s'
alias trs='tmux rename-session -t'
alias tks='tmux kill-ses -t'
alias tksa='tmux kill-session -a'

alias te='vim ~/.tmux.conf'
# Edit bash
alias be='vim ~/.bashrc'
# Update bash source
alias bu='source ~/.bashrc'

alias i3e='vim ~/.config/i3/config'
alias oe='vim ~/Obsidian/.obsidian.vimrc'

alias ..='cd ..'

alias cdb='cd ..'
alias cdf='cd -'
alias desktop='ssh lewis@badrobot'
alias laptop='ssh lewis@192.168.8.3'
alias remotebox='ssh lewis@remotebox'
alias pi='ssh pi@192.168.8.4'
alias sl='sudo $(history -p !!)'
alias apt-list-installedbyme='comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n '\''s/^Package: //p'\'' | sort -u)'
alias sys_update='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean -y'
alias gpom='git push origin main'
alias gss='git status'
alias gc='git commit -m'
alias gaa='git add .'
alias gf='git fetch'
alias gd='git diff'
alias tsc='npx tsc'
#it config --global alias.discard "! git stash -q --include-untracked && git stash drop -q"
#stashes untracked and drops them
alias gdis='git discard'
alias gaA='git add -A'
alias gb='git branch'
alias gba='git branch -a'
alias gpo='git prune origin'
alias glo='git log --oneline'
alias gunstage="git reset HEAD"
# alias nm='sudo nmtui'
alias gcm='git checkout main'
# alias vff='vim $(fdfind . ~ | fzf)'



## Find file from home
alias fd='cd $(fdfind . ~ --type d --hidden --max-depth 5 --exclude ".git" | fzf)'
alias ff='nvim $(fdfind . --type f --hidden --max-depth 5 --exclude ".git" | fzf)'
alias fft='npm run test "$(fdfind --glob "*test*" . --type f --max-depth 10 --exclude ".git" | fzf)"'




## Find anything from root
# alias rf='$(fdfind . / --hidden | fzf)'
## find directory from home
# alias df='cd $(fdfind . ~ --type directory --hidden | fzf)'
## Find dir from root
alias fr='cd $(fdfind . / --type directory --hidden | fzf)'
# alias af='$(cat ~/.bashrc | grep "^alias" | grep -v "#" | sed "s/alias //"| fzf)'

# alias bopen='cd $books_dir; bn="$(find . -type f | fzf)"; zathura "${bn}" & disown -h'

bf() {
	books_dir="$HOME/Downloads"
	cd "$books_dir" || return
	bn="$(find . -type f | fzf)"
	if [ -n "$bn" ]; then
		zathura "$bn" &
		disown -h
	fi
}

hf() {
    local cmd
    cmd=$(history | awk '{$1=""; print $0}' | fzf --tac --tiebreak=index --select-1 --exit-0 | sed 's/^ *//')
    if [ -n "$cmd" ]; then
        history -s "$cmd"  # Add to history
        eval "$cmd"        # Execute the command
    fi
}

af() {
	val=$(grep "^alias" ~/.bashrc | grep -v "#" | sed "s/alias //" | fzf)
	alias=$(echo "$val" | sed 's/alias //' | sed 's/=.*//')
	xdotool type "$alias"
	tput el1
	echo
	# echo "$alias"
}

alias nrd='npm run dev'
alias vim='nvim'
alias v='nvim'
#alias findtempanddelete='find . -type f -name '#*' -or -name "*~" -exec rm {} \;'

helpdocker() {
	echo "--"
}

helpdockerswarm() {
	echo "--- Add DOCKER_HOST"
	echo "export DOCKER_HOST=SSH://user@ip"
	echo "--- Init docker swarm"
	echo "sudo docker swarm init --advertise-addr 192.168.2.151"
	echo "--- Add a worker to this swarm"
	echo "docker swarm join --token <TOKEN> <IP>:2377"
	echo "--- Add a manager to the swarm"
	echo "docker swarm join-token manager"
	echo "--- Display all nodes in a swarm"
	echo "docker node ls"
	echo "--- Display docker service"
	echo "docker service ls"
	echo "--- Leave a swarm"
	echo "docker swarm leave"
}

# Remember and navigate to previous directories
export CDHISTFILE=~/.cd_history
cd() { builtin cd "$@" && pwd >| "$CDHISTFILE"; }
cdl() { [ -f "$CDHISTFILE" ] && cd "$(cat "$CDHISTFILE")"; }

# cat file.txt | c - Copy file contents to clipboard
# echo "text" | c - Copy text to clipboard
# p - Paste from clipboard
# p > file.txt - Paste to a file
# Copy to clipboard
if command -v xclip &> /dev/null; then  # Linux with X11
    alias c='xclip -selection clipboard'
    alias p='xclip -o -selection clipboard'
elif command -v pbcopy &> /dev/null; then  # macOS
    alias c='pbcopy'
    alias p='pbpaste'
fi

alias di='docker image'

alias dip='docker pull'
alias dcps='docker ps'
alias dca='docker ps --all'
alias dc='docker container ls'
alias dcka='docker ps -a -q | xargs sudo docker kill'
alias dcsto='docker ps -aq | xargs docker stop | xargs docker rm'
alias dcon='docker container'
alias dcrma='docker ps -a -q | xargs docker rm'
alias dcrm='docker container remove'
alias dcr='docker container run'
# alias dcd='sudo docker container run -d'
alias dcrrm='docker container run --rm'
alias dcrit='docker container run -it'
alias dcsta='docker container start'
alias dcl='docker container logs'
alias dcp='docker container top'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
# alias dconlf='sudo docker container -f'
# alias dcsh='sudo docker container exec -it'

dprune() {
	docker container prune && docker volume prune && docker network prune
}

dconlf() {
	docker container logs "${1}" -f
}

dcsh() {
	docker container exec -it "${1}" sh
}
alias di='docker images'
alias dirma='docker rmi -f $(sudo docker images -aq)'
alias dirm='docker rmi -f'
alias dii='docker image inspect'
alias dih='docker image history'
dib() {
	docker image build --tag "$1" .
}

alias dv='docker volume'
alias dvc='docker volume create'
alias dvrm='docker volume rm'
alias dvls='docker volume ls'
alias dvp='docker volume prune'

alias dn='docker network'
alias dnls='docker network ls'
alias dnrm='docker network rm'
alias dnp='docker network prune'

alias dcom='docker compose'
alias dcomu='docker compose up -d'
alias dcomd='docker compose down'

alias grpo='git remote prune origin'
# dcrit ourfiglet bash
# sudo docker container top <container-name> - displays processes
# sudo docker swarm init --advertise-addr $(hostname -i)
# sudo docker node ls - check nodes in swarm
# sudo docker image inspect <name/id>
# sudo docker image history <image ID> - displays history when creating image
# sudo docker container commit - turns container into image
# sudo docker image tag <ID> <repo>

gbd() {
	git branch -d "$1"
}

gcb() {
	git checkout -b "$1"
}
alias gal='git config --global -l'
alias dotfiles='cd ~/dotfiles && gaA'
alias ..='cd ..'

alias hdmion='xrandr --output HDMI-0 --mode 1280x1024 --right-of DVI-0'
alias hdmioff='xrandr --output HDMI-0 --off'

myip() {
	dig +short myip.opendns.com @resolver1.opendns.com
}

#trim whitespace
#ip="${ip:0}"
backtrace() {
	ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
	traceroute "$ip"
}

paste() {
	echo "$(xclip -o)"
}

copy() {
	echo "st the clipboard" | xclip
}

# af() {
# 	alias | grep "$1"
# }

mf() {
	man "$1" | grep "$2"
}

pf() {
	ps aux | grep "$1"
}
# Search history
# hf() {
# 	history | grep "$1"
# }

ytdl() {
	yt-dlp -f 'bestvideo[height<=380]+bestaudio/best[height<=380]' "$(xclip -o)" -o "%(playlist_index)s %(title)s.%(ext)s"
}

f() {
	find . -name "*${1}*"
}

desktop='lewis@BadRobot:~'
laptop='lewis@thinkerton:~'
remotebox='lewis@remotebox:~'
pi='pi@192.168.8.4:~'

fsend() {
	command='scp'

	if [ ! -e $1 ]; then
		echo "Given file $1 doesnt exit"
		return
	fi
	# if arg 1 is a dir or folder
	command+=' '
	echo "$command"
	if [ -d $1 ]; then
		command+='-r '
	fi
	command+="$1 "

	if [ $2 = "desktop" ]; then
		command+="$desktop"
	elif [ $2 = "pi" ]; then
		command+="$pi"
	elif [ $2 = "laptop" ]; then
		command+="$laptop"
	elif [ $2 = 'remotebox' ]; then
		command+="$remotebox"
	else
		echo "Unknown destination"
		return
	fi
	$command
}
#dsend

# Set screen brightness
#test=0
b() {
	echo "$1" | sudo tee /sys/class/backlight/intel_backlight/brightness
	test="$1"
	#echo "$test"
}

set -o vi

umask 0002

# chown chgrp example
# chown -R owner:group dir
# chown owner dir/file
# chgroup group dir/file

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

##### TERRAFORM
alias "tfi"="terraform init"
alias "tp"="terraform plan"
alias "tfa"="terraform apply -auto-approve"
alias "tfd"="terraform destroy -auto-approve"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Downloads/android-studio/bin:$PATH"

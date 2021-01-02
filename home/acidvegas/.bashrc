[[ $- != *i* ]] && return

shopt -s checkwinsize

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GPG_TTY=$(tty)

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
	source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls='ls --color=auto'

alias ..='cd ../'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias clbin='curl -F "clbin=<-" https://clbin.com'
alias dump='setterm -dump 1 -file screen.dump'
alias dyn='curl "https://dynamicdns.park-your-domain.com/update?host=pi&domain=CHANGEME.com&password=CHANGEME&ip=$(curl -s ipecho.net/plain)"'
alias exa='exa -aghl --git'
alias maint='~/.scripts/maint'
alias mtm='mtm -t mtm-256color'
alias pinstall='pip install --user'
alias pubkey='ssh-keygen -y -f ~/.ssh/key'
alias pydebug='python -m trace -t'
alias rmexif='for IMAGE in $(find ./ -type f \( -iname *.gif -o -iname *.jpg -o -iname *.jpeg -o -iname *.png \)); do exiftool -all= $IMAGE; done'
alias ssh-add='ssh-add -t 1h'
alias su='su -l'
alias todo='~/.scripts/todo'
alias y2m='youtube-dl --extract-audio --audio-format mp3 --audio-quality 0  -o "%(title)s.%(ext)s" --no-cache-dir --no-call-home'

color() {
	for color in {0..255}; do
		printf "\e[48;5;%sm  %3s  \e[0m" $color $color
		if [ $((($color + 1) % 6)) == 4 ]; then
			echo
		fi
	done
}

rnd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

title() {
	echo -ne "\033]0;$1\007"
}

transfer() {
	TMP=$(mktemp -t transferXXX)
	curl -H "Max-Downloads: 1" -H "Max-Days: 1" --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $TMP
	cat $TMP
	rm -f $TMP
}

update() {
	sudo pacman-key --refresh-keys
	sudo mount -o remount,rw /boot && sudo pacman -Syyu && sudo mount -o remount,ro /boot
	sudo pacman -Rns $(pacman -Qtdq)
	sudo pacman -Scc
	for d in $(find $HOME/dev/git/mirrors -type d -name .git); do
		cd $(dirname $d) && git pull
	done;
}

export PS1="\[\033[95m\]\u@\h \[\033[32m\]\W\[\033[33m\] [\$(git symbolic-ref --short HEAD 2>/dev/null)]\[\033[00m\]\$ "

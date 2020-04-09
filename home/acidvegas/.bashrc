[[ $- != *i* ]] && return

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GPG_TTY=$(tty)

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
	eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
fi

alias ..='cd ../'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias clbin='curl -F \'clbin=<-\' https://clbin.com'
alias diff='diff --color=auto'
alias dump='setterm -dump 1 -file screen.dump'
alias dyn='curl "https://dynamicdns.park-your-domain.com/update?host=pi&domain=CHANGEME.com&password=CHANGEME&ip=$(curl -s ipecho.net/plain)"'
alias exa='exa -aghl --git'
alias google='~/dev/build/googler/googler --colors hgdhhh --noprompt'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
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

audiosrc() {
	if [ $1 = 'auto' ]; then
		amixer cset numid=3 0
	elif [ $1 = 'aux' ]; then
		amixer cset numid=3 1
	elif [ $1 = 'hdmi' ]; then
		amixer cset numid=3 2
	else
		echo "invalid option! (must be auto, aux, or hdmi)"
	fi
}

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

shat() {
	echo -n $1 | shasum -a 512
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
	cd $HOME/dev/build/googler && git pull
}


prompt() {
	# note: detect ssh connection properly to display hostname
	local _branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')"
	if [[ "$TERM" = "st-256color" ]]; then
		PS1="\e[38;5;237m\T\e[0m \e[38;5;41m\u@\h\e[0m \e[38;5;69m\w\e[0m\e[35m$_branch\e[0m : "
	else
		PS1="\e[90m\T\e[0m \e[32m\u@\h\e[0m \e[94m\w\e[0m\e[35m$_branch\e[0m : "
	fi
}

export PROMPT_COMMAND=prompt
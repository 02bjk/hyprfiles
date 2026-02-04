####################
#credits to chris titus for functions of this scripts 
####################
get_color() { tput setaf "$1"; }

# Can be changed to whatever color number you want (0-15)
COL_USER="${color4:-$(get_color 12)}"     # Yellow-ish
COL_HOST="${color6:-$(get_color 5)}"      # Blue-ish
COL_PATH="${color2:-$(get_color 11)}"     # Cyan/Green-ish
COL_ROOT="${color1:-$(get_color 1)}"      # Red
COL_RESET="$(tput sgr0)"

#!/usr/bin/env bash
iatest=$(expr index "$-" i)
# bashrc

[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
#######################################################
# SOURCED ALIAS'S AND SCRIPTS BY zachbrowne.me
#######################################################
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

# Expand the history size
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Seeing as other scripts will use it might as well export it
export LINUXTOOLBOXDIR="$HOME/linuxtoolbox"

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias pico='edit'
alias spico='sedit'
alias snano='sedit'
alias vim='nvim'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias grep='rg'
alias bashrc='nvim ~/.bashrc'
#alias sudo='pkexec'


# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1


# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'
export SSH_CONFIG_FILE="$HOME/.local/.ssh/config"

# Alias's to change the directory
alias web='cd /var/www/html'

# Alias's to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)

#######################################################
# GENERAL ALIAS'S
#######################################################
# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#Edit hyprland config
alias hyprconf='nvim ~/.config/hypr/hyprland.conf'
alias hypr='nvim ~/.config/hypr/'

#pacman & paru alias
alias sp='sudo pacman -Ss'
alias rns='sudo pacman -Rns'
alias pac='sudo pacman -S'

# Alias's to modified commands
alias cp='cp -vi'
alias mv='mv -vi'
alias cpv='rsync -avh --info=progress2'
#alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'

#git alias
alias gst='git status'
alias gdf='git diff'
alias gmt='git commit -m'

#Change directory aliases
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

#cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'


# Search running processes
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"


# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'


# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)

alias kssh="kitty +kitten ssh"

# alias to cleanup unused docker containers, images, networks, and volumes

alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls -l
	else
		builtin cd ~ && ls -l
	fi
}

# Returns the last 2 fields of the working directory
pwdtail() {
	pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show the current distribution
distribution () {
    local dtype="unknown"  # Default to unknown

    # Use /etc/os-release for modern distro identification
    if [ -r /etc/os-release ]; then
        source /etc/os-release
        case $ID in
            fedora|rhel|centos)
                dtype="redhat"
                ;;
            sles|opensuse*)
                dtype="suse"
                ;;
            ubuntu|debian)
                dtype="debian"
                ;;
            gentoo)
                dtype="gentoo"
                ;;
            arch|manjaro)
                dtype="arch"
                ;;
            slackware)
                dtype="slackware"
                ;;
            *)
                # Check ID_LIKE only if dtype is still unknown
                if [ -n "$ID_LIKE" ]; then
                    case $ID_LIKE in
                        *fedora*|*rhel*|*centos*)
                            dtype="redhat"
                            ;;
                        *sles*|*opensuse*)
                            dtype="suse"
                            ;;
                        *ubuntu*|*debian*)
                            dtype="debian"
                            ;;
                        *gentoo*)
                            dtype="gentoo"
                            ;;
                        *arch*)
                            dtype="arch"
                            ;;
                        *slackware*)
                            dtype="slackware"
                            ;;
                    esac
                fi

                # If ID or ID_LIKE is not recognized, keep dtype as unknown
                ;;
        esac
    fi

    echo $dtype
}


# Show the current version of the operating system
ver() {
    local dtype
    dtype=$(distribution)

    case $dtype in
        "redhat")
            if [ -s /etc/redhat-release ]; then
                cat /etc/redhat-release
            else
                cat /etc/issue
            fi
            uname -a
            ;;
        "suse")
            cat /etc/SuSE-release
            ;;
        "debian")
            lsb_release -a
            ;;
        "gentoo")
            cat /etc/gentoo-release
            ;;
        "arch")
            cat /etc/os-release
            ;;
        "slackware")
            cat /etc/slackware-version
            ;;
        *)
            if [ -s /etc/issue ]; then
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                exit 1
            fi
            ;;
    esac
}

# Automatically install the needed support files for this .bashrc file
install_bashrc_support() {
	local dtype
	dtype=$(distribution)

	case $dtype in
		"redhat")
			sudo yum install multitail tree zoxide trash-cli fzf bash-completion fastfetch
			;;
		"suse")
			sudo zypper install multitail tree zoxide trash-cli fzf bash-completion fastfetch
			;;
		"debian")
			sudo apt-get install multitail tree zoxide trash-cli fzf bash-completion
			# Fetch the latest fastfetch release URL for linux-amd64 deb file
			FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)

			# Download the latest fastfetch deb file
			curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb

			# Install the downloaded deb file using apt-get
			sudo apt-get install /tmp/fastfetch_latest_amd64.deb
			;;
		"arch")
			sudo paru multitail tree zoxide trash-cli fzf bash-completion fastfetch blesh
			;;
		"slackware")
			echo "No install support for Slackware"
			;;
		*)
			echo "Unknown distribution"
			;;
	esac
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip () {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}

# View Apache logs
apachelog() {
	if [ -f /etc/httpd/conf/httpd.conf ]; then
		cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
	else
		cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
	fi
}

# Edit the Apache configuration
apacheconfig() {
	if [ -f /etc/httpd/conf/httpd.conf ]; then
		sedit /etc/httpd/conf/httpd.conf
	elif [ -f /etc/apache2/apache2.conf ]; then
		sedit /etc/apache2/apache2.conf
	else
		echo "Error: Apache config file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate httpd.conf && locate apache2.conf
	fi
}


# Edit the MySQL configuration file
mysqlconfig() {
	if [ -f /etc/my.cnf ]; then
		sedit /etc/my.cnf
	elif [ -f /etc/mysql/my.cnf ]; then
		sedit /etc/mysql/my.cnf
	elif [ -f /usr/local/etc/my.cnf ]; then
		sedit /usr/local/etc/my.cnf
	elif [ -f /usr/bin/mysql/my.cnf ]; then
		sedit /usr/bin/mysql/my.cnf
	elif [ -f ~/my.cnf ]; then
		sedit ~/my.cnf
	elif [ -f ~/.my.cnf ]; then
		sedit ~/.my.cnf
	else
		echo "Error: my.cnf file could not be found."
		echo "Searching for possible locations:"
		sudo updatedb && locate my.cnf
	fi
}


# Trim leading and trailing spaces (for scripts)
trim() {
	local var=$*
	var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
	var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
	echo -n "$var"
}


function hb {
    if [ $# -eq 0 ]; then
        echo "No file path specified."
        return
    elif [ ! -f "$1" ]; then
        echo "File path does not exist."
        return
    fi

    uri="http://bin.christitus.com/documents"
    response=$(curl -s -X POST -d @"$1" "$uri")
    if [ $? -eq 0 ]; then
        hasteKey=$(echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Failed to upload the document."
    fi
}

#######################################################
# Set the ultimate amazing command prompt
#######################################################

# Check if the shell is interactive
if [[ $- == *i* ]]; then
    # Bind Ctrl+f to insert 'zi' followed by a newline
    bind '"\C-f":"zi\n"'
fi

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"


#PS1="\n\e[0;33m  \e[0;32m\w       \u       :     \n\e[0;33m \e[0;32m  \e[0;37m"
#PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$  \n   "
if [ "$EUID" -eq 0 ]; then
  PS1="┌──[\[${COL_ROOT}\]\u@${COL_HOST}\h\[${COL_RESET}\]]─[\[${COL_PATH}\]\w\[${COL_RESET}\]]\n└─\[${COL_PATH}\]# \[${COL_RESET}\]"
else
  PS1="┌──[\[${COL_USER}\]\u@${COL_HOST}\h\[${COL_RESET}\]]─[\[${COL_PATH}\]\w\[${COL_RESET}\]]\n└─\[${COL_PATH}\]\$ \[${COL_RESET}\]"
fi
force_color_prompt=yes

export PATH="$PATH:$HOME/platform-tools"

export PATH=$PATH:"$HOME/.spicetify"

[[ ${BLE_VERSION-} ]] && ble-attach

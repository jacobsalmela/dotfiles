#######################
##### HISTORY #########
#######################
# History file size
HISTFILESIZE=65535

# Write history to .bash_history right away instead of storing it in RAM and appending after the session
export PROMPT_COMMAND='history -a'

# Add a timestamp to the history entries
HISTTIMEFORMAT="%Y-%m-%d %T "

# Delete duplicate commands
HISTCONTROL="erasedups:ignoreboth"

# Append history
shopt -s histappend

# Save multi-line commands as one line in history
shopt -s cmdhist

#######################
##### ALIASES #########
#######################
# Long listing
alias ll='ls -l'

# Make directory and move into it (creating parent directories if they do not exist).
md () { mkdir -p "$@" && cd "$@"; }

# Show or hide all files
alias showall='defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder'
alias hideall='defaults write com.apple.finder AppleShowAllFiles FALSE;killall Finder'
	
# Find the current gateway (router)
alias gw='netstat -rn | awk '/default/ {print $2}''
	
# Delete the last command
alias dlc='history -d $((HISTCMD-1))'
	
# Ethernet IP address
alias eip='ifconfig en0 | grep inet | cut -d: -f2 | awk '{print $2}''
	
# Wireless IP address
alias wip='ifconfig en1 | grep inet | cut -d: -f2 | awk '{print $2}''
	
# Last shutdown time
alias lshut='last | awk '/shutdown/ {print substr ($0, index($0, $3))}' | head -1'
	
# Last reboot time
alias lr='last | awk '/reboot/ {print substr ($0, index($0, $3))}' | head -1'
	
# Eject all network shares
alias en='find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 umount'

# Eject all external storage	
alias es='find /Volumes -maxdepth 1 -not -user root -print0 | xargs -0 diskutil eject'
	
# Airport utility
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'	
	
# View open network connections
alias lsn='lsof -i | grep ESTABLISHED'

# Click
function clik() { /usr/bin/click -x "$1" -y "$2" ;}
	
# View most used commands
muc='history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -15'

############################################ 
# Modified from emilis bash prompt script 
# from https://github.com/emilis/emilis-config/blob/master/.bash_ps1 
# 
# Modified for Mac OS X by 
# @corndogcomputer 
###########################################
# Fill with minuses
# (this is recalculated every time the prompt is shown in function prompt_command):
fill="—- "

reset_style='\[\033[00m\]'
status_style=$reset_style'\[\033[0;90m\]' # gray color; use 0;37m for lighter color
prompt_style=$reset_style
command_style=$reset_style'\[\033[1;29m\]' # bold black
# Prompt variable:

PS1="$status_style"'$fill \t\n'"$prompt_style"'${debian_chroot:+($debian_chroot)}\u@\h:\w\$'"$command_style "

# Reset color for command output
# (this one is invoked every time before a command is executed):
trap 'echo -ne "\033[00m"' DEBUG

function prompt_command {
	# create a $fill of all screen width minus the time string and a space:
	let fillsize=${COLUMNS}-9
	fill=""
	while [ "$fillsize" -gt "0" ]
	do
		fill="-${fill}" # fill with underscores to work on
		let fillsize=${fillsize}-1
	done

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*) bname=`basename "${PWD/$HOME/~}"`;
			echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007";;
		*);;
	esac
	}

PROMPT_COMMAND=prompt_command


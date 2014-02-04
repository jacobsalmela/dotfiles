# History file size
	HISTFILESIZE=65535

# Write history to .bash_history right away instead of storing it in RAM and appending after the session
	export PROMPT_COMMAND='history -a'

# Add a timestamp to the history entries
	HISTTIMEFORMAT="%y-%m-%d %T "

# Aliases

# Custom prompt
	PS1="\u in \W \A"

# Long listing
	alias ll='ls -l'
	
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
	
# View most used commands
	muc='history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -15'

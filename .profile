#!/bin/bash
#----------AUTHOR------------
	# Jacob Salmela
	# 21 June 2013
	# https://github.com/jakesalmela/

#----------RESOURCES---------
	# http://jablonskis.org/2011/howto-log-bash-history-to-syslog/
	# http://bashify.com/?Useful_Techniques:Constant_Variables

#---------DESCRIPTION--------
	# This runs in Single-User Mode automatically and gets an IP address
	# Use in conjunction with GeekTool to know when someone boots into this mode by repeatedly pinging the IP address via a geeklet

#-----------USAGE------------
	# To run: 
	#
	#	Just save the file as /var/root/.profile 
	#
	# It will run automatically any time Single-User Mode is launched
	# It can be cancelled by an admin using Ctrl C	

#----------VARIABLES---------
	# Variables are for proof-of-concept script and to reduce overall processing time
	# Change these according to your environment:
	
	# Manually set ethernet device ID
	ethernetID="en0"	
	
	# Put static IPv4 with subnet mask here
	ethernetIP="10.x.x.x 255.255.0.0"
		
	# Organization name (reverse-domain plist format)
	orgName="org.hopkinsschools.casper"
	
	# Capture date for storing in custom plist
	currentDate=$(date "+%Y-%m-%d %H:%M:%S")
	
#----------FUNCTIONS---------
#######################
function mountAndLoad()
  {
	# Mounts the volume as read-write--skipping the fsck for speed
	/sbin/mount -uw /

	# Loads daemons needed for networking in SUM
	launchctl load /System/Library/LaunchDaemons/com.apple.kextd.plist
	launchctl load /System/Library/LaunchDaemons/com.apple.notifyd.plist
	launchctl load /System/Library/LaunchDaemons/com.apple.configd.plist

	# Sleep to allow the NIC to initialize
	sleep 15
	
	# Needed to send messages to the system log
	launchctl load /System/Library/LaunchDaemons/com.apple.syslogd.plist
	}

##########################
function setWiredAddress()
	{
	# Set a static IP
	ipconfig set $ethernetID INFORM $ethernetIP	
	}
	
##########################
function setPromptCommand()
	{
	# Appends any commands entered into the syslog with the tag SUM-IDS
	PROMPT_COMMAND='history -a;tail -n1 ~/.sh_history | logger -t SUM-IDS'
	}
	
##########################
function logDateInPlist()
	{
	# Delete previous value if it exits
	/usr/libexec/PlistBuddy -c "Print :SingleUserModeAccessedOn" /Library/Preferences/"$orgName".plist &>/dev/null
	
	# If the last command exited with 0 (meaning the key exists)
	if [ $? = 0 ];then
		# Delete previous value and write in the updated date
		/usr/libexec/PlistBuddy -c "Delete :SingleUserModeAccessedOn" /Library/Preferences/"$orgName".plist &>/dev/null
		/usr/libexec/PlistBuddy -c "Add :SingleUserModeAccessedOn string '$currentDate'" /Library/Preferences/"$orgName".plist &>/dev/null	
		
	else
	
		# Otherwise, create an entry with the current date
		/usr/libexec/PlistBuddy -c "Add :SingleUserModeAccessedOn string '$currentDate'" /Library/Preferences/"$orgName".plist &>/dev/null
	fi
	}
	
#---------------------------------#
#---------------------------------#
#----------SCRIPT BEGINS----------#
#---------------------------------#
#---------------------------------#
if [ $TERM = "vt100" ];then
	mountAndLoad
	setWiredAddress
	setPromptCommand
	logDateInPlist
fi

sudo cp ~/Library/LaunchAgents/com.coredns.plist /Library/LaunchDaemons/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.coredns.plist
